import 'dart:convert';
import 'dart:developer';
import '../../../../core/utils/app_utils.dart';
import '../../../helper/api_helper.dart';
import 'package:http/http.dart' as http;

class WhatsappService {
  static Future<dynamic> fetchConversations() async {
    try {
      var decodedData = await ApiHelper.getDataWObaseUrl(
        endPoint:
            "https://www.desaihomes.com/api/whatsapp/beta/communications/list",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> sendMessage(
      String to, String message, String leadId) async {
    try {
      var decodedData = await ApiHelper.postDataWObaseUrl(
        endPoint:
            "https://www.desaihomes.com/api/whatsapp/beta/message/send?to=$to&message=$message&lead_id=$leadId&msg_type=Text",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> sendTemplate(String to, String templateName,
      String leadId, String message, String parameterFormat) async {
    try {
      var decodedData = await ApiHelper.postDataWObaseUrl(
        endPoint:
            "https://www.desaihomes.com/api/whatsapp-templates/message/send?lead_id=$leadId&to=$to&template_name=$templateName&message=$message&language=en_US&parameter_format=$parameterFormat",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> sendTemplateMessage(Map<String, dynamic> data) async {
    try {
      var decodedData = await ApiHelper.postDataWObaseUrl(
        endPoint:
            "https://www.desaihomes.com/api/whatsapp-templates/message/send",
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AppUtils.getToken()}',
        },
        body: data,
      );

      return decodedData;
    } catch (e) {
      log("Error: $e");
      return {
        "success": false,
        "message": "Error: $e"
      }; // Ensure response is always a Map
    }
  }

  static Future<dynamic> multiSend(Map<String, dynamic> data) async {
    try {
      var decodedData = await ApiHelper.postDataWObaseUrl(
        endPoint:
            "https://www.desaihomes.com/api/whatsapp-templates/message/multisend",
        header: {
          'Content-Type': 'application/json', // Ensure the content-type is set
          'Authorization': 'Bearer ${await AppUtils.getToken()}',
        },
        body: data, // Pass the data directly, it will be encoded in ApiHelper
      );

      return decodedData;
    } catch (e) {
      log("Error: $e");
      return {
        "success": false,
        "message": "Error: $e"
      }; // Ensure response is always a Map
    }
  }

  static Future<dynamic> sendContact(Map<String, dynamic> data) async {
    try {
      var decodedData = await ApiHelper.postDataWObaseUrl(
          endPoint:
              "https://console.omnisellcrm.com/api/whatsapp/messages/contacts",
          header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
          body: data);
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

    static Future<dynamic> checkPhoneNumber(String phone) async {
    try {
      var response = await http.get(  
        Uri.parse("https://www.desaihomes.com/api/phonenumber-check?phone_number=$phone"),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log("Failed. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error: $e");
      return null;
    }
  }

  static Future<dynamic> sendLocation(Map<String, dynamic> data) async {
    try {
      var decodedData = await ApiHelper.postDataWObaseUrl(
          endPoint:
              "https://console.omnisellcrm.com/api/whatsapp/messages/locations",
          header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
          body: data);
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> onConvert(Map<String, dynamic> data) async {
    try {
      var decodedData = await ApiHelper.postDataWObaseUrl(
          endPoint:
              "https://console.omnisellcrm.com/api/whatsapp/beta/lead-list/update",
          header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
          body: data);
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> sendMedias(Map<String, dynamic> data) async {
    try {
      var decodedData = await ApiHelper.postDataWObaseUrl(
          endPoint:
              "https://console.omnisellcrm.com/api/whatsapp/messages/conversations",
          header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
          body: data);
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchChats(leadId) async {
    try {
      var decodedData = await ApiHelper.getDataWObaseUrl(
        endPoint:
            "https://www.desaihomes.com/api/whatsapp/beta/message/list/$leadId",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchWhatsappLeads() async {
    try {
      var decodedData = await ApiHelper.getDataWObaseUrl(
        endPoint: "https://www.desaihomes.com/api/whatsapp/beta/lead-list",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchWhatsAppTemplates() async {
    try {
      var decodedData = await ApiHelper.getDataWObaseUrl(
        endPoint:
            "https://www.desaihomes.com/api/whatsapp-meta-templates/list?approved=true",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }
}
