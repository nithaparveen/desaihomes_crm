import 'dart:developer';
import 'package:desaihomes_crm_application/core/utils/app_utils.dart';
import 'package:desaihomes_crm_application/repository/helper/api_helper.dart';

class FollowUpService {
  static Future<dynamic> fetchData( {required int page}) async {
    try {
      var decodedData = await ApiHelper.getData(
        endPoint: "follow-up-leads?page=$page",
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }
    static Future<dynamic> fetchMoreData({required int page}) async {
    try {
      var nextPage =
          "http://www.desaihomes.com/api/follow-up-leads?page=$page";
      var decodedData = await ApiHelper.getDataWObaseUrl(
        endPoint: nextPage,
        header: ApiHelper.getApiHeader(access: await AppUtils.getToken()),
      );
      return decodedData;
    } catch (e) {
      throw Exception('Failed to fetch leads');
    }
  }
}
  