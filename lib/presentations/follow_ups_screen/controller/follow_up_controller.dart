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
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isUserListLoading = false;
  bool isMoreLoading = false;
  bool isFollowUpFilterLoading = false;
  int currentPage = 1;
   bool hasMoreData = true;
   static const int itemsPerPage = 10;
  
  // Add filter state variables
  String? _currentSearchKeyword;
  String? _currentProjectId;
  String? _currentFromDate;
  String? _currentToDate;
  bool isFiltered = false;

  fetchData(context) async {
    isLoading = true;
    currentPage = 1;
    isFiltered = false; // Reset filter state
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

   searchLeads(BuildContext context, {int page = 1}) async {
    String keyword = searchController.text.trim();

    if (keyword.isEmpty) {
      fetchData(context);
      return;
    }
    
    isLoading = page == 1; 
    isMoreLoading = page > 1;
    _currentSearchKeyword = keyword;
    currentPage = page;
    notifyListeners();

    try {
      // Fetch search results
      final result = await LeadService.searchFollowUpLead(keyword, page: page);

      if (result != null && result['status'] == true) {
        final fetchedData = LeadModel.fromJson(result);

        if (page == 1) {
          // Replace existing data for the first page
          leadModel = fetchedData;
        } else {
          // Append new data for subsequent pages
          leadModel.leads?.data?.addAll(fetchedData.leads?.data ?? []);
        }

        // Determine if more data is available
        hasMoreData = fetchedData.leads?.data?.isNotEmpty ?? false;
      } else {
        // Show a no results message if no data is found
        AppUtils.oneTimeSnackBar(
          "No results found",
          context: context,
          bgColor: ColorTheme.red,
        );
      }
    } catch (e) {
      // Handle exceptions and notify users
      AppUtils.oneTimeSnackBar(
        "Error searching leads",
        context: context,
        bgColor: ColorTheme.red,
      );
    } finally {
      // Reset loading states
      isLoading = false;
      isMoreLoading = false;
      notifyListeners();
    }
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
    if (isMoreLoading || !hasMoreData) return;

    isMoreLoading = true;
    notifyListeners();

    try {
      currentPage++;
      
      if (_currentSearchKeyword?.isNotEmpty ?? false) {
        return searchLeads(context, page: currentPage);
      }
      
      final response = isFiltered 
          ? await LeadService.followUpFilterData(
              projectId: _currentProjectId,
              fromDate: _currentFromDate,
              toDate: _currentToDate,
              page: currentPage,
            )
          : await FollowUpService.fetchData(page: currentPage);

      if (response["status"] == true) {
        final newLeads = LeadModel.fromJson(response);
        if (newLeads.leads?.data?.isNotEmpty ?? false) {
          leadModel.leads?.data?.addAll(newLeads.leads?.data ?? []);
          hasMoreData = (newLeads.leads?.data?.length ?? 0) >= itemsPerPage;
        } else {
          hasMoreData = false;
        }
      } else {
        hasMoreData = false;
        AppUtils.oneTimeSnackBar(
          "Unable to fetch more data",
          context: context,
          bgColor: ColorTheme.red,
        );
      }
    } catch (error) {
      print("Error fetching more data: $error");
      hasMoreData = false;
      currentPage--;
    } finally {
      isMoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> followUpFilterData({
    String? projectId,
    String? fromDate,
    String? toDate,
    required BuildContext context,
    int page = 1,
  }) async {
    isFollowUpFilterLoading = page == 1;
    _currentProjectId = projectId;
    _currentFromDate = fromDate;
    _currentToDate = toDate;
    isFiltered = true;
    currentPage = page;
    notifyListeners();

    try {
      final value = await LeadService.followUpFilterData(
        projectId: projectId,
        fromDate: fromDate,
        toDate: toDate,
        page: page,
      );

      if (value["status"] == true) {
        if (page == 1) {
          leadModel = LeadModel.fromJson(value);
        } else {
          var fetchedData = LeadModel.fromJson(value);
          leadModel.leads?.data?.addAll(fetchedData.leads?.data ?? []);
        }
        isFollowUpFilterLoading = false;
      } else {
        AppUtils.oneTimeSnackBar(
          "Unable to fetch Data",
          context: context,
          bgColor: ColorTheme.red,
        );
      }
    } catch (error) {
      print("Error applying filters: $error");
      AppUtils.oneTimeSnackBar(
        "Error applying filters",
        context: context,
        bgColor: ColorTheme.red,
      );
    } finally {
      isFollowUpFilterLoading = false;
      notifyListeners();
    }
  }

  void clearFilters(BuildContext context) {
    _currentProjectId = null;
    _currentFromDate = null;
    _currentToDate = null;
    isFiltered = false;
    fetchData(context);
  }
}
