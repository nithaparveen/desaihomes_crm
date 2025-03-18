import 'dart:developer';
import 'dart:io';

import 'package:desaihomes_crm_application/presentations/new_whatsapp_screen/controller/new_whatsapp_controller.dart';
import 'package:desaihomes_crm_application/presentations/new_whatsapp_screen/view/widgets/new_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../../repository/api/whatsapp_screen/model/chat_model.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({
    super.key,
    required this.file,
    required this.contactedNumber,
    required this.leadId,
    required this.messageType,
  });

  final File file;
  final String contactedNumber;
  final String leadId;
  final String messageType;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final textController = TextEditingController();
  late String messageType;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    messageType = widget.messageType;
    
    // Always set initialized to true for quicker UI rendering
    // We'll show different content based on media type and status
    setState(() {
      _isInitialized = true;
    });
    
    // Try to initialize video if needed
    if (messageType == "video") {
      _tryInitializeVideo();
    }
  }

Future<void> _tryInitializeVideo() async {
  try {
    if (!widget.file.existsSync()) {
      setState(() {
        _hasError = true;
        _errorMessage = "File does not exist: ${widget.file.path}";
      });
      log(_errorMessage);
      return;
    }

    log("Attempting to initialize video from path: ${widget.file.path}");

    _videoController = VideoPlayerController.file(widget.file);
    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: true,
      showControls: true,
      allowFullScreen: false,
      aspectRatio: _videoController!.value.aspectRatio,
    );

    // Listen for the end of the video and stop playback without rebuilding UI
    _videoController!.addListener(() {
      if (_videoController!.value.position >= _videoController!.value.duration) {
        // Ensure it does not reset to a loading state
        _chewieController?.pause();
      }
    });

    if (mounted) {
      setState(() {});
    }
  } catch (e) {
    log("Video player initialization error: $e");
    setState(() {
      _hasError = true;
      _errorMessage = "Failed to initialize video player: ${e.toString()}";
    });
  }
}

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  // Handle sending the media
  Future<void> _handleSendMedia() async {
    final provider =
        Provider.of<WhatsappControllerCopy>(context, listen: false);

    // Get user name for the message
    String? senderName = await getUserName();

    // Create new message model
    final newMessage = ChatModel(
      message: widget.file.path,
      createdAt: DateTime.now(),
      messageType: "send",
      name: senderName,
      msgType: messageType.capitalize(),
    );

    // Add the message to the chat list
    await provider.addMessageToList(newMessage);

    // Send the message
    provider.onSendMessage(
      context,
      widget.file,
      messageType.capitalize(),
      widget.contactedNumber,
      widget.leadId,
    );

    // Close the preview screen
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Content area
                Center(
                  child: _buildMediaContent(),
                ),

                // Send button
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: _handleSendMedia,
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
              ],
            ),
    );
  }

  Widget _buildMediaContent() {
    // For images, show the image
    if (messageType == "image") {
      if (!widget.file.existsSync()) {
        return _buildErrorWidget("Image file not found");
      }
      
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(widget.file),
            fit: BoxFit.contain,
          ),
        ),
      );
    }
    
    // For videos with error, show error message
    if (_hasError) {
      return _buildErrorWidget(_errorMessage);
    }
      if (messageType == "document") {
    if (!widget.file.existsSync()) {
      return _buildErrorWidget("Document file not found");
    }
    
    return _buildDocumentPreview();
  }
  
  // For videos with error, show error message
  if (_hasError) {
    return _buildErrorWidget(_errorMessage);
  }
    // For videos that are loading or with initialization issues
    if (messageType == "video") {
      // If chewie controller is ready, show the video
      if (_chewieController != null) {
        return AspectRatio(
          aspectRatio: _chewieController!.aspectRatio ?? 16/9,
          child: Chewie(controller: _chewieController!),
        );
      }
      
      // Otherwise show a video placeholder
      return _buildVideoPlaceholder();
    }
    
    // Fallback
    return Center(
      child: Text("Unknown media type: $messageType"),
    );
  }
  
  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(
            "Media preview unavailable",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "You can still send this media",
            style: TextStyle(
              fontSize: 14.sp,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVideoPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_file_outlined,
            size: 80,
            color: Color(0xff3874F6),
          ),
          SizedBox(height: 16),
          Text(
            "Video Selected",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Preview not available",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          Text(
            widget.file.path.split('/').last,
            style: TextStyle(
              fontSize: 14.sp,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentPreview() {
  // Get file name and extension
  String fileName = widget.file.path.split('/').last;
  String extension = fileName.split('.').last.toLowerCase();
  
  // Get file size
  String fileSize = 'Calculating...';
  try {
    int sizeInBytes = widget.file.lengthSync();
    if (sizeInBytes < 1024) {
      fileSize = '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      fileSize = '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else if (sizeInBytes < 1024 * 1024 * 1024) {
      fileSize = '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      fileSize = '${(sizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  } catch (e) {
    fileSize = 'Unknown size';
    log('Error getting file size: $e');
  }
  
  // Select appropriate icon based on extension
  IconData fileIcon;
  Color iconColor;
  
  switch (extension) {
    case 'pdf':
      fileIcon = Icons.picture_as_pdf;
      iconColor = Colors.red;
      break;
    case 'doc':
    case 'docx':
      fileIcon = Icons.description;
      iconColor = Colors.blue;
      break;
    case 'xls':
    case 'xlsx':
      fileIcon = Icons.table_chart;
      iconColor = Colors.green;
      break;
    case 'ppt':
    case 'pptx':
      fileIcon = Icons.slideshow;
      iconColor = Colors.orange;
      break;
    case 'txt':
      fileIcon = Icons.text_snippet;
      iconColor = Colors.grey;
      break;
    default:
      fileIcon = Icons.insert_drive_file;
      iconColor = Colors.grey;
  }
  
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          fileIcon,
          size: 80,
          color: iconColor,
        ),
        SizedBox(height: 24),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                fileName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                fileSize,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        // SizedBox(height: 24),
        // Text(
        //   "Document preview not available",
        //   style: TextStyle(
        //     fontSize: 14.sp,
        //     fontStyle: FontStyle.italic,
        //     color: Colors.grey[600],
        //   ),
        // ),
      ],
    ),
  );
}
}

// Extension to capitalize the first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}