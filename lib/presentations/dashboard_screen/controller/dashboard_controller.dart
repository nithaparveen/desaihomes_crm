import 'dart:developer';

import 'package:desaihomes_crm_application/repository/api/dashboard_screen/model/assign_model.dart';
import 'package:desaihomes_crm_application/repository/api/dashboard_screen/model/dashboard_model.dart';
import 'package:desaihomes_crm_application/repository/api/dashboard_screen/model/user_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/dashboard_screen/service/dashboard_service.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/app_utils.dart';

class DashboardController extends ChangeNotifier {
  DashboardModel dashboardModel = DashboardModel();
  AssignModel assignModel = AssignModel();
  UserListModel userListModel = UserListModel();
  bool isLoading = false;
  bool isAssignLoading = false;
  bool isUserListLoading = false;

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

  fetchAssign(context) async {
    isAssignLoading = true;
    notifyListeners();
    log("DashboardController -> fetchAssign()");
    DashboardService.fetchData().then((value) {
      if (value["status"] == true) {
        assignModel = AssignModel.fromJson(value);
        isAssignLoading = false;
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
}
