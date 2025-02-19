import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/utils/app_utils.dart';
import 'package:desaihomes_crm_application/repository/api/reports_screen/model/campaign_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/reports_screen/model/reports_model.dart';
import 'package:desaihomes_crm_application/repository/api/reports_screen/service/reports_service.dart';
import 'package:flutter/material.dart';

class ReportsController extends ChangeNotifier {
  ReportsModel reportsModel = ReportsModel();
  CampaignListModel campaignListModel = CampaignListModel();
  bool isLoading = false;
  bool isFilterLoading = false;
  bool isCampaignListLoading = false;

  DateTime? appliedFromDate;
  DateTime? appliedToDate;
  String? appliedProject;
  List<String> appliedLeadSources = [];

  void setFilters({DateTime? from, DateTime? to, String? project, List<String>? sources}) {
    appliedFromDate = from;
    appliedToDate = to;
    appliedProject = project;
    appliedLeadSources = sources ?? [];
    print("$from , $to , $project , $sources");
    notifyListeners();
  }

  fetchData(context) async {
    isLoading = true;
    notifyListeners();
    ReportsService.fetchData().then((value) {
      if (value["status"] == true) {
        reportsModel = ReportsModel.fromJson(value);
        isLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  fetchFilterData({
    String? projectId,
    String? fromDate,
    String? toDate,
    List<String>? leadSources,
    required BuildContext context,
  }) async {
    isFilterLoading = true;
    notifyListeners();
    ReportsService.filterData(
      projectId: projectId,
      fromDate: fromDate,
      toDate: toDate,
      leadSources: leadSources,
    ).then((value) {
      if (value["status"] == true) {
        reportsModel = ReportsModel.fromJson(value);
        isFilterLoading = false;
      } else {
        AppUtils.oneTimeSnackBar(
          "Unable to fetch Data",
          context: context,
          bgColor: ColorTheme.red,
        );
      }
      notifyListeners();
    });
  }

  fetchCampaignList(context) async {
    isCampaignListLoading = true;
    notifyListeners();
    ReportsService.fetchCampaignList().then((value) {
      if (value["status"] == true) {
        campaignListModel = CampaignListModel.fromJson(value);
        isCampaignListLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }
}
