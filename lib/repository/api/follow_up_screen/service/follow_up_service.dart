import 'dart:developer';
import 'package:desaihomes_crm_application/core/utils/app_utils.dart';
import 'package:desaihomes_crm_application/repository/helper/api_helper.dart';

class FollowUpService {
  static Future<dynamic> fetchData() async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "follow-up-leads",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }
}
