import 'dart:developer';

import 'package:desaihomes_crm_application/repository/api/lead_detail_screen/model/lead_detail_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_detail_screen/service/lead_detail_service.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/app_utils.dart';

class LeadDetailController extends ChangeNotifier {
  bool isLoading = false;

  LeadDetailModel leadDetailModel = LeadDetailModel();

  fetchDetailData(id, context) async {
    isLoading = true;
    notifyListeners();
    log("LeadDetailController -> fetchDetailData()");
    LeadDetailService.fetchDetailData(id).then((value) {
      if (value["status"] == true) {
        leadDetailModel = LeadDetailModel.fromJson(value);
        isLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }
}