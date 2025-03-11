import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    bool isLocalFile = imageUrl.startsWith('/'); 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Iconsax.arrow_left, size: 20.sp),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: isLocalFile
            ? Image.file(File(imageUrl), fit: BoxFit.contain)
            : Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.broken_image, size: 100));
              }),
      ),
    );
  }
}