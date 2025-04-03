import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:desaihomes_crm_application/presentations/new_whatsapp_screen/controller/new_whatsapp_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
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
    // _requestPermissions();
    _loadUserId();
    _pusherService.subscribeToChannelWithId(
        widget.leadId.toString(), _handleNewMessage, context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      Provider.of<WhatsappControllerCopy>(context, listen: false)
          .fetchChats(widget.leadId, context);
    });
  }

  Future<void> _requestPermissions() async {
    await FlutterContacts.requestPermission();
    await Geolocator.requestPermission();
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
    String? parameterFormat,
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

    // Convert UTC DateTime to local DateTime
    DateTime localTime = timestamp.toLocal();

    // Format with am/pm
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

  Future<void> _pickLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Location services are disabled. Please enable them."),
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Location permissions are permanently denied. Enable them in settings."),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      Map<String, dynamic> locationData = _convertPositionToMap(position);

      setState(() {
        // _sendMessage(location: locationData);
        isAttachmentOpen = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error getting location: $e")),
      );
    }
  }

  Map<String, dynamic> _convertPositionToMap(Position position) {
    return {
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
      "name": "Current Location",
      "address": "Fetching address..."
    };
  }

  Future<void> _pickContact() async {
    if (await FlutterContacts.requestPermission()) {
      final Contact? contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        // _sendMessage(contact: _convertContactToMap(contact));
        setState(() {});
        isAttachmentOpen = false;
      } else {}
    } else {
      log('Permission denied.');
    }
  }

  Map<String, dynamic> _convertContactToMap(Contact contact) {
    return {
      "name": contact.displayName,
      "firstName": contact.name.first,
      "lastName": contact.name.last,
      "phone": contact.phones.isNotEmpty ? contact.phones.first.number : ""
    };
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

    /// **Extract Header Type & Headers from Template Components**
    for (var component in template.components ?? []) {
      if (component.type == "HEADER") {
        headerType = component.format.toLowerCase();

        // Debugging print
        log("Example Object: ${component.example.toJson()}");

        // Extract header_handle
        headers = List<String>.from(
            component.example?.toJson()["header_handle"] ?? []);

        break; // Stop loop after finding the first header
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: const Column(
            children: [Icon(Iconsax.warning_2, color: Color(0xffFF9C8E))],
          ),
          content: Column(
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

              /// **Header Preview Section**
              if (headerType == "image" && headers.isNotEmpty) ...[
                Text(
                  'Image Preview:',
                  style: GLTextStyles.manropeStyle(
                    color: ColorTheme.blue,
                    size: 14.sp,
                    weight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    headers.first,
                  ),
                ),
                SizedBox(height: 16.h),
              ] else if (headerType == "document" && headers.isNotEmpty) ...[
                Text(
                  'Document Preview:',
                  style: GLTextStyles.manropeStyle(
                    color: ColorTheme.blue,
                    size: 14.sp,
                    weight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.insert_drive_file, color: Colors.blue, size: 40),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        headers.first.split('/').last, // Show document filename
                        overflow: TextOverflow.ellipsis,
                        style: GLTextStyles.manropeStyle(
                          color: Colors.black87,
                          size: 13.sp,
                          weight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],

              /// **Text Preview**
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
                    templateData: template);
              },
            ),
          ],
        );
      },
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
