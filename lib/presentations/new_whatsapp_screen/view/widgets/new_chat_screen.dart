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
import '../../../../core/constants/textstyles.dart';
import 'message_widget.dart';
import 'template_widget.dart';

class ChatScreenCopy extends StatefulWidget {
  const ChatScreenCopy({super.key, required this.name, required this.leadId, required this.contactedNumber});
  final String name;
  final String contactedNumber;
  final int leadId;

  @override
  State<ChatScreenCopy> createState() => _ChatScreenCopyState();
}

class _ChatScreenCopyState extends State<ChatScreenCopy> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
    _requestPermissions();
    _loadUserId();

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
    super.dispose();
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

  void _sendMessage(
      {String? text,
      File? file,
      Map<String, dynamic>? contact,
      Map<String, dynamic>? location}) {
    if (text != null && text.trim().isNotEmpty) {
      Provider.of<WhatsappControllerCopy>(context, listen: false).sendMessage(
          widget.contactedNumber, text, widget.leadId.toString(), context);
      _messageController.clear();
      setState(() => isTyping = false);
    }
    // if (file != null) {
    //   Provider.of<WhatsappController>(context, listen: false).onSendMessage(
    //       widget.contactedNumber, file, widget.contactedUserId, context);
    // }
    // if (contact != null) {
    //   Provider.of<WhatsappControllerCopy>(context, listen: false).sendContact(
    //       widget.contactedNumber, contact, widget.contactedUserId, context);
    // }
    // if (location != null) {
    //   Provider.of<WhatsappControllerCopy>(context, listen: false).sendLocation(
    //       widget.contactedNumber, location, widget.contactedUserId, context);
    // }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _getCurrentTimestamp() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}${now.hour >= 12 ? 'pm' : 'am'}";
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
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
        if (controller.isChatLoading) {
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: const Color(0xffF0F6FF),
                size: 32,
              ),
            ),
          );
        }

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
                    final isMe = message.messageType == "received";
                    return MessageWidget(
                      message: message,
                      isMe: isMe,
                      formattedTime: _formatTimestamp(message.createdAt),
                      senderName: message.name ?? "",
                    );
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
        SnackBar(content: Text("Error starting recording: $e")),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (path != null) {
        final file = File(path);
        final duration = await _getAudioDuration(file);

        // _sendMessage(file: File(path));

        setState(() {
          isRecording = false;
          recordedFilePath = path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error stopping recording: $e")),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<Duration> _getAudioDuration(File file) async {
    final AudioPlayer player = AudioPlayer();
    await player.setFilePath(file.path);
    final duration = player.duration;
    await player.dispose();
    return duration ?? Duration.zero;
  }

  Future<void> _handleImageMessage({bool fromCamera = false}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image != null) {
      File selectedImage = File(image.path);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PreviewScreen(
      //       file: selectedImage,
      //       contactedNumber: widget.contactedNumber,
      //       contactedUserId: widget.contactedUserId,
      //     ),
      //   ),
      // );
    } else {}
  }

  Future<void> _handleDocumentMessage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      File selectedFile = File(result.files.single.path!);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PreviewScreen(
      //       file: selectedFile,
      //       contactedNumber: widget.contactedNumber,
      //       contactedUserId: widget.contactedUserId,
      //     ),
      //   ),
      // );
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
          _buildAttachmentIcon(
              Iconsax.location5, "Location", const Color(0xff64C685), () async {
            await _pickLocation();
          }),
          _buildAttachmentIcon(
              Icons.person, "Contact", const Color(0xffF69738), _pickContact),
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

  Widget _buildMessageInput() {
    return Stack(children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isAttachmentOpen
                ? _buildAttachmentOptions()
                : const SizedBox.shrink(),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            child: isTemplateOpen
                ? TemplateSelectionModal(
                    onTemplateSelected: (template) {
                      setState(() {
                        _messageController.text = template.content;
                        isTemplateOpen = false;
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
                      decoration: InputDecoration(
                        hintText: 'Send a message',
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
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isTyping)
                              IconButton(
                                onPressed: () {
                                  _showTemplateModal(context);
                                },
                                icon: Icon(
                                  isTemplateOpen
                                      ? Icons.close_outlined
                                      : Iconsax.smallcaps,
                                  size: 21.sp,
                                  color: Colors.black,
                                ),
                              ),
                            if (!isTyping)
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
                                    size: isAttachmentOpen ? 22.sp : 18.sp,
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
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xffF8F8F8))),
                    child: IconButton(
                      onPressed: isTyping
                          ? () =>

                          _sendMessage(text: _messageController.text)
                          : (isRecording ? _stopRecording : _startRecording),
                      icon: Icon(isTyping
                          ? FontAwesomeIcons.solidPaperPlane
                          : (isRecording
                              ? FontAwesomeIcons.stop
                              : FontAwesomeIcons.microphone)),
                      color: Color(0xff3874F6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
