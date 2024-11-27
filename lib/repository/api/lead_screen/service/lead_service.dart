import 'dart:developer';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_utils.dart';
import '../../../helper/api_helper.dart';

class LeadService {
  static Future<dynamic> fetchData() async {
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

  static Future<dynamic> filterData({
    String? projectId,
    String? fromDate,
    String? toDate,
    List<String>? leadSources,
  }) async {
    try {
      String queryString = "leads-list?";

      if (projectId != null) {
        queryString += "project_id=$projectId&";
      }

      if (fromDate != null) {
        final formattedFromDate =
            DateFormat('dd-MM-yyyy').format(DateTime.parse(fromDate));
        queryString += "from_date=$formattedFromDate&";
      }

      if (toDate != null) {
        final formattedToDate =
            DateFormat('dd-MM-yyyy').format(DateTime.parse(toDate));
        queryString += "to_date=$formattedToDate&";
      }

      if (leadSources != null && leadSources.isNotEmpty) {
        for (var source in leadSources) {
          queryString += "lead_source[]=$source&";
        }
      }

      if (queryString.endsWith('&')) {
        queryString = queryString.substring(0, queryString.length - 1);
      }

      var decodedData = await ApiHelper.getData(
        endPoint: queryString,
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> searchLead(String keyword) async {
    var decodedData = await ApiHelper.getData(
      endPoint: "leads-list?filter=$keyword",
      header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
    );
    return decodedData is Map<String, dynamic> ? decodedData : null;
  }

  static Future<dynamic> fetchUsersData() async {
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

  static Future<dynamic> fetchLeadSource() async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "lead-source",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchCountries() async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "countries",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchAgeList() async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "age-ranges",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchProjectList() async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "user-projects",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchProfessionsList() async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "professions",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> assignedToTapped(id, assignedTo) async {
    try {
      var decodedData = await ApiHelper.postData(
        endPoint:
            "lead/action/assigned-to-update?id=$id&assigned_to=$assignedTo",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchLeads({required int page}) async {
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
