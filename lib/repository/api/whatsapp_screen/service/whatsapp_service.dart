import 'dart:developer';
import '../../../../core/utils/app_utils.dart';
import '../../../helper/api_helper.dart';

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
        endPoint: "https://www.desaihomes.com/api/whatsapp/beta/message/send?to=$to&message=$message&lead_id=$leadId",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
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
}
