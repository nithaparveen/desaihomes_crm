import 'dart:developer';

import 'package:desaihomes_crm_application/core/utils/app_utils.dart';
import 'package:desaihomes_crm_application/repository/helper/api_helper.dart';
import 'package:intl/intl.dart';

class ReportsService {
  static Future<dynamic> fetchData() async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "reports",
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
      String queryString = "reports?";

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
          queryString += "source[]=$source&";
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

    static Future<dynamic> fetchCampaignList() async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "campaign-dropdown-list",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }
}
