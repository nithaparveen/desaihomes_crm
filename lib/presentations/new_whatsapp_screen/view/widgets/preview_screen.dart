import 'dart:io';

import 'package:desaihomes_crm_application/presentations/new_whatsapp_screen/controller/new_whatsapp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({
    super.key,
    required this.file,
    required this.contactedNumber,
    required this.contactedUserId,
  });

  final File file;
  final String contactedNumber;
  final String contactedUserId;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final textController = TextEditingController();
  String messageType = "image"; 

  @override
  void initState() {
    super.initState();
    _determineMessageType();
  }

  void _determineMessageType() {
    final String extension = widget.file.path.split('.').last.toLowerCase();
    String detectedType = "file"; 

    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      detectedType = "image";
    } else if (['mp4', 'mov', '3gp', 'avi'].contains(extension)) {
      detectedType = "video";
    } else if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt']
        .contains(extension)) {
      detectedType = "document";
    } else if (['mp3', 'wav', 'aac', 'm4a', 'ogg'].contains(extension)) {
      detectedType = "audio";
    }

    if (detectedType != messageType) {
      setState(() {
        messageType = detectedType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (mounted) {
              Navigator.pop(context);
            }
          },
          icon: Icon(Iconsax.arrow_left, size: 20.sp),
        
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: widget.file.existsSync()
              ? DecorationImage(
                  image: FileImage(widget.file),
                  fit: BoxFit.contain,
                )
              : null,
          color: Colors.white,
        ),
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: GestureDetector(
            onTap: () {
              final provider =
                  Provider.of<WhatsappControllerCopy>(context, listen: false);

              provider.onSendMessage(
                context,
                widget.file,
                messageType,
                widget.contactedNumber,
                widget.contactedUserId,
              );

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff3874F6),
              ),
              child: Icon(FontAwesomeIcons.solidPaperPlane,
                  color: Colors.white, size: 20.sp),
            ),
          ),
        ),
      ),
    );
  }
}
