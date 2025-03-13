import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:desaihomes_crm_application/repository/api/whatsapp_screen/model/template_model.dart';
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
  TemplateModel templateModel = TemplateModel();

  bool isChatLoading = false;
  bool isTemplateLoading = false;

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

  Future sendMessage(
      String to, String message, String leadId, BuildContext context) async {
    log("WhatsappController -> sendMessage() started");
    WhatsappService.sendMessage(to, message, leadId).then((value) {
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

  Future sendMultiMessages(List<int> leadIds, String templateName,
      String language, BuildContext context) async {
    Map<String, dynamic> data = {
      "lead_ids": leadIds,
      "template_name": templateName,
      "language": language,
    };

    var response = await WhatsappService.multiSend(data);

    if (response != null && response["success"] == true) {
      // AppUtils.oneTimeSnackBar("Messages sent successfully",
      //     context: context, bgColor: Colors.green);
    } else {
      // String errorMessage = response?["message"] ?? "Failed to send messages";
      // AppUtils.oneTimeSnackBar(errorMessage,
      //     context: context, bgColor: Colors.redAccent);
    }
  }

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

  fetchWhatsAppTemplates(context) async {
    isTemplateLoading = true;
    notifyListeners();
    WhatsappService.fetchWhatsAppTemplates().then((value) {
      if (value != null) {
        templateModel = TemplateModel.fromJson(value);
        isTemplateLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  Future<void> addMessageToList(ChatModel message) async {
    chatList.add(message);
    notifyListeners();
  }

  Future<void> onSendMessage(BuildContext context, File? file,
      String messageType, String to, String leadId) async {
    try {
      String? accessToken = await getAccessToken();
      if (accessToken == null) {
        log("Access token is null. User might not be authenticated.");
        AppUtils.oneTimeSnackBar("Authentication error. Please log in again.",
            context: context, bgColor: Colors.red);
        return;
      }

      var url = "https://www.desaihomes.com/api/whatsapp/beta/message/send";
      onUploadFile(url, file, messageType, to, leadId, accessToken.replaceAll('"', ''))
          .then((value) {
        log("onSendMessage() -> status code -> ${value.statusCode}");
        log("onSendMessage() -> response -> ${value.body}");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (value.statusCode == 200) {
            // AppUtils.oneTimeSnackBar("Message Sent",
            //     context: context, bgColor: Colors.green, time: 2);
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
    String leadId,
    String? accessToken) async {
  if (selectedFile == null || !await selectedFile.exists()) {
    throw Exception("File does not exist or is null");
  }

  var request = http.MultipartRequest('POST', Uri.parse(url));
  log("Access Token: $accessToken");

  // Headers
  Map<String, String> headers = {
    "Authorization": "Bearer $accessToken"
  };

  // Add form fields - ensure field names match exactly what the server expects
  request.fields["to"] = to;
  request.fields["lead_id"] = leadId;
  request.fields["msg_type"] = messageType;

  // Get file details
  var filePath = selectedFile.path;
  var fileName = filePath.split('/').last;
  var fileSize = await selectedFile.length();
  var fileType = _getMediaType(filePath);

  // Log file details
  log("File Name: $fileName");
  log("File Path: $filePath");
  log("File Type: $fileType");
  log("File Size: $fileSize bytes");

  // Add file with correct field name 'file' to match the server's expectation
  var fileStream = http.ByteStream(selectedFile.openRead());

  var multipartFile = http.MultipartFile(
      'audio', 
      fileStream,
      fileSize,
      filename: fileName,
      contentType: MediaType.parse(fileType));

  request.files.add(multipartFile);
  request.headers.addAll(headers);

  // Log request details
  log("Uploading file to: $url");
  log("Request fields: ${request.fields}");

  // Send the request
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  // Log the response
  log("Response status: ${response.statusCode}");
  log("Response body: ${response.body}");

  return response;
}

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
      default:
        return 'application/octet-stream';
    }
  }

  Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConfig.token);
  }
}
