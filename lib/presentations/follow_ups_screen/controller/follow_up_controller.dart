import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/utils/app_utils.dart';
import 'package:desaihomes_crm_application/repository/api/follow_up_screen/service/follow_up_service.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/lead_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/user_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/service/lead_service.dart';
import 'package:flutter/material.dart';

class FollowUpController extends ChangeNotifier {
  LeadModel leadModel = LeadModel();
  UserListModel userListModel = UserListModel();
  bool isLoading = false;
  bool isUserListLoading = false;
  bool isMoreLoading = false;
  int currentPage = 1;

  fetchData(context) async {
    isLoading = true;
    currentPage = 1;
    notifyListeners();
    FollowUpService.fetchData(page: currentPage).then((value) {
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
    LeadService.fetchUsersData().then((value) {
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

  Future<void> fetchMoreData(BuildContext context) async {
    if (isMoreLoading) return;

    isMoreLoading = true;
    notifyListeners();

    try {
      currentPage++;

      final response = await FollowUpService.fetchData(page: currentPage);
      if (response["status"] == true) {
        final newLeads = LeadModel.fromJson(response);
        if (newLeads.leads?.data != null) {
          leadModel.leads?.data?.addAll(newLeads.leads!.data!);
        }

        isMoreLoading = false;
      } else {
        AppUtils.oneTimeSnackBar(
          "Unable to fetch more data",
          context: context,
          bgColor: ColorTheme.red,
        );
      }
    } catch (error) {
      print("Error fetching more data: $error");
    } finally {
      isMoreLoading = false;
      notifyListeners();
    }
  }
}
