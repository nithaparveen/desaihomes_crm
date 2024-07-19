import 'dart:developer';

import '../../../../core/utils/app_utils.dart';
import '../../../helper/api_helper.dart';

class LeadDetailService {
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

  static Future<dynamic> postNotes(leadId, notes) async {
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

  static Future<dynamic> editNotes(int id, String note) async {
    log("LeadDetailService -> editNotes()");
    try {
      var decodedData = await ApiHelper.postData(
        endPoint: "lead/update-note?id=$id&notes=$note",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
      return null;
    }
  }

  static Future<dynamic> deleteNotes(int id) async {
    log("LeadDetailService -> deleteNotes()");
    try {
      var decodedData = await ApiHelper.postData(
        endPoint: "lead/delete-note?id=$id",
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

  static Future<dynamic> editSiteVisits(id) async {
    log("LeadDetailService -> editSiteVisits()");
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "site-visit/edit/$id",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> postSiteVisits(leadId, date, content) async {
    log("LeadDetailService -> postSiteVisits()");
    try {
      var decodedData = await ApiHelper.postData(
        endPoint:
            "site-visit/create?lead_id=$leadId&site_visit_date=$date&site_visit_remarks=$content",
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
