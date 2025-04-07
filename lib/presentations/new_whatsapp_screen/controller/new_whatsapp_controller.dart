import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:desaihomes_crm_application/repository/api/whatsapp_screen/model/template_model.dart';
import 'package:desaihomes_crm_application/repository/api/whatsapp_screen/model/whatsapp_lead_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:iconsax/iconsax.dart';
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
  List<WhatsappToLeadListModel> whatsappToLeadList =
      <WhatsappToLeadListModel>[];
  bool isChatLoading = false;
  bool isTemplateLoading = false;
  bool isWhatsappLeadsLoading = false;

  void clearChatList() {
    chatList.clear();
    notifyListeners();
  }

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

  Future sendTemplate(String to, String templateName, String message,
      String leadId, String parameterFormat, BuildContext context) async {
    log("WhatsappController -> sendTemplate() started");
    WhatsappService.sendTemplate(
            to, templateName, leadId, message, parameterFormat)
        .then((value) {
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

  Future<void> onConvert(dynamic data, BuildContext context) async {
    try {
      // Always format the data as {"leads": [...]} even for a single lead
      dynamic formattedData;
      if (data is List<Map<String, dynamic>>) {
        // Format as "leads" array for both single and multiple leads
        formattedData = {"leads": data};
      } else {
        // Handle unexpected data format
        AppUtils.oneTimeSnackBar(
          'Invalid lead data format',
          context: context,
          bgColor: Colors.redAccent,
        );
        return;
      }

      final response = await WhatsappService.onConvert(formattedData);

      if (response != null && response['success'] == true) {
        // Show success message
        AppUtils.oneTimeSnackBar(
          response['message'] ?? 'Leads successfully converted',
          context: context,
          bgColor: ColorTheme.desaiGreen,
        );
      } else {
        // Show error message
        final errorMessage = response?['message'] ?? 'Failed to convert leads';
        AppUtils.oneTimeSnackBar(
          errorMessage,
          context: context,
          bgColor: Colors.redAccent,
        );
      }
    } catch (e) {
      AppUtils.oneTimeSnackBar(
        'An error occurred while converting leads',
        context: context,
        bgColor: Colors.redAccent,
      );
      debugPrint('Error converting leads: $e');
    }
  }

  Future sendTemplateMessage(
      String to,
      String templateName,
      String message,
      String leadId,
      String parameterFormat,
      List<String> headers,
      String headerType,
      BuildContext context) async {
    Map<String, dynamic> data = {
      "lead_id": leadId,
      "template_name": templateName,
      "language": "en_US",
      "to": to,
      "message": message,
      "parameter_format": parameterFormat,
      "header_type": headerType,
    };

    // Fix: Ensure headers are passed correctly
    if (headerType == "image") {
      data["header[]"] = "image";
    } else {
      for (var i = 0; i < headers.length; i++) {
        data["header[$i]"] = headers[i];
      }
    }

    var response = await WhatsappService.sendTemplateMessage(data);
    log("API Response: $response");

    if (response != null && response["success"] == true) {
      // AppUtils.oneTimeSnackBar("Messages sent successfully",
      //     context: context, bgColor: Colors.green);
    } else {
      // String errorMessage = response?["message"] ?? "Failed to send messages";
      // AppUtils.oneTimeSnackBar(errorMessage,
      //     context: context, bgColor: Colors.redAccent);
    }
  }

  Future sendMultiMessages(List<int> leadIds, String templateName,
      String language, BuildContext context) async {
    Map<String, dynamic> data = {
      "lead_ids": List<int>.from(leadIds), // Ensure new list
      "template_name": templateName,
      "language": language,
    };
    log("Sending data: $data");
    var response = await WhatsappService.multiSend(data);

    if (response != null && response["success"] == true) {
      log("Sending response: $response");

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

  fetchWhatsappLeads(context) async {
    isWhatsappLeadsLoading = true;
    notifyListeners();
    try {
      final response = await WhatsappService.fetchWhatsappLeads();
      if (response != null && response.isNotEmpty) {
        whatsappToLeadList =
            whatsappToLeadListModelFromJson(jsonEncode(response));

        isWhatsappLeadsLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("No data available",
            context: context, bgColor: ColorTheme.red);
      }
    } catch (e) {
      log('Error fetching WhatsApp leads: $e');
      AppUtils.oneTimeSnackBar("Error fetching data",
          context: context, bgColor: ColorTheme.red);
    } finally {
      notifyListeners();
    }
  }

  Future<void> addMessageToList(ChatModel message) async {
    chatList.add(message);
    notifyListeners();
  }

  Future<void> addMessageToListt(ConversationModel message) async {
    conversationModel.add(message);
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
      onUploadFile(url, file, messageType, to, leadId,
              accessToken.replaceAll('"', ''))
          .then((value) {
        log("onSendMessage() -> status code -> ${value.statusCode}");
        log("onSendMessage() -> response -> ${value.body}");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (value.statusCode == 200) {
            // AppUtils.oneTimeSnackBar("Message Sent",
            //     context: context, bgColor: Colors.green, time: 2);
          } else {
            try {
              final responseBody = jsonDecode(value.body);
              if (responseBody['success'] == false) {
                String errorMessage =
                    responseBody['message'] ?? "An error occurred.";
                if (responseBody['errors'] != null) {
                  final errors = responseBody['errors'] as Map<String, dynamic>;
                  if (errors.containsKey('video')) {
                    errorMessage = errors['video'][0];
                  }
                  if (errors.containsKey('audio')) {
                    errorMessage = errors['audio'][0];
                  }
                  if (errors.containsKey('image')) {
                    errorMessage = errors['image'][0];
                  }
                }
                AppUtils.oneTimeSnackBar(errorMessage,
                    context: context, bgColor: Colors.red);
              } else {
                AppUtils.oneTimeSnackBar("Error: ${value.body}",
                    context: context);
              }
            } catch (e) {
              log("Error parsing response: $e");
              AppUtils.oneTimeSnackBar("An unexpected error occurred.",
                  context: context);
            }
          }
        });
      });
    } catch (e) {
      log("Error in onSendMessage: $e");
      AppUtils.oneTimeSnackBar("An error occurred while sending the message.",
          context: context);
    }
  }

  Future<http.Response> onUploadFile(String url, File? selectedFile,
      String messageType, String to, String leadId, String? accessToken) async {
    // Check if file exists
    if (selectedFile == null) {
      log("No file selected for upload");
      return http.Response('{"error": "No file selected"}', 400);
    }

    if (!await selectedFile.exists()) {
      log("Selected file does not exist: ${selectedFile.path}");
      return http.Response('{"error": "File does not exist"}', 400);
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      log("Access Token: $accessToken");

      // Headers
      Map<String, String> headers = {"Authorization": "Bearer $accessToken"};

      // Add form fields
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

      // Add file with the correct field name based on message type
      var fileStream = http.ByteStream(selectedFile.openRead());

      // Use the messageType to determine the field name for the file
      String fieldName;
      switch (messageType.toLowerCase()) {
        case 'audio':
          fieldName = 'audio';
          break;
        case 'image':
          fieldName = 'image';
          break;
        case 'video':
          fieldName = 'video';
          break;
        case 'document':
          fieldName = 'document';
          break;
        default:
          fieldName = 'file';
      }

      var multipartFile = http.MultipartFile(fieldName, fileStream, fileSize,
          filename: fileName, contentType: MediaType.parse(fileType));

      request.files.add(multipartFile);
      request.headers.addAll(headers);

      // Log request details
      log("Uploading $messageType to: $url");
      log("Request fields: ${request.fields}");

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return response;
    } catch (e) {
      log("Error in onUploadFile: $e");
      return http.Response('{"error": "$e"}', 500);
    }
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
