import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:desaihomes_crm_application/presentations/new_whatsapp_screen/controller/new_whatsapp_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../app_config/app_config.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/textstyles.dart';
import '../../../../global_widgets/custom_button.dart';
import '../../../../repository/api/login_screen/pusher_service.dart';
import '../../../../repository/api/whatsapp_screen/model/chat_model.dart';
import '../../../../repository/api/whatsapp_screen/model/template_model.dart';
import 'message_widget.dart';
import 'preview_screen.dart';
import 'template_widget.dart';

class ChatScreenCopy extends StatefulWidget {
  const ChatScreenCopy(
      {super.key,
      required this.name,
      required this.leadId,
      required this.contactedNumber});
  final String name;
  final String contactedNumber;
  final int leadId;

  @override
  State<ChatScreenCopy> createState() => _ChatScreenCopyState();
}

class _ChatScreenCopyState extends State<ChatScreenCopy> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PusherService _pusherService = PusherService();

  bool isRecording = false;
  bool isTyping = false;
  bool isAttachmentOpen = false;
  bool isTemplateOpen = false;
  final _audioRecorder = AudioRecorder();
  String? recordedFilePath;
  String loggedInUserId = "";

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
    _loadUserId();
    _pusherService.subscribeToChannelWithId(
        widget.leadId.toString(), _handleNewMessage, context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      Provider.of<WhatsappControllerCopy>(context, listen: false)
          .fetchChats(widget.leadId, context);
    });
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    _pusherService.unsubscribe();
    super.dispose();
  }

  void _handleNewMessage(dynamic data) {
    try {
      final Map<String, dynamic> messageData = data;

      final newMessage = ChatModel(
          message: messageData['message'] ?? '',
          mediaUrl: messageData['media_url'] ?? '',
          createdAt: DateTime.tryParse(messageData['created_at'] ?? '') ??
              DateTime.now(),
          messageType: messageData['type'] ?? 'received',
          msgType: messageData['msg_type'] ?? 'Text',
          name: messageData['name'] ?? ' ',
          messageId: messageData['message_id']);

      final whatsappController =
          Provider.of<WhatsappControllerCopy>(context, listen: false);

      whatsappController.addMessageToList(newMessage);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      log("Error handling new message: $e");
    }
  }

  void _onTextChanged() {
    setState(() {
      isTyping = _messageController.text.isNotEmpty;
    });
  }

  void toggleTemplate() {
    setState(() {
      isTemplateOpen = !isTemplateOpen;
      // Close attachment options if open
      if (isTemplateOpen) {
        isAttachmentOpen = false;
      }
    });
  }

  void toggleAttachment() {
    setState(() {
      isAttachmentOpen = !isAttachmentOpen;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage({
    String? text,
    String? templateName,
    String? templateContent,
    String? rawTemplateContent,
    Datum? templateData,
  }) async {
    final whatsappController =
        Provider.of<WhatsappControllerCopy>(context, listen: false);

    if (text != null && text.trim().isNotEmpty) {
      String? senderName = await getUserName();

      final newMessage = ChatModel(
          message: text,
          createdAt: DateTime.now(),
          messageType: "send",
          msgType: "Text",
          name: senderName);

      await whatsappController.addMessageToList(newMessage);

      await whatsappController.sendMessage(
          widget.contactedNumber, text, widget.leadId.toString(), context);

      _messageController.clear();
      setState(() => isTyping = false);

      _scrollToBottom();
    }

    if (templateName != null &&
        templateContent != null &&
        rawTemplateContent != null &&
        templateData != null) {
      try {
        String format = templateData.parameterFormat ?? "POSITIONAL";

        List<String> headers = [];
        String headerType = "";
        String? mediaUrl; // To store attachment URL if present

        for (var component in templateData.components ?? []) {
          if (component.type == "HEADER") {
            headerType = component.format.toLowerCase();

            // Debugging print
            print("Example Object: ${component.example?.toJson()}");

            // Get header handles (for attachments) or text
            if (component.example != null) {
              var exampleJson = component.example!.toJson();
              if (exampleJson.containsKey("header_handle")) {
                headers = List<String>.from(exampleJson["header_handle"] ?? []);
                if (headers.isNotEmpty) {
                  mediaUrl = headers.first; // Use the first URL as mediaUrl
                }
              }
            }
            break;
          }
        }

        await whatsappController.sendTemplateMessage(
            widget.contactedNumber,
            templateName,
            rawTemplateContent,
            widget.leadId.toString(),
            format,
            headers,
            headerType,
            context);

        await Provider.of<WhatsappControllerCopy>(context, listen: false)
            .fetchChats(widget.leadId, context);

        String? senderName = await getUserName();

        final newMessage = ChatModel(
            message: templateContent,
            createdAt: DateTime.now(),
            messageType: "send",
            msgType: headerType.isNotEmpty ? headerType.toUpperCase() : "Text",
            mediaUrl: mediaUrl,
            name: senderName);

        await whatsappController.addMessageToList(newMessage);
      } catch (e) {
        print("Error sending template message: $e");
      } finally {
        _messageController.clear();
        setState(() => isTyping = false);
        _scrollToBottom();
      }
    }
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    DateTime localTime = timestamp.toLocal();

    String period = localTime.hour >= 12 ? 'pm' : 'am';
    int hour12 = localTime.hour > 12
        ? localTime.hour - 12
        : (localTime.hour == 0 ? 12 : localTime.hour);

    return "${hour12.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}$period";
  }

  Future<void> _loadUserId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString(AppConfig.loggedInUserId) ?? "";

    log("Retrieved loggedInUserId: $userId");

    setState(() {
      loggedInUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            _clearChatAndPop(context);
            Provider.of<WhatsappControllerCopy>(context, listen: false)
                .fetchConversations(context);
            Provider.of<WhatsappControllerCopy>(context, listen: false)
                .fetchWhatsappLeads(context);
          },
          icon: Icon(Iconsax.arrow_left, color: Colors.black, size: 20.sp),
        ),
        title: Row(
          children: [
            CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 22.r,
                child: Text(
                  widget.name[0],
                  style: GLTextStyles.manropeStyle(
                    color: Colors.black,
                    size: 16.sp,
                  ),
                )),
            SizedBox(width: 12.w),
            Text(
              widget.name,
              style: GLTextStyles.manropeStyle(
                color: const Color(0xff170e2b),
                size: 18.sp,
              ),
            ),
          ],
        ),
        forceMaterialTransparency: true,
      ),
      body: Consumer<WhatsappControllerCopy>(builder: (context, controller, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
        // if (controller.chatList.isEmpty) {
        //   return Padding(
        //     padding: EdgeInsets.only(right: 16.w),
        //     child: Center(
        //       child: LoadingAnimationWidget.fourRotatingDots(
        //         color: const Color(0xff3893FF),
        //         size: 32,
        //       ),
        //     ),
        //   );
        // }
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: controller.chatList.length ?? 0,
                  itemBuilder: (context, index) {
                    final message = controller.chatList[index];
                    if (message == null) return const SizedBox();
                    final isMe = message.name == widget.name;
                    if (message.message != null &&
                        message.message!.isNotEmpty) {
                      return Align(
                        alignment:
                            isMe ? Alignment.centerLeft : Alignment.centerRight,
                        child: MessageWidget(
                          message: message,
                          isMe: isMe,
                          formattedTime: _formatTimestamp(message.createdAt),
                          senderName: message.name ?? "",
                          mediaUrl: message.mediaUrl ?? '',
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              Container(child: _buildMessageInput()),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path =
            '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        setState(() {
          isRecording = true;
          recordedFilePath = path;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission denied.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (path != null) {
        final file = File(path);

        final provider =
            Provider.of<WhatsappControllerCopy>(context, listen: false);

        String? senderName = await getUserName();

        final newMessage = ChatModel(
            message: path,
            createdAt: DateTime.now(),
            messageType: "send",
            name: senderName,
            msgType: "Audio");

        // Append the audio message to the chat list
        await provider.addMessageToList(newMessage);

        // Send the audio message via API
        provider.onSendMessage(
          context,
          file,
          "Audio",
          widget.contactedNumber,
          widget.leadId.toString(),
        );

        setState(() {
          isRecording = false;
          recordedFilePath = path;
        });

        _scrollToBottom();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error stopping recording: $e")),
      );
    }
  }

  Future<void> _handleImageMessage({bool fromCamera = false}) async {
    if (fromCamera) {
      // Camera functionality
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (image != null) {
        _navigateToPreview(File(image.path), "image");
      }
      return;
    }

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media, // This allows both images and videos
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final File file = File(result.files.single.path!);
      final String extension = file.path.split('.').last.toLowerCase();

      final String messageType =
          ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)
              ? "image"
              : "video";

      _navigateToPreview(file, messageType);
    }
  }

  void _navigateToPreview(File selectedMedia, String messageType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          file: selectedMedia,
          contactedNumber: widget.contactedNumber,
          leadId: widget.leadId.toString(),
          messageType: messageType,
        ),
      ),
    );
    isAttachmentOpen = false;
  }

  Future<void> _handleDocumentMessage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      File selectedFile = File(result.files.single.path!);
      _navigateToPreview(selectedFile, "document");
      isAttachmentOpen = false;
    }
  }

  Widget _buildAttachmentOptions() {
    return Container(
      width: 353.w,
      height: 90.h,
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8FF),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildAttachmentIcon(Iconsax.gallery5, "Gallery",
              const Color(0xff3874F6), _handleImageMessage),
          _buildAttachmentIcon(Iconsax.document5, "Document",
              const Color(0xffF63E38), _handleDocumentMessage),
          // _buildAttachmentIcon(
          //     Iconsax.location5, "Location", const Color(0xff64C685), () async {
          //   await _pickLocation();
          // }),
          // _buildAttachmentIcon(
          //     Icons.person, "Contact", const Color(0xffF69738), _pickContact),
          _buildAttachmentIcon(
              Icons.photo_camera,
              "Camera",
              const Color(0xff4A4A4A),
              () => _handleImageMessage(fromCamera: true)),
        ],
      ),
    );
  }

  Widget _buildAttachmentIcon(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(4.w),
            color: Colors.white,
            child: Icon(
              icon,
              color: color,
              size: 22.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GLTextStyles.manropeStyle(
              weight: FontWeight.w500,
              color: const Color(0xff000000),
              size: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _showTemplateModal(BuildContext context) {
    setState(() {
      isTemplateOpen = !isTemplateOpen;
      if (isTemplateOpen) {
        isAttachmentOpen = false;
      }
    });
  }

  void _showConfirmation(BuildContext context, String templateContent,
      String templateName, String rawTemplateContent, Datum template) {
    String headerType = "";
    List<String> headers = [];
    List<String> filePaths = [];

    /// Extract Header Type & Headers from Template Components
    for (var component in template.components ?? []) {
      if (component.type == "HEADER") {
        headerType = component.format.toLowerCase();

        if (headerType == "text") {
          headers = [component.text ?? ""];
        } else {
          final example = component.example?.toJson();
          headers = List<String>.from(example?["header_handle"] ?? []);

          // Get file_path if available
          if (example?["file_path"] != null) {
            if (example["file_path"] is String) {
              filePaths = [example["file_path"]];
            } else if (example["file_path"] is List) {
              filePaths = List<String>.from(example["file_path"]);
            }
          }
        }
        break;
      }
    }

    // Use file_path if available, otherwise fall back to header_handle
    final mediaUrls = filePaths.isNotEmpty ? filePaths : headers;
    final mediaUrl = mediaUrls.isNotEmpty ? mediaUrls.first : null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          title: const SizedBox(
            width: double.infinity, 
            child: Column(
              children: [Icon(Iconsax.warning_2, color: Color(0xffFF9C8E))],
            ),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to send this template?',
                    style: GLTextStyles.manropeStyle(
                      color: ColorTheme.blue,
                      size: 15.sp,
                      weight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  /// Header Preview Section
                  if (headerType == "image" && mediaUrl != null)
                    _buildImagePreview(context, mediaUrl),
                  if (headerType == "document" && mediaUrl != null)
                    _buildDocumentPreview(context, mediaUrl),
                  if (headerType == "text" && headers.isNotEmpty)
                    _buildTextPreview(headers.first),

                  /// Template Text Preview
                  _buildTemplatePreview(templateContent),
                ],
              ),
            ),
          ),
          actionsPadding:
              const EdgeInsets.only(right: 16, bottom: 16, left: 16),
          actions: <Widget>[
            CustomButton(
              borderColor: Colors.transparent,
              backgroundColor: const Color(0xffFFF2F0),
              text: "Cancel",
              textColor: const Color(0xffFF9C8E),
              onPressed: () {
                Navigator.of(context).pop();
                _messageController.clear();
              },
              width: (110 / ScreenUtil().screenWidth).sw,
            ),
            const SizedBox(width: 8),
            CustomButton(
              borderColor: Colors.transparent,
              backgroundColor: const Color(0xffECF5FF),
              text: "Send",
              textColor: const Color(0xff3893FF),
              width: (110 / ScreenUtil().screenWidth).sw,
              onPressed: () async {
                Navigator.of(context).pop();
                _sendMessage(
                  templateName: templateName,
                  templateContent: templateContent,
                  rawTemplateContent: rawTemplateContent,
                  templateData: template,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildImagePreview(BuildContext context, String imageUrl) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Image:',
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.blue,
              size: 14.sp,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            height: 200.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context, imageUrl),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Failed to load image'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentPreview(BuildContext context, String documentUrl) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document:',
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.blue,
              size: 14.sp,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FutureBuilder<String>(
              future: _downloadPdf(documentUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(height: 8),
                        Text('Failed to load document'),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: PDFView(
                      filePath: snapshot.data!,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: true,
                      pageFling: true,
                      onError: (error) {
                        print('PDF Error: $error');
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextPreview(String text) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Header Text:',
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.blue,
              size: 14.sp,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            text,
            style: GLTextStyles.manropeStyle(
              color: Colors.black87,
              size: 13.sp,
              weight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatePreview(String templateContent) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Template Preview:',
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.blue,
              size: 14.sp,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              templateContent,
              style: GLTextStyles.manropeStyle(
                color: Colors.black87,
                size: 13.sp,
                weight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _downloadPdf(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/temp_preview_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await Dio().download(url, filePath);
      return filePath;
    } catch (e) {
      print('Error downloading PDF: $e');
      throw e;
    }
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Failed to load image'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Map<String, String> getTemplateBodyText(Datum template, String widgetName) {
    if (template.components == null || template.components!.isEmpty) {
      return {
        "previewText": "No content available",
        "rawText": "No content available"
      };
    }

    final bodyComponent = template.components!.firstWhere(
      (component) => component.type == "BODY",
      orElse: () => Component(),
    );

    String rawTemplateText = bodyComponent.text ?? "No body text available";
    String previewTemplateText = rawTemplateText;

    if (template.parameterFormat == "POSITIONAL") {
      previewTemplateText = previewTemplateText.replaceAll("{{1}}", widgetName);

      if (bodyComponent.example != null &&
          bodyComponent.example!.bodyText != null &&
          bodyComponent.example!.bodyText!.isNotEmpty &&
          bodyComponent.example!.bodyText![0].isNotEmpty) {
        final exampleValues = bodyComponent.example!.bodyText![0];

        for (int i = 1; i < exampleValues.length; i++) {
          previewTemplateText =
              previewTemplateText.replaceAll("{{${i + 1}}}", exampleValues[i]);
        }
      }
    }
    return {
      "previewText": previewTemplateText, // Used for UI preview
      "rawText": rawTemplateText // Sent via API
    };
  }

  Widget _buildMessageInput() {
    return Consumer<WhatsappControllerCopy>(builder: (context, controller, _) {
      bool isChatEmpty = controller.chatList.isEmpty;
      DateTime? lastMessageTime;

      bool isPast24Hours = true;

      if (!isChatEmpty && controller.conversationModel.isNotEmpty == true) {
        lastMessageTime = DateTime.tryParse(
          controller.chatList.last.createdAt.toString(),
        );

        if (lastMessageTime != null) {
          final DateTime now = DateTime.now();
          final Duration difference = now.difference(lastMessageTime);
          isPast24Hours = difference.inHours >= 24;
        }
      }

      bool onlyTemplatesEnabled = isChatEmpty || isPast24Hours;

      return Stack(children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isAttachmentOpen && !onlyTemplatesEnabled
                  ? _buildAttachmentOptions()
                  : const SizedBox.shrink(),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
              child: isTemplateOpen
                  ? TemplateSelectionModal(
                      onTemplateSelected: (template) {
                        final templateContent =
                            getTemplateBodyText(template, widget.name);
                        setState(() {
                          _messageController.text = templateContent.toString();
                          isTemplateOpen = false;
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          final templateTexts =
                              getTemplateBodyText(template, widget.name);

                          _showConfirmation(
                              context,
                              templateTexts["previewText"]!,
                              template.name.toString(),
                              templateTexts["rawText"]!,
                              template);
                        });
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        cursorColor: const Color(0xff3874F6),
                        enabled: true,
                        readOnly: onlyTemplatesEnabled && !isTemplateOpen,
                        onTap: onlyTemplatesEnabled && !isTemplateOpen
                            ? () => _showTemplateModal(context)
                            : null,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _sendMessage(text: value);
                            _messageController.clear();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: onlyTemplatesEnabled
                              ? 'Select a template message'
                              : 'Send a message',
                          hintStyle: GLTextStyles.manropeStyle(
                            weight: FontWeight.w400,
                            color: const Color(0xffA4A4A4),
                            size: 14.sp,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(30, 153, 153, 153),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          suffixIcon: isTyping
                              ? null
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _showTemplateModal(context),
                                      icon: Icon(
                                        isTemplateOpen
                                            ? Icons.close_outlined
                                            : Iconsax.smallcaps,
                                        size: 21.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    if (!onlyTemplatesEnabled)
                                      Container(
                                        height: 37.h,
                                        width: 37.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: IconButton(
                                          onPressed: toggleAttachment,
                                          icon: Icon(
                                            isAttachmentOpen
                                                ? Icons.close_outlined
                                                : FontAwesomeIcons.paperclip,
                                            size: isAttachmentOpen
                                                ? 22.sp
                                                : 18.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    SizedBox(width: 6.w)
                                  ],
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    if (!onlyTemplatesEnabled)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xffF8F8F8)),
                        ),
                        child: IconButton(
                          onPressed: _messageController.text.isNotEmpty
                              ? () =>
                                  _sendMessage(text: _messageController.text)
                              : (isRecording
                                  ? _stopRecording
                                  : _startRecording),
                          icon: Icon(
                            _messageController.text.isNotEmpty
                                ? FontAwesomeIcons.solidPaperPlane
                                : (isRecording
                                    ? FontAwesomeIcons.stop
                                    : FontAwesomeIcons.microphone),
                          ),
                          color: const Color(0xff3874F6),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ]);
    });
  }

  void _clearChatAndPop(BuildContext context) {
    final controller =
        Provider.of<WhatsappControllerCopy>(context, listen: false);
    controller.clearChatList();
    Navigator.pop(context);
  }
}

Future<String?> getUserName() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? storedData = sharedPreferences.getString(AppConfig.loginData);

  if (storedData != null) {
    var loginData = jsonDecode(storedData);
    if (loginData["user"] != null && loginData["user"]['name'] != null) {
      return loginData["user"]['name'];
    }
  }
  return null;
}
