import 'dart:developer';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/lead_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/user_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/service/lead_service.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/app_utils.dart';

class LeadController extends ChangeNotifier {
  LeadModel leadModel = LeadModel();
  UserListModel userListModel = UserListModel();
  bool isLoading = false;
  bool isAssignLoading = false;
  bool isUserListLoading = false;
  int currentPage = 1;
  bool _isLoadingMore = false;
  bool hasMoreData = true;

  bool get isLoadingMore => _isLoadingMore;

  fetchData(context) async {
    isLoading = true;
    currentPage = 1;
    hasMoreData = true;
    notifyListeners();
    DashboardService.fetchData().then((value) {
      if (value["status"] == true) {
        leadModel = LeadModel.fromJson(value);
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
    DashboardService.assignedToTapped(id, assignedTo).then((value) {
      if (value["status"] == true) {
        // AppUtils.oneTimeSnackBar(value["message"], context: context,textStyle: TextStyle(fontSize: 18));
      } else {
        AppUtils.oneTimeSnackBar(value["message"],
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  Future<void> loadMoreData(BuildContext context) async {
    if (!_isLoadingMore && hasMoreData) {
      _isLoadingMore = true;
      currentPage++;
      notifyListeners();
      try {
        var response = await DashboardService.fetchLeads(page: currentPage);
        if (response != null && response["status"] == true) {
          var newData = LeadModel.fromJson(response);
          if (newData.leads?.data?.isNotEmpty ?? false) {
            leadModel.leads?.data?.addAll(newData.leads?.data ?? []);
          } else {
            hasMoreData = false;
          }
        } else {
          AppUtils.oneTimeSnackBar("error", context: context);
        }
      } catch (e) {
        log("$e");
      } finally {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }
}
