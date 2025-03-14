import 'dart:io';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPreviewScreen extends StatefulWidget {
  const VideoPreviewScreen({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _videoPlayerController = widget.videoUrl.startsWith('/')
        ? VideoPlayerController.file(File(widget.videoUrl))
        : VideoPlayerController.network(widget.videoUrl);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      placeholder: Center(
          child: CircularProgressIndicator(
        color: ColorTheme.desaiGreen,
      )),
      autoInitialize: true,
      allowFullScreen: true,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: AspectRatio(
          aspectRatio: _chewieController!.aspectRatio ?? 5 / 4,
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}
