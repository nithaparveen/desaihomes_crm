import 'dart:developer';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/lead_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/lead_source_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/project_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/user_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/service/lead_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/app_utils.dart';

class LeadController extends ChangeNotifier {
  LeadModel leadModel = LeadModel();
  UserListModel userListModel = UserListModel();
  LeadSourceModel leadSourceModel = LeadSourceModel();
  ProjectListModel projectListModel = ProjectListModel();
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isFilterLoading = false;
  bool isAssignLoading = false;
  bool isUserListLoading = false;
  bool isProjectListLoading = false;
  bool isSourceLoading = false;
  int currentPage = 1;
  bool _isLoadingMore = false;
  bool hasMoreData = true;

  bool get isLoadingMore => _isLoadingMore;

  fetchData(context) async {
    isLoading = true;
    currentPage = 1;
    hasMoreData = true;
    notifyListeners();
    LeadService.fetchData().then((value) {
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

  searchLeads(BuildContext context) async {
    String keyword = searchController.text.trim();

    if (keyword.isEmpty) {
      // If search is empty, revert to original data fetch
      fetchData(context);
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      var result = await LeadService.searchLead(keyword);

      if (result != null && result['status'] == true) {
        leadModel = LeadModel.fromJson(result);
        isLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("No results found",
            context: context, bgColor: ColorTheme.red);
        isLoading = false;
      }
      notifyListeners();
    } catch (e) {
      AppUtils.oneTimeSnackBar("Error searching leads",
          context: context, bgColor: ColorTheme.red);
      isLoading = false;
      notifyListeners();
    }
  }

  fetchFilterData({
    String? projectId,
    String? fromDate,
    String? toDate,
    List<String>? leadSources,
    required BuildContext context,
  }) async {
    isFilterLoading = true;
    currentPage = 1;
    hasMoreData = true;
    notifyListeners();

    LeadService.filterData(
      projectId: projectId,
      fromDate: fromDate,
      toDate: toDate,
      leadSources: leadSources,
    ).then((value) {
      if (value["status"] == true) {
        leadModel = LeadModel.fromJson(value);
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

  fetchLeadSourceList(context) async {
    isSourceLoading = true;
    notifyListeners();
    LeadService.fetchLeadSource().then((value) {
      if (value["status"] == true) {
        leadSourceModel = LeadSourceModel.fromJson(value);
        isSourceLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  fetchProjectList(context) async {
    isProjectListLoading = true;
    notifyListeners();
    LeadService.fetchProjectList().then((value) {
      if (value["status"] == true) {
        projectListModel = ProjectListModel.fromJson(value);
        isProjectListLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  assignedToTapped(String id, String assignedTo, context) async {
    LeadService.assignedToTapped(id, assignedTo).then((value) {
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
        var response = await LeadService.fetchLeads(page: currentPage);
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

  void searchLead(String keyword) {}
}
