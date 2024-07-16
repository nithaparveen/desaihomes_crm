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
}