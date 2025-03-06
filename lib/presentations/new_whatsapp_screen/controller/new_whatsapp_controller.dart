import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_config/app_config.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../repository/api/whatsapp_screen/service/whatsapp_service.dart';
import '../../../repository/api/whatsapp_screen/model/conversation_model.dart';
import '../../../repository/api/whatsapp_screen/model/chat_model.dart';

class WhatsappControllerCopy extends ChangeNotifier {
  List<ConversationModel> conversationModel = [];
  bool isLoading = false;
  ChatModel chatModel = ChatModel();
  List<ChatModel> chatList = <ChatModel>[];

  bool isChatLoading = false;

  fetchConversations(context) async {
    isLoading = true;
    notifyListeners();

    WhatsappService.fetchConversations().then((value) {
      if (value != null) {
        // Ensure the response is a list before parsing
        if (value is List) {
          conversationModel =
              value.map((item) => ConversationModel.fromJson(item)).toList();
        } else {
          conversationModel = [];
        }
        isLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  Future sendMessage(String to, String message, String leadId,
      BuildContext context) async {
    log("WhatsappController -> sendMessage() started");
    WhatsappService.sendMessage(to,message,leadId).then((value) {
      if (value["success"] == true) {
      } else {
        AppUtils.oneTimeSnackBar(value["message"],
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  Future sendContact(String to, Map<String, dynamic> contact, String receiverId,
      BuildContext context) async {
    var data = {"to": to, "receiver_id": receiverId, "contact": contact};

    WhatsappService.sendContact(data).then((value) {
      if (value["success"] == true) {
        // Success handling
      } else {
        AppUtils.oneTimeSnackBar(value["message"],
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  Future sendLocation(String to, Map<String, dynamic> location,
      String receiverId, BuildContext context) async {
    var data = {"to": to, "receiver_id": receiverId, "location": location};

    WhatsappService.sendLocation(data).then((value) {
      if (value["success"] == true) {
        // Success handling
      } else {
        AppUtils.oneTimeSnackBar(value["message"],
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  // Future sendMedias(String to, String message, String receiverId,
  //     BuildContext context) async {
  //   var data = {"to": to, "message": message, "receiver_id": receiverId};
  //   WhatsappService.sendMessage(data).then((value) {
  //     if (value["success"] == true) {
  //     } else {
  //       AppUtils.oneTimeSnackBar(value["message"],
  //           context: context, bgColor: Colors.redAccent);
  //     }
  //   });
  // }

  fetchChats(leadId, context) async {
    isChatLoading = true;
    notifyListeners();
    WhatsappService.fetchChats(leadId).then((value) {
      if (value != null) {
        chatList = chatModelFromJson(jsonEncode(value!));
        isChatLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  Future<void> onSendMessage(BuildContext context, File? file,
      String messageType, String to, String receiverId) async {
    try {
      String? accessToken = await getAccessToken();

      if (accessToken == null) {
        log("Access token is null. User might not be authenticated.");
        AppUtils.oneTimeSnackBar("Authentication error. Please log in again.",
            context: context, bgColor: Colors.red);
        return;
      }

      var url = "https://console.omnisellcrm.com/api/whatsapp/messages/medias";
      onUploadFile(url, file, messageType, to, receiverId, accessToken)
          .then((value) {
        log("onSendMessage() -> status code -> ${value.statusCode}");
        log("onSendMessage() -> response -> ${value.body}");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (value.statusCode == 200) {
            AppUtils.oneTimeSnackBar("Message Sent",
                context: context, bgColor: Colors.green, time: 2);
          } else {
            // AppUtils.oneTimeSnackBar("Error: ${value.body}", context: context);
          }
        });
      });
    } catch (e) {
      log("Error in onSendMessage: $e");
    }
  }

  Future<http.Response> onUploadFile(
      String url,
      File? selectedFile,
      String messageType,
      String to,
      String receiverId,
      String? accessToken) async {
    // Make sure the file exists
    if (selectedFile == null || !await selectedFile.exists()) {
      throw Exception("File does not exist or is null");
    }

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Headers
    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken"
      // Don't manually set Content-Type, it will be set automatically with the boundary
    };

    // Add form fields - ensure field names match exactly what the server expects
    request.fields["to"] = to;
    request.fields["receiver_id"] = receiverId;
    request.fields["message_type"] = messageType;

    // Add file with correct field name 'file' to match the server's expectation
    var fileStream = http.ByteStream(selectedFile.openRead());
    var fileLength = await selectedFile.length();

    var multipartFile = http.MultipartFile(
        'file', // This must match the field name the server expects
        fileStream,
        fileLength,
        filename: selectedFile.path.split('/').last,
        contentType: MediaType.parse(_getMediaType(selectedFile.path)));

    request.files.add(multipartFile);
    request.headers.addAll(headers);

    // Log request details
    log("Uploading file to: $url");
    log("File size: $fileLength bytes");
    log("Request fields: ${request.fields}");

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Log the response
    log("Response status: ${response.statusCode}");
    log("Response body: ${response.body}");

    return response;
  }

// Helper method to determine the content type based on file extension
  String _getMediaType(String path) {
    final extension = path.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      case 'mp4':
        return 'video/mp4';
      case 'mp3':
        return 'audio/mpeg';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      // Add more types as needed
      default:
        return 'application/octet-stream'; // Default binary type
    }
  }

  Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConfig.token);
  }
}
