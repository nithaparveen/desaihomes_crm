import 'dart:developer';

import '../../../../core/utils/app_utils.dart';
import '../../../helper/api_helper.dart';

class DashboardService {
  static Future<dynamic> fetchData() async {
    log("DashboardService -> fetchData()");
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "leads-list",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchUsersData() async {
    log("DashboardService -> fetchUsersData()");
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "users-list",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> assignedToTapped(id,assignedTo) async {
    log("DashboardService -> assignedToTapped()");
    try {
      var decodedData = await ApiHelper.postData(
        endPoint: "lead/action/assigned-to-update?id=$id&assigned_to=$assignedTo",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchLeads({required int page}) async {
    log("DashboardService -> fetchLeads()");
    try {
      var nextPageUrl = "http://www.desaihomes.com/api/leads-list?page=$page";
      var decodedData = await ApiHelper.getDataWObaseUrl(
        endPoint: nextPageUrl,
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
      throw Exception('Failed to fetch leads');
    }
  }
}
