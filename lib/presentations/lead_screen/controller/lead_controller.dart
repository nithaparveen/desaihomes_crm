import 'dart:convert';
import 'dart:developer';
import 'package:another_flushbar/flushbar.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/age_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/countries_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/duplicate_lead_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/label_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/lead_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/lead_source_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/professions_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/project_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/user_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/service/lead_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../repository/api/lead_screen/model/lead_type_model.dart';

class LeadController extends ChangeNotifier {
  LeadModel leadModel = LeadModel();
  UserListModel userListModel = UserListModel();
  LeadSourceModel leadSourceModel = LeadSourceModel();
  LeadTypeModel leadTypeModel = LeadTypeModel();
  LabelModel labelModel = LabelModel();
  ProjectListModel projectListModel = ProjectListModel();
  ProfessionsListModel professionsListModel = ProfessionsListModel();
  TextEditingController searchController = TextEditingController();
  List<CountriesListModel> countriesList = <CountriesListModel>[];
  List<AgeListModel> ageList = <AgeListModel>[];
  List<ProfessionsListModel> professionList = <ProfessionsListModel>[];
  List<DuplicateLeadModel> duplicateFlag = <DuplicateLeadModel>[];

  bool isLoading = false;
  bool isFilterLoading = false;
  bool isFollowUpFilterLoading = false;
  bool isAssignLoading = false;
  bool isUserListLoading = false;
  bool isProfessionsLoading = false;
  bool isProjectListLoading = false;
  bool isSourceLoading = false;
  bool isTypeLoading = false;
  bool isLabelLoading = false;
  bool isCountriesLoading = false;
  bool isduplicateFlagLoading = false;
  bool isAgeLoading = false;
  int currentPage = 1;
  bool _isLoadingMore = false;
  bool hasMoreData = true;
  final int _pageSize = 15;

  Future<void>? _currentRequest;

  bool get isLoadingMore => _isLoadingMore;

  DateTime? appliedFromDate;
  DateTime? appliedToDate;
  String? appliedProject;
  List<String> appliedLeadSources = [];

  void setFilters(
      {DateTime? from, DateTime? to, String? project, List<String>? sources}) {
    appliedFromDate = from;
    appliedToDate = to;
    appliedProject = project;
    appliedLeadSources = sources ?? [];
    print("$from , $to , $project , $sources");
    notifyListeners();
  }

  void clearFilters() {
    appliedFromDate = null;
    appliedToDate = null;
    appliedProject = null;
    appliedLeadSources.clear();
    notifyListeners();
  }

  Future<void> fetchData(context, {int page = 1}) async {
    isLoading = page == 1;

    currentPage = page;
    notifyListeners();

    LeadService.fetchData(page: page).then((value) {
      if (value["status"] == true) {
        if (page == 1) {
          leadModel = LeadModel.fromJson(value);
        } else {
          var fetchedData = LeadModel.fromJson(value);
          leadModel.leads?.data?.addAll(fetchedData.leads?.data ?? []);
        }

        hasMoreData = leadModel.leads?.data?.isNotEmpty ?? false;
        isLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  Future<void> fetchDuplicatelead(leadId, BuildContext context) async {
    isduplicateFlagLoading = true;
    duplicateFlag = [];
    notifyListeners();

    final resp = await LeadService.fetchDuplicateLead(leadId);

    if (resp != null) {
      duplicateFlag = duplicateLeadModelFromJson(jsonEncode(resp));
    } else {
      AppUtils.oneTimeSnackBar(
        "Unable to fetch Data",
        context: context,
        bgColor: ColorTheme.red,
      );
    }

    isduplicateFlagLoading = false;
    notifyListeners();
  }

  Future<void> fetchCountries(BuildContext context) async {
    isCountriesLoading = true;
    countriesList = [];
    notifyListeners();

    final resp = await LeadService.fetchCountries();

    if (resp != null) {
      countriesList = countriesListModelFromJson(jsonEncode(resp));
    } else {
      AppUtils.oneTimeSnackBar(
        "Unable to fetch Data",
        context: context,
        bgColor: ColorTheme.red,
      );
    }

    isCountriesLoading = false;
    notifyListeners();
  }

  Future<void> fetchAgeList(BuildContext context) async {
    isAgeLoading = true;
    ageList = [];
    notifyListeners();

    final resp = await LeadService.fetchAgeList();

    if (resp != null) {
      ageList = ageListModelFromJson(jsonEncode(resp));
    } else {
      AppUtils.oneTimeSnackBar(
        "Unable to fetch Data",
        context: context,
        bgColor: ColorTheme.red,
      );
    }

    isAgeLoading = false;
    notifyListeners();
  }

  Future<void> fetchProfessionsList(BuildContext context) async {
    isProfessionsLoading = true;
    professionList = [];
    notifyListeners();

    final resp = await LeadService.fetchProfessionsList();

    if (resp != null) {
      professionList = professionsListModelFromJson(jsonEncode(resp));
    } else {
      AppUtils.oneTimeSnackBar(
        "Unable to fetch Data",
        context: context,
        bgColor: ColorTheme.red,
      );
    }

    isProfessionsLoading = false;
    notifyListeners();
  }

  searchLeads(BuildContext context, {int page = 1}) async {
    String keyword = searchController.text.trim();

    if (keyword.isEmpty) {
      fetchData(context);
      return;
    }

    isLoading = page == 1;
    currentPage = page;
    notifyListeners();

    try {
      var result = await LeadService.searchLead(keyword, page: page);

      if (result != null && result['status'] == true) {
        if (page == 1) {
          leadModel = LeadModel.fromJson(result);
        } else {
          var fetchedData = LeadModel.fromJson(result);
          leadModel.leads?.data?.addAll(fetchedData.leads?.data ?? []);
        }

        hasMoreData = leadModel.leads?.data?.isNotEmpty ?? false;
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
    int page = 1,
  }) async {
    isFilterLoading = page == 1;

    currentPage = page;
    notifyListeners();

    LeadService.filterData(
      projectId: projectId,
      fromDate: fromDate,
      toDate: toDate,
      leadSources: leadSources,
      page: page,
    ).then((value) {
      if (value["status"] == true) {
        if (page == 1) {
          leadModel = LeadModel.fromJson(value);
        } else {
          var fetchedData = LeadModel.fromJson(value);
          leadModel.leads?.data?.addAll(fetchedData.leads?.data ?? []);
        }

        hasMoreData = leadModel.leads?.data?.isNotEmpty ?? false;
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

  fetchLeadTypeList(context) async {
    isTypeLoading = true;
    notifyListeners();
    LeadService.fetchLeadType().then((value) {
      if (value["status"] == true) {
        leadTypeModel = LeadTypeModel.fromJson(value);
        isTypeLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  fetchLabelList(context) async {
    isLabelLoading = true;
    notifyListeners();
    LeadService.fetchLabelList().then((value) {
      if (value["status"] == true) {
        labelModel = LabelModel.fromJson(value);
        isLabelLoading = false;
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

  Future<void> assignedToTapped(
      String id, String assignedTo, String name, BuildContext context) async {
    int? leadIndex = -1;
    // Update UI immediately without waiting for the API call
    if (leadModel.leads?.data != null) {
      leadIndex =
          leadModel.leads?.data?.indexWhere((lead) => lead.id.toString() == id);

      if (leadIndex != null && leadIndex != -1) {
        // Update the lead's assigned user immediately
        leadModel.leads?.data?[leadIndex].assignedTo = assignedTo;
        notifyListeners(); // Notify the UI to reflect the change
      }
    }

    try {
      // Make API call to assign the lead
      final value = await LeadService.assignedToTapped(id, assignedTo);

      if (value["status"] == true) {
        if (leadIndex != null) {
          leadModel.leads?.data?[leadIndex].assignedToDetails =
              AssignedToDetails(id: int.parse(assignedTo), name: name);
          notifyListeners();
        }

        // After successfully assigning the lead, keep the data updated
        // if (currentSearchText.isNotEmpty) {
        //   // If we're in search mode, reload the data while maintaining position
        //   LeadService.searchLead(currentSearchText, page: currentPage).then((result) {
        //     if (result != null && result['status'] == true) {
        //       var newData = LeadModel.fromJson(result);
        //       leadModel.leads?.data = newData.leads?.data;
        //       notifyListeners();
        //     }
        //   });
        // } else {
        //   // If not searching, update the UI with the new assignment (without reload)
        //   notifyListeners();
        // }
      } else {
        // If assignment failed, revert the UI changes
        if (leadModel.leads?.data != null) {
          final int? leadIndex = leadModel.leads?.data
              ?.indexWhere((lead) => lead.id.toString() == id);

          if (leadIndex != null && leadIndex != -1) {
            // Revert the assignment if failed
            leadModel.leads?.data?[leadIndex].assignedTo = null;
            notifyListeners(); // Revert the UI immediately
          }
        }

        AppUtils.oneTimeSnackBar(value["message"] ?? "Failed to assign lead",
            context: context, bgColor: Colors.redAccent);
      }
    } catch (e) {
      // Handle any errors during the API call
      // AppUtils.oneTimeSnackBar(
      //   "Error assigning lead",
      //   context: context,
      //   bgColor: Colors.redAccent
      // );
    }
  }

  quickEdit(
      int? leadId,
      String? altPhNo,
      String? city,
      String? date,
      String? ageRange,
      int? countryId,
      int? statusId,
      int? projectId,
      BuildContext context) async {
    try {
      var response = await LeadService.quickEdit(
        leadId: leadId,
        altPhNo: altPhNo,
        city: city,
        countryId: countryId,
        statusId: statusId,
        date: date,
        ageRange: ageRange,
        projectId: projectId,
      );

      if (response != null && response["status"] == true) {
        Navigator.pop(context);
        Flushbar(
          maxWidth: .55.sw,
          backgroundColor: Colors.grey.shade100,
          messageColor: ColorTheme.black,
          icon: Icon(
            Iconsax.save_2,
            color: ColorTheme.green,
            size: 20.sp,
          ),
          message: 'Lead successfully saved',
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      } else {
        // AppUtils.oneTimeSnackBar(
        //   response?["message"] ?? "An unknown error occurred.",
        //   context: context,
        //   bgColor: Colors.redAccent,
        // );
      }
    } catch (e) {
      // AppUtils.oneTimeSnackBar(
      //   "An error occurred: $e",
      //   context: context,
      //   bgColor: Colors.redAccent,
      // );
      log("quickEdit error: $e");
    }
  }

  Future<void> loadMoreData(BuildContext context) async {
    // Don't load more if already loading or no more data
    if (_isLoadingMore || !hasMoreData || _currentRequest != null) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      // Store the current request
      _currentRequest = _loadData(context);
      await _currentRequest;
    } finally {
      _currentRequest = null;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> _loadData(BuildContext context) async {
    final nextPage = currentPage + 1;

    try {
      final response = await LeadService.fetchData(page: nextPage);

      if (response["status"] == true) {
        var fetchedData = LeadModel.fromJson(response);
        final newLeads = fetchedData.leads?.data ?? [];

        // Only update if we got data and are still on the expected page
        if (newLeads.isNotEmpty) {
          leadModel.leads?.data?.addAll(newLeads);
          currentPage = nextPage;

          // Check if we've reached the end
          hasMoreData = newLeads.length >= _pageSize;
        } else {
          hasMoreData = false;
        }
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
        hasMoreData = false;
      }
    } catch (e) {
      log("LoadMoreData error: $e");
      AppUtils.oneTimeSnackBar("Error loading more data",
          context: context, bgColor: ColorTheme.red);
      hasMoreData = false;
    }
  }
}
