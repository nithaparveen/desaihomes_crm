import 'dart:developer';

import 'package:desaihomes_crm_application/repository/api/dashboard_screen/model/dashboard_model.dart';
import 'package:desaihomes_crm_application/repository/api/dashboard_screen/model/user_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/dashboard_screen/service/dashboard_service.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/app_utils.dart';

class DashboardController extends ChangeNotifier {
  DashboardModel dashboardModel = DashboardModel();
  UserListModel userListModel = UserListModel();
  bool isLoading = false;
  bool isAssignLoading = false;
  bool isUserListLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;

  fetchData(context) async {
    isLoading = true;
    notifyListeners();
    log("DashboardController -> fetchData()");
    DashboardService.fetchData().then((value) {
      if (value["status"] == true) {
        dashboardModel = DashboardModel.fromJson(value);
        isLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  fetchUserList(context) async {
    isUserListLoading = true;
    notifyListeners();
    log("DashboardController -> fetchUserList()");
    DashboardService.fetchUsersData().then((value) {
      if (value["status"] == true) {
        userListModel = UserListModel.fromJson(value);
        isUserListLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  assignedToTapped(String id, String assignedTo, context) async {
    log("DashboardController -> assignedToTapped()");
    DashboardService.assignedToTapped(id, assignedTo).then((value) {
      if (value["status"] == true) {
        // AppUtils.oneTimeSnackBar(value["message"], context: context,textStyle: TextStyle(fontSize: 18));
      } else {
        AppUtils.oneTimeSnackBar(value["message"],
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  loadMoreData(BuildContext context) async {
    if (!isLoadingMore) {
      isLoadingMore = true;
      currentPage++;
      notifyListeners();
      try {
        var response = await DashboardService.fetchLeads(page: currentPage);
        if (response != null && response["status"] == true) {
          var newData = DashboardModel.fromJson(response);
          dashboardModel.leads?.data?.addAll(newData.leads?.data ?? []);
        } else {
          AppUtils.oneTimeSnackBar("error", context: context);
        }
      } catch (e) {
        log("$e");
      } finally {
        isLoadingMore = false;
        notifyListeners();
      }
    }
  }
}
