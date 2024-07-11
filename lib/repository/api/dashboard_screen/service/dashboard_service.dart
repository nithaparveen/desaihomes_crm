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
}
