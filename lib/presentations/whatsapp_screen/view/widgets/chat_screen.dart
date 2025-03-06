import 'dart:io';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:voice_message_package/voice_message_package.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.name});
  final String name;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isRecording = false;
  bool isTyping = false;
  bool isAttachmentOpen = false;
  final _audioRecorder = AudioRecorder();
  String? _currentRecordingPath;
  String? recordedFilePath;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
    _requestPermissions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
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

  void _addMessage(ChatMessage message) {
    setState(() {
      messages.add(message);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final newMessage = ChatMessage(
        sender: "Sarah",
        message: _messageController.text,
        timestamp: _getCurrentTimestamp(),
        isMe: true,
      );
      _addMessage(newMessage);
      _messageController.clear();
    }
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

  final List<ChatMessage> messages = [
    ChatMessage(
      sender: "Sarah",
      message:
          "Hi John, I'm Sarah from Desai Homes. Are you still looking for a property in Kochi?",
      timestamp: "5:43pm",
      isMe: true,
    ),
    ChatMessage(
      sender: "John",
      message: "Yes, can you please share more details",
      timestamp: "5:43pm",
      isMe: false,
    ),
    // ChatMessage(
    //   sender: "Sarah",
    //   message: "",
    //   timestamp: "5:43pm",
    //   isMe: true,
    //   isVoiceMessage: true,
    //   voiceDuration: "0:37",
    //   senderImage:
    //       "https://images.unsplash.com/photo-1633332755192-727a05c4013d",
    // ),
    ChatMessage(
      sender: "Sarah",
      message: "",
      timestamp: "5:43pm",
      isMe: true,
      isFile: true,
      fileName: "DD Kochi project.pdf",
      fileSize: "4.5 MB",
    ),
    ChatMessage(
      sender: "John",
      message: "Please share some Images",
      timestamp: "5:45pm",
      isMe: false,
    ),
    ChatMessage(
      sender: "Sarah",
      message: "",
      timestamp: "5:46pm",
      isMe: true,
      isPhotoMessage: true,
      photos: [
        "https://images.unsplash.com/photo-1625517131943-0f7a51d6dcc8?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzZ8fGJ1aWxkaW5nJTIwaWxsdXN0cmF0aW9uc3xlbnwwfHwwfHx8MA%3D%3D",
        "https://images.unsplash.com/photo-1638008696161-17ad1f0c2e19?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://plus.unsplash.com/premium_photo-1731554324614-f355d0520e7e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8YnVpbGRpbmclMjBpbGx1c3RyYXRpb25zfGVufDB8fDB8fHww",
        "https://images.unsplash.com/photo-1717250266633-73147f32f90f?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGJ1aWxkaW5nJTIwaWxsdXN0cmF0aW9uc3xlbnwwfHwwfHx8MA%3D%3D",
      ],
    ),
    ChatMessage(
      sender: "John",
      message: "Is swimming available?",
      timestamp: "5:48pm",
      isMe: false,
    ),
    ChatMessage(
      sender: "Sarah",
      message: "Yes , Available..",
      timestamp: "5:49pm",
      isMe: true,
    ),
    ChatMessage(
      sender: "Sarah",
      message: "",
      timestamp: "5:49pm",
      isMe: true,
      isPhotoMessage: true,
      photos: [
        "https://media.istockphoto.com/id/1446558097/photo/a-rectangular-new-swimming-pool-with-tan-concrete-edges-in-the-fenced-backyard-of-a-new.webp?a=1&b=1&s=612x612&w=0&k=20&c=lUDzgxPfi5PqxSHJP4gbBPtbwPWBGsVTnTPBdcxiS9U="
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Iconsax.arrow_left, size: 20.sp),
        ),
        title: Row(
          children: [
            ClipOval(
              child: Image.network(
                "https://images.unsplash.com/photo-1633332755192-727a05c4013d",
                width: 34.r,
                height: 34.r,
                fit: BoxFit.cover,
              ),
            ),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageItem(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    if (message.isLocationMessage) {
      return Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          constraints: BoxConstraints(maxWidth: 0.65.sw),
          child: Stack(
            children: [
              _buildLocationMessage(message),
              Positioned(
                bottom: 0.h,
                right: 12.w,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.timestamp,
                      style: GLTextStyles.manropeStyle(
                        color: const Color(0xFFA4A4A4),
                        size: 10.sp,
                        weight: FontWeight.w400,
                      ),
                    ),
                    if (message.isMe) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.done_all,
                        size: 20.sp,
                        color: const Color(0xFF30C0E0),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (message.isPhotoMessage) {
      return Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          constraints: BoxConstraints(maxWidth: 0.65.sw),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: message.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  _buildPhotoMessage(message),
                ],
              ),
              Positioned(
                bottom: 13.h,
                right: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.timestamp,
                        style: GLTextStyles.manropeStyle(
                          color: Colors.white,
                          size: 10.sp,
                          weight: FontWeight.w500,
                        ),
                      ),
                      if (message.isMe) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.done_all,
                          size: 18.sp,
                          color: const Color(0xFF30C0E0),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (message.isContactMessage) {
      return Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(4.w),
          margin: EdgeInsets.only(bottom: 8.h),
          constraints: BoxConstraints(maxWidth: 0.65.sw),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: message.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  _buildContactMessage(message),
                ],
              ),
              Positioned(
                bottom: 0.h,
                right: 12.w,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.timestamp,
                      style: GLTextStyles.manropeStyle(
                        color: const Color(0xFFA4A4A4),
                        size: 10.sp,
                        weight: FontWeight.w400,
                      ),
                    ),
                    if (message.isMe) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.done_all,
                        size: 20.sp,
                        color: const Color(0xFF30C0E0),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 13.h),
        constraints: BoxConstraints(maxWidth: 0.65.sw),
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.isVoiceMessage)
              Container(
                decoration: BoxDecoration(
                  color: message.isMe
                      ? const Color(0xFFF8F8FF)
                      : const Color(0xffF1F1F1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.r),
                    topRight: Radius.circular(18.r),
                    bottomLeft: message.isMe
                        ? Radius.circular(18.r)
                        : Radius.circular(4.r),
                    bottomRight: message.isMe
                        ? Radius.circular(4.r)
                        : Radius.circular(18.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: message.isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [_buildVoiceMessage(message)],
                      ),
                    ),
                  ],
                ),
              )
            else
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: message.isMe
                          ? const Color(0xFFF8F8FF)
                          : const Color(0xffF1F1F1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.r),
                        topRight: Radius.circular(18.r),
                        bottomLeft: message.isMe
                            ? Radius.circular(18.r)
                            : Radius.circular(4.r),
                        bottomRight: message.isMe
                            ? Radius.circular(4.r)
                            : Radius.circular(18.r),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: 12.w,
                      right: 12.w,
                      top: 14.h,
                      bottom: 14.h,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: message.isFile
                          ? _buildFileMessage(message)
                          : Text(
                              message.message,
                              style: GLTextStyles.manropeStyle(
                                color: const Color(0xff170E2B),
                                size: 14.sp,
                                weight: FontWeight.w400,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 9.h,
                    right: 12.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.timestamp,
                          style: GLTextStyles.manropeStyle(
                            color: const Color(0xFFA4A4A4),
                            size: 10.sp,
                            weight: FontWeight.w400,
                          ),
                        ),
                        if (message.isMe) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.done_all,
                            size: 20.sp,
                            color: const Color(0xFF30C0E0),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationMessage(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => _openMap(message.latitude!, message.longitude!),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.isMe
                ? const Color(0xFFF8F8FF)
                : const Color(0xffF1F1F1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: Color(0xff64C685)),
                  SizedBox(width: 8),
                  Text(
                    "Location shared",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // SizedBox(
              //   width: 200,
              //   height: 150,
              //   child: GoogleMap(
              //     initialCameraPosition: CameraPosition(
              //       target: LatLng(message.latitude!, message.longitude!),
              //       zoom: 15,
              //     ),
              //     markers: {
              //       Marker(
              //         markerId: const MarkerId('shared_location'),
              //         position: LatLng(message.latitude!, message.longitude!),
              //       ),
              //     },
              //     zoomControlsEnabled: false,
              //     mapToolbarEnabled: false,
              //     myLocationButtonEnabled: false,
              //   ),
              // ),
              Text(
                message.latitude.toString(),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                message.longitude.toString(),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openMap(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open map")),
      );
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path =
            '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          RecordConfig(encoder: AudioEncoder.aacLc),
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

        setState(() {
          isRecording = false;
          recordedFilePath = path;
        });

        final newMessage = ChatMessage(
          sender: "Sarah",
          message: "",
          timestamp: _getCurrentTimestamp(),
          isMe: true,
          isVoiceMessage: true,
          voicePath: path,
          voiceDuration: _formatDuration(duration),
        );

        _addMessage(newMessage);
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
    final duration = await player.duration;
    await player.dispose();
    return duration ?? Duration.zero;
  }

  Widget _buildVoiceMessage(ChatMessage message) {
    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VoiceMessageView(
              controller: VoiceController(
                audioSrc: message.voicePath!,
                maxDuration: const Duration(seconds: 10),
                isFile: true,
                onComplete: () {},
                onPause: () {},
                onPlaying: () {},
                onError: (err) {},
              ),
              pauseIcon: const Icon(Icons.pause_rounded, color: Colors.white),
              playIcon:
                  const Icon(Icons.play_arrow_rounded, color: Colors.white),
              circlesColor: const Color(0xff3874F6),
              playPauseButtonLoadingColor: const Color(0xff3874F6),
              activeSliderColor: const Color(0xff3874F6),
              backgroundColor: const Color(0xFFF8F8FF),
              innerPadding: 0,
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 2,
          child: Row(
            children: [
              Text(
                message.timestamp,
                style: const TextStyle(
                  color: Color(0xFFA4A4A4),
                  fontSize: 10,
                ),
              ),
              if (message.isMe) ...[
                const SizedBox(width: 4),
                const Icon(Icons.done_all, size: 20, color: Color(0xFF30C0E0)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactMessage(ChatMessage message) {
    if (message.contact == null) {
      return const SizedBox.shrink();
    }

    final contact = message.contact!;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: message.isMe ? const Color(0xFFF8F8FF) : const Color(0xffF1F1F1),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Shared',
            style: GLTextStyles.manropeStyle(
              color: const Color(0xff170E2B),
              size: 14.sp,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Name: ${contact.displayName}',
            style: GLTextStyles.manropeStyle(
              color: const Color(0xff170E2B),
              size: 14.sp,
              weight: FontWeight.w400,
            ),
          ),
          if (contact.phones.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: contact.phones.map((phone) {
                return Text(
                  'Phone: ${phone.number}',
                  style: GLTextStyles.manropeStyle(
                    color: const Color(0xff170E2B),
                    size: 14.sp,
                    weight: FontWeight.w400,
                  ),
                );
              }).toList(),
            ),
          if (contact.emails.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: contact.emails.map((email) {
                return Text(
                  'Email: ${email.address}',
                  style: GLTextStyles.manropeStyle(
                    color: const Color(0xff170E2B),
                    size: 14.sp,
                    weight: FontWeight.w400,
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(ChatMessage message) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(7.w),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff3874F6),
          ),
          child: Icon(Iconsax.document_text5, color: Colors.white, size: 20.sp),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.fileName ?? "",
                maxLines: 3, // Ensure single-line display
                overflow: TextOverflow.ellipsis,
                style: GLTextStyles.manropeStyle(
                  color: const Color(0xff170E2B),
                  size: 14.sp,
                  weight: FontWeight.w400,
                ),
              ),
              Text(
                message.fileSize ?? "",
                style: GLTextStyles.manropeStyle(
                  color: const Color(0xff5D5D60),
                  size: 13.sp,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleDocumentMessage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        // Documents
        'pdf', 'doc', 'docx', 'txt', 'rtf', 'ppt', 'pptx', 'xls', 'xlsx',
        // Images
        'jpg', 'jpeg', 'png', 'gif',
        // Audio
        'mp3', 'wav', 'm4a',
        // Video
        'mp4', 'mov', 'avi',
        // Archives
        'zip', 'rar',
      ],
      allowMultiple: false,
    );

    if (result != null) {
      final file = result.files.single;
      final newMessage = ChatMessage(
        sender: "Sarah",
        message: "",
        timestamp: _getCurrentTimestamp(),
        isMe: true,
        isFile: true,
        fileName: file.name,
        fileSize: _formatFileSize(file.size),
      );
      _addMessage(newMessage);
      toggleAttachment();
    }
  }

  Widget _buildPhotoMessage(ChatMessage message) {
    final int photoCount = message.photos!.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photoCount <= 3)
          Column(
            children: message.photos!.map((photo) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: _loadImage(photo),
                ),
              );
            }).toList(),
          )
        else
          SizedBox(
            height: 255.h,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4.h,
              crossAxisSpacing: 4.w,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: message.photos!.map((photo) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: _loadImage(photo),
                );
              }).toList(),
            ),
          ),
        if (message.message.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Text(
            message.message,
            style: GLTextStyles.manropeStyle(
              color: const Color(0xff170E2B),
              size: 14.sp,
              weight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _handleImageMessage({bool fromCamera = false}) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image != null) {
      print("Captured image path: ${image.path}");

      final newMessage = ChatMessage(
        sender: "Sarah",
        message: "",
        timestamp: _getCurrentTimestamp(),
        isMe: true,
        isPhotoMessage: true,
        photos: [image.path],
      );

      _addMessage(newMessage);
      setState(() {});
      toggleAttachment();
    } else {
      print("No image selected");
    }
  }

  Widget _loadImage(String photo) {
    if (photo.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: 180.h,
        child: const Center(child: Text("Image not available")),
      );
    }

    if (photo.startsWith("http") || photo.startsWith("https")) {
      return Image.network(
        photo,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 180.h,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    } else {
      File imageFile = File(photo);
      if (!imageFile.existsSync()) {
        print("Image file not found: $photo");
      }
      return Image.file(
        imageFile,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 180.h,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image),
      );
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
            Iconsax.location5,
            "Location",
            const Color(0xff64C685),
            () async {
              await _pickLocation();
            },
          ),
          _buildAttachmentIcon(
              Icons.person, "Contact", const Color(0xffF69738), _pickContact),
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

      setState(() {
        messages.add(ChatMessage(
          sender: "Sarah",
          isLocationMessage: true,
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: _getCurrentTimestamp(),
          isMe: true,
        ));
        isAttachmentOpen = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error getting location: $e")),
      );
    }
  }

  Future<void> _pickContact() async {
    if (await FlutterContacts.requestPermission()) {
      final Contact? contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        print('Selected Contact: ${contact.displayName}');
        print('Phone Numbers: ${contact.phones}');
        print('Emails: ${contact.emails}');

        final newMessage = ChatMessage(
          sender: "Sarah",
          message: "",
          timestamp: _getCurrentTimestamp(),
          isMe: true,
          isContactMessage: true,
          contact: contact,
        );

        _addMessage(newMessage);
        setState(() {});
        isAttachmentOpen = false;
      } else {
        print('No contact selected.');
      }
    } else {
      print('Permission denied.');
    }
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
                                  _handleImageMessage(fromCamera: true);
                                },
                                icon: Icon(
                                  Icons.photo_camera_outlined,
                                  size: 22.sp,
                                  color: Colors.black,
                                ),
                              ),
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
                  IconButton(
                    onPressed: () {
                      if (isTyping) {
                        _handleSendMessage();
                      } else {
                        if (isRecording) {
                          _stopRecording();
                        } else {
                          _startRecording();
                        }
                      }
                    },
                    icon: Icon(
                      isRecording
                          ? FontAwesomeIcons.solidPaperPlane
                          : isTyping
                              ? FontAwesomeIcons.solidPaperPlane
                              : FontAwesomeIcons.microphone,
                      size: isRecording ? 20.sp : 22.sp,
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
  }
}

class ChatMessage {
  final String sender;
  final String message;
  final String timestamp;
  final bool isMe;
  final bool isVoiceMessage;
  final String? voiceDuration;
  final bool isFile;
  final String? fileName;
  final String? fileSize;
  final bool isPhotoMessage;
  final List<String>? photos;
  final String? senderImage;
  final bool isLocationMessage;
  final double? latitude;
  final double? longitude;
  final bool isContactMessage;
  final Contact? contact;
  final String? voicePath;

  ChatMessage({
    required this.sender,
    this.message = '',
    required this.timestamp,
    required this.isMe,
    this.isVoiceMessage = false,
    this.voiceDuration,
    this.isFile = false,
    this.fileName,
    this.fileSize,
    this.isPhotoMessage = false,
    this.photos,
    this.senderImage,
    this.isLocationMessage = false,
    this.latitude,
    this.longitude,
    this.isContactMessage = false,
    this.contact,
    this.voicePath,
  });
}
