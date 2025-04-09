import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_compress/video_compress.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/textstyles.dart';
import 'image_preview_screen.dart';
import 'pdf_viewer_screen.dart';
import 'video_preview_screen.dart';

class MessageWidget extends StatelessWidget {
  final dynamic message;
  final bool isMe;
  final String formattedTime;
  final String senderName;
  final String mediaUrl;

  const MessageWidget({
    super.key,
    required this.message,
    required this.isMe,
    required this.formattedTime,
    required this.senderName, 
    required this.mediaUrl,
  });

  @override
  Widget build(BuildContext context) {
    switch (message.msgType) {
      case 'Text':
        return TextMessageWidget(
          message: message.message ?? '',
          mediaUrl: message.mediaUrl ?? "",
          isMe: isMe,
          timestamp: formattedTime,
          senderName: senderName,
        );
      case 'Text/Attach':
        return TemplateMessageWidget(
          message: message.message ?? '',
          mediaUrl: message.mediaUrl ?? "",
          isMe: isMe,
          timestamp: formattedTime,
          senderName: senderName,
        );
      case 'Document':
        String fileUrl = message.message ?? '';
        String fileName = fileUrl.split('/').last;
        String fileSize = '';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerScreen(fileUrl: fileUrl),
              ),
            );
          },
          child: FileMessageWidget(
            fileName: fileName,
            fileSize: fileSize,
            isMe: isMe,
            timestamp: formattedTime,
            senderName: senderName,
            mediaUrl: message.mediaUrl ?? "",
          ),
        );
      case 'Image':
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ImagePreviewScreen(imageUrl: message.message),
              ),
            );
          },
          child: ImageMessageWidget(
            imageUrl: message.message ?? '',
            isMe: isMe,
            timestamp: formattedTime,
            senderName: senderName,
            mediaUrl: message.mediaUrl ?? "",
          ),
        );
      case 'Video':
        return GestureDetector(
          onTap: () {
            if (message.message != null && message.message.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoPreviewScreen(videoUrl: message.message),
                ),
              );
            }
          },
          child: VideoMessageWidget(
            videoUrl: message.message ?? '',
            isMe: isMe,
            timestamp: formattedTime,
            senderName: senderName,
            mediaUrl: message.mediaUrl ?? "",
          ),
        );
      case 'Audio':
        return VoiceMessageWidget(
            voicePath: message.message ?? '',
            isMe: isMe,
            timestamp: formattedTime,
            mediaUrl: message.mediaUrl ?? "",
            senderName: senderName);
      case 'location':
        return LocationMessageWidget(
            message: message?.message ?? '{}',
            isMe: isMe,
            timestamp: formattedTime,
            mediaUrl: message.mediaUrl ?? "",
            senderName: senderName);
      case 'contact':
        return ContactMessageWidget(
            isMe: isMe,
            timestamp: formattedTime,
            message: message?.message ?? '{}',
            mediaUrl: message.mediaUrl ?? "",
            senderName: senderName);
      default:
        return TextMessageWidget(
            message: message.message ?? '',
            isMe: isMe,
            timestamp: formattedTime,
            mediaUrl: message.mediaUrl ?? "",
            senderName: senderName);
    }
  }
}

class TemplateMessageWidget extends StatelessWidget {
  final String message;
  final String mediaUrl;
  final bool isMe;
  final String timestamp;
  final String senderName;
  final String? headerType;

  const TemplateMessageWidget({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp,
    required this.senderName,
    this.headerType, 
    required this.mediaUrl,
  });

  @override
  Widget build(BuildContext context) {
    return MessageBubble(
      isMe: isMe,
      timestamp: timestamp,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      senderName: senderName,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display media from mediaUrl if available
          if (mediaUrl.isNotEmpty) _buildMediaWidget(context),
          SizedBox(height: mediaUrl.isNotEmpty ? 8.h : 0),
          // Message text
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  message,
                  style: GLTextStyles.manropeStyle(
                    color: const Color(0xFF170E2B),
                    size: 14.sp,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                timestamp,
                style: GLTextStyles.manropeStyle(
                  color: const Color(0xFFA4A4A4),
                  size: 10.sp,
                  weight: FontWeight.w400,
                ),
              ),
              if (!isMe) ...[
                SizedBox(width: 4.w),
                Icon(
                  Icons.done_all,
                  size: 16.sp,
                  color: const Color(0xFF30C0E0),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaWidget(BuildContext context) {
    final lowerUrl = mediaUrl.toLowerCase();
    final fileName = mediaUrl.split('/').last;
    
    if (lowerUrl.endsWith('.jpg') || lowerUrl.endsWith('.jpeg') || lowerUrl.endsWith('.png')) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImagePreviewScreen(imageUrl: mediaUrl),
            ),
          );
        },
        child: Container(
          constraints: BoxConstraints(maxWidth: 0.65.sw),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  mediaUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180.h,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180.h,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, size: 50.sp),
                  ),
                ),
              ),            
            ],
          ),
        ),
      );
    } else if (lowerUrl.endsWith('.mp4') || lowerUrl.endsWith('.mov') || lowerUrl.endsWith('.avi')) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPreviewScreen(videoUrl: mediaUrl),
            ),
          );
        },
        child: Container(
          constraints: BoxConstraints(maxWidth: 0.65.sw),
          child: Stack(
            children: [
              Container(
                height: 180.h,
                width: double.infinity,
                color: Colors.black12,
                child: Icon(Icons.movie, size: 50.sp, color: Colors.grey),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                  ),
                ),
              ),
            
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          if (lowerUrl.endsWith('.pdf')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerScreen(fileUrl: mediaUrl),
              ),
            );
          } else {
            // Handle other file types or show download dialog
          }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 230.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(7.w),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff3874F6),
                ),
                child: Icon(
                  _getFileIcon(fileName),
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xff170E2B),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                   
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }


}
  IconData _getFileIcon(String fileName) {
    if (fileName.toLowerCase().endsWith('.pdf')) {
      return Iconsax.document_text5;
    } else if (fileName.toLowerCase().endsWith('.doc') || fileName.toLowerCase().endsWith('.docx')) {
      return Iconsax.document_text5;
    } else if (fileName.toLowerCase().endsWith('.xls') || fileName.toLowerCase().endsWith('.xlsx')) {
      return Iconsax.document_text5;
    } else if (fileName.toLowerCase().endsWith('.ppt') || fileName.toLowerCase().endsWith('.pptx')) {
      return Iconsax.document_text5;
    } else {
      return Iconsax.document_text5;
    }
  }
class MessageBubble extends StatelessWidget {
  final Widget child;
  final bool isMe;
  final String timestamp;
  final EdgeInsetsGeometry? padding;
  final String senderName;

  const MessageBubble({
    super.key,
    required this.child,
    required this.isMe,
    required this.timestamp,
    this.padding,
    required this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isMe)
          Padding(
            padding: EdgeInsets.only(bottom: 2.h, left: 12.w, right: 8.w),
            child: Text(
              senderName,
              style: GLTextStyles.interStyle(
                color: const Color(0xff000000),
                size: 12.sp,
                weight: FontWeight.w500,
              ),
            ),
          ),
        if (!isMe)
          SizedBox(
            height: 3.h,
          ),
        Container(
          margin: EdgeInsets.only(bottom: 8.h),
          constraints: BoxConstraints(maxWidth: 0.8.sw),
          decoration: BoxDecoration(
            color: !isMe
                ? const Color.fromARGB(255, 245, 248, 255)
                : const Color(0xffF1F1F1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
              bottomLeft: !isMe ? Radius.circular(18.r) : Radius.circular(4.r),
              bottomRight: !isMe ? Radius.circular(4.r) : Radius.circular(18.r),
            ),
          ),
          padding: padding,
          child: child,
        ),
      ],
    );
  }
}

class TextMessageWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final String timestamp;
  final String senderName;
  final String mediaUrl;

  const TextMessageWidget({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp,
    required this.senderName, 
    required this.mediaUrl,
  });

  @override
  Widget build(BuildContext context) {
    return MessageBubble(
      isMe: isMe,
      timestamp: timestamp,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      senderName: senderName,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: message,
              style: GLTextStyles.manropeStyle(
                color: const Color(0xFF170E2B),
                size: 14.sp,
                weight: FontWeight.w400,
              ),
            ),
            maxLines: 2,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);

          final isMultiLine = textPainter.didExceedMaxLines;

          if (isMultiLine) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: GLTextStyles.manropeStyle(
                    color: const Color(0xFF170E2B),
                    size: 14.sp,
                    weight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timestamp,
                      style: GLTextStyles.manropeStyle(
                        color: const Color(0xFFA4A4A4),
                        size: 10.sp,
                        weight: FontWeight.w400,
                      ),
                    ),
                    if (!isMe) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.done_all,
                        size: 16.sp,
                        color: const Color(0xFF30C0E0),
                      ),
                    ],
                  ],
                ),
              ],
            );
          } else {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    message,
                    style: GLTextStyles.manropeStyle(
                      color: const Color(0xFF170E2B),
                      size: 14.sp,
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  timestamp,
                  style: GLTextStyles.manropeStyle(
                    color: const Color(0xFFA4A4A4),
                    size: 10.sp,
                    weight: FontWeight.w400,
                  ),
                ),
                if (!isMe) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.done_all,
                    size: 16.sp,
                    color: const Color(0xFF30C0E0),
                  ),
                ],
              ],
            );
          }
        },
      ),
    );
  }
}

class FileMessageWidget extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final bool isMe;
  final String timestamp;
  final String senderName;
  final String mediaUrl;

  const FileMessageWidget({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.isMe,
    required this.timestamp,
    required this.senderName, required this.mediaUrl,
  });

  @override
  Widget build(BuildContext context) {
    return MessageBubble(
      isMe: isMe,
      timestamp: timestamp,
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
      senderName: senderName,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 230.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(7.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff3874F6),
              ),
              child: Icon(Iconsax.document_text5,
                  color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 9.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xff170E2B),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fileSize,
                        style: TextStyle(
                          color: const Color(0xff5D5D60),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [     
                          Text(
                            timestamp,
                            style: GLTextStyles.manropeStyle(
                              color: const Color(0xFFA4A4A4),
                              size: 10.sp,
                              weight: FontWeight.w400,
                            ),
                          ),
                          if (!isMe) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.done_all,
                              size: 16.sp,
                              color: const Color(0xFF30C0E0),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoiceMessageWidget extends StatelessWidget {
  final String voicePath;
  final bool isMe;
  final String timestamp;
  final String senderName;
  final String mediaUrl;

  const VoiceMessageWidget({
    super.key,
    required this.voicePath,
    required this.isMe,
    required this.timestamp,
    required this.senderName, required this.mediaUrl,
  });

  @override
  Widget build(BuildContext context) {
    return MessageBubble(
      isMe: isMe,
      timestamp: timestamp,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      senderName: senderName,
      child: Stack(children: [
        VoiceMessageView(
          controller: VoiceController(
            audioSrc: voicePath,
            maxDuration: const Duration(seconds: 100),
            isFile: false,
            onComplete: () {},
            onPause: () {},
            onPlaying: () {},
            onError: (err) {},
          ),
          pauseIcon: const Icon(Icons.pause_rounded, color: Colors.white),
          playIcon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
          circlesColor: const Color(0xff3874F6),
          playPauseButtonLoadingColor: const Color(0xff3874F6),
          activeSliderColor: const Color(0xff3874F6),
          backgroundColor: !isMe
              ? const Color.fromARGB(255, 245, 248, 255)
              : const Color(0xffF1F1F1),
          innerPadding: 0,
        ),
        Positioned(
          bottom: 0,
          right: 2,
          child: Row(
            children: [
              Text(
                timestamp,
                style: const TextStyle(
                  color: Color(0xFFA4A4A4),
                  fontSize: 10,
                ),
              ),
              if (!isMe) ...[
                const SizedBox(width: 4),
                const Icon(Icons.done_all, size: 20, color: Color(0xFF30C0E0)),
              ],
            ],
          ),
        ),
      ]),
    );
  }
}

class ContactMessageWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final String timestamp;
  final String senderName;
  final String mediaUrl;

  const ContactMessageWidget({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp,
    required this.senderName, required this.mediaUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Decode the message string into a Map
    Map<String, dynamic> contactData = {};
    try {
      contactData = jsonDecode(message);
    } catch (e) {
      debugPrint("Error decoding contact JSON: $e");
    }

    final String name = contactData["name"] ?? "Unknown";
    final String phone = contactData["phone"] ?? "No phone available";

    return MessageBubble(
      isMe: isMe,
      timestamp: timestamp,
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
      senderName: senderName,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.w),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff3874F6),
                ),
                child: Icon(Icons.person_rounded,
                    color: Colors.white, size: 22.sp),
              ),
              SizedBox(width: 9.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GLTextStyles.manropeStyle(
                      color: const Color(0xFF170E2B),
                      size: 14.sp,
                      weight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    phone,
                    style: GLTextStyles.manropeStyle(
                      color: const Color(0xFF170E2B),
                      size: 12.sp,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 28.w),
          Text(
            timestamp,
            style: GLTextStyles.manropeStyle(
              color: const Color(0xFFA4A4A4),
              size: 10.sp,
              weight: FontWeight.w400,
            ),
          ),
          if (!isMe) ...[
            SizedBox(width: 4.w),
            Icon(
              Icons.done_all,
              size: 16.sp,
              color: const Color(0xFF30C0E0),
            ),
          ],
        ],
      ),
    );
  }
}

class LocationMessageWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final String timestamp;
  final String senderName;
  final String mediaUrl;

  const LocationMessageWidget({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp,
    required this.senderName, required this.mediaUrl,
  });

  Future<void> _openMap(
      double latitude, double longitude, BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> locationData = {};
    try {
      locationData = jsonDecode(message);
    } catch (e) {
      print("Error decoding location JSON: $e");
    }

    final double latitude =
        double.tryParse(locationData['latitude']?.toString() ?? '') ?? 0.0;
    final double longitude =
        double.tryParse(locationData['longitude']?.toString() ?? '') ?? 0.0;

    return MessageBubble(
      isMe: isMe,
      timestamp: timestamp,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      senderName: senderName,
      child: GestureDetector(
        onTap: () => _openMap(latitude, longitude, context),
        child: Container(
          height: 120.h,
          width: 238.w,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/button (1).png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(FontAwesomeIcons.locationDot,
                      size: 16.sp, color: const Color(0xffF83737)),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Location shared",
                                style: GLTextStyles.manropeStyle(
                                  color: const Color(0xFF170E2B),
                                  size: 13.sp,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 28.h),
                              Text(
                                '$latitude',
                                style: GLTextStyles.manropeStyle(
                                  color: const Color(0xFF170E2B),
                                  size: 14.sp,
                                  weight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '$longitude',
                                style: GLTextStyles.manropeStyle(
                                  color: const Color(0xFF170E2B),
                                  size: 14.sp,
                                  weight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          timestamp,
                          style: GLTextStyles.manropeStyle(
                            color: const Color(0xFFA4A4A4),
                            size: 10.sp,
                            weight: FontWeight.w400,
                          ),
                        ),
                        if (!isMe) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.done_all,
                            size: 16.sp,
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
      ),
    );
  }
}

class ImageMessageWidget extends StatelessWidget {
  final String imageUrl;
  final bool isMe;
  final String timestamp;
  final String senderName;
  final String mediaUrl;

  const ImageMessageWidget({
    super.key,
    required this.imageUrl,
    required this.isMe,
    required this.timestamp,
    required this.senderName, required this.mediaUrl,
  });

  Widget _loadImage() {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 180.h,
        errorBuilder: (context, error, stackTrace) =>
            const SizedBox(height: 100, width: 120, child: Icon(Icons.error)),
      );
    } else {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 180.h,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageBubble(
      isMe: isMe,
      timestamp: timestamp,
      senderName: senderName,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.65.sw),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _loadImage(),
            ),
            Positioned(
              bottom: 8.h,
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
                      timestamp,
                      style: GLTextStyles.manropeStyle(
                        color: Colors.white,
                        size: 10.sp,
                        weight: FontWeight.w500,
                      ),
                    ),
                    if (!isMe) ...[
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
}

class VideoMessageWidget extends StatefulWidget {
  final String videoUrl;
  final bool isMe;
  final String timestamp;
  final String senderName;
  final String mediaUrl;

  const VideoMessageWidget({
    super.key,
    required this.videoUrl,
    required this.isMe,
    required this.timestamp,
    required this.senderName, required this.mediaUrl,
  });

  @override
  _VideoMessageWidgetState createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget> {
  String? _thumbnailPath;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final thumbnailFile = await VideoCompress.getFileThumbnail(
        widget.videoUrl,
        quality: 50, // Adjust quality (0-100)
        position: -1, // Auto-select frame
      );

      if (mounted) {
        setState(() {
          _thumbnailPath = thumbnailFile.path;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _thumbnailPath = null;
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  Widget _loadVideoThumbnail() {
    if (_isLoading) {
      // return const Center(child: CircularProgressIndicator());
    }
    if (_hasError || _thumbnailPath == null) {
      return _defaultThumbnail();
    }

    return Image.file(File(_thumbnailPath!),
        fit: BoxFit.cover, width: double.infinity, height: 180.h);
  }

  Widget _defaultThumbnail() {
    return Container(
      height: 180.h,
      width: double.infinity,
      color: Colors.black12,
      child: Icon(Icons.movie, size: 50.sp, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MessageBubble(
      isMe: widget.isMe,
      timestamp: widget.timestamp,
      senderName: widget.senderName,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.65.sw),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _loadVideoThumbnail(),
            ),

            // Play button overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ),
            ),

            // Timestamp
            Positioned(
              bottom: 8.h,
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
                      widget.timestamp,
                      style: GLTextStyles.manropeStyle(
                        color: Colors.white,
                        size: 10.sp,
                        weight: FontWeight.w500,
                      ),
                    ),
                    if (!widget.isMe) ...[
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
}
