import 'dart:developer';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_utils.dart';
import '../../../helper/api_helper.dart';

class LeadService {
  static Future<dynamic> fetchData({int page = 1}) async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "leads-list?page=$page",
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
    int page = 1,
  }) async {
    try {
      String queryString = "leads-list?page=$page&";

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

  static Future<dynamic> followUpFilterData({
    String? projectId,
    String? fromDate,
    String? toDate,
    int page = 1,
  }) async {
    try {
      String queryString = "follow-up-leads?page=$page&";

      if (projectId != null) {
        queryString += "project_id=$projectId&";
      }

      if (fromDate != null) {
        final formattedFromDate =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(fromDate));
        queryString += "from=$formattedFromDate&";
      }

      if (toDate != null) {
        final formattedToDate =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(toDate));
        queryString += "to=$formattedToDate&";
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

  static Future<Map<String, dynamic>?> searchLead(
    String keyword, {
    int page = 1,
  }) async {
    var decodedData = await ApiHelper.getData(
      endPoint: "leads-list?filter=$keyword&page=$page",
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

  static Future<Map<String, dynamic>?> searchFollowUpLead(
    String keyword, {
    int page = 1,
  }) async {
    var decodedData = await ApiHelper.getData(
      endPoint: "follow-up-leads?filter=$keyword&page=$page",
      header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
    );
    return decodedData is Map<String, dynamic> ? decodedData : null;
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

  static Future<dynamic> fetchLeadType() async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "crm-lead-types",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchLabelList() async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "label/list",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> fetchDuplicateLead(leadId) async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "lead-log-check/$leadId",
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

  static Future<dynamic> createLead() async {
    try {
      var decodedData = await ApiHelper.postData(
        endPoint: "lead/action/create",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }

  static Future<dynamic> quickEdit({
    required int? leadId,
    String? altPhNo,
    String? city,
    int? countryId,
    int? statusId,
    String? date,
    String? ageRange,
    int? projectId,
  }) async {
    try {
      // Create a map with only non-null and non-empty values
      final queryParams = <String, String>{};

      // Add parameters conditionally
      if (leadId != null) {
        queryParams['id'] = leadId.toString();
      }
      if (altPhNo != null && altPhNo.isNotEmpty) {
        queryParams['alt_phone_number'] = altPhNo;
      }
      if (city != null && city.isNotEmpty) {
        queryParams['city'] = city;
      }
      if (countryId != null) {
        queryParams['country_id'] = countryId.toString();
      }
      if (statusId != null) {
        queryParams['crm_status'] = statusId.toString();
      }
      if (date != null && date.isNotEmpty) {
        queryParams['follow_up_date'] = date;
      }
      if (ageRange != null && ageRange.isNotEmpty) {
        queryParams['age_range'] = ageRange;
      }
      if (projectId != null) {
        queryParams['preferred_project_id'] = projectId.toString();
      }

      final uri = Uri(
        scheme: 'http',
        host: 'www.desaihomes.com',
        path: '/api/quick-update',
        queryParameters: queryParams,
      );

      var decodedData = await ApiHelper.postDataWObaseUrl(
        endPoint: uri.toString(),
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("Error in LeadService.quickEdit: $e");
      return null;
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
