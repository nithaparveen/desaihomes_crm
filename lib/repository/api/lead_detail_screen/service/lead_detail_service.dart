import 'dart:developer';

import '../../../../core/utils/app_utils.dart';
import '../../../helper/api_helper.dart';

class LeadDetailService{
  static Future<dynamic> fetchDetailData(id) async {
    log("LeadDetailService -> fetchDetailData()");
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "lead-details/$id",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchNotes(leadId) async {
    log("LeadDetailService -> fetchNotes()");
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "lead/notes?id=$leadId",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> postNotes(leadId,notes) async {
    log("LeadDetailService -> postNotes()");
    try {
      var decodedData = await ApiHelper.postData(
        endPoint: "lead/save-note?id=$leadId&notes=$notes",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchSiteVisits(leadId) async {
    log("LeadDetailService -> fetchSiteVisits()");
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "site-visit/list?lead_id=$leadId",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }
  static Future<dynamic> deleteSiteVisits(int id) async {
    log("LeadDetailService -> deleteSiteVisits()");
    try {
      var decodedData = await ApiHelper.postData(
        endPoint: "site-visit/delete?id=$id",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }
}