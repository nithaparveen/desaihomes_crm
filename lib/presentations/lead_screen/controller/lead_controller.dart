import 'dart:convert';
import 'dart:developer';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/age_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/countries_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/lead_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/lead_source_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/professions_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/project_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/user_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/service/lead_service.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/app_utils.dart';

class LeadController extends ChangeNotifier {
  LeadModel leadModel = LeadModel();
  UserListModel userListModel = UserListModel();
  LeadSourceModel leadSourceModel = LeadSourceModel();
  ProjectListModel projectListModel = ProjectListModel();
  ProfessionsListModel professionsListModel = ProfessionsListModel();
  TextEditingController searchController = TextEditingController();
  List<CountriesListModel> countriesList = <CountriesListModel>[];
  List<AgeListModel> ageList = <AgeListModel>[];
  List<ProfessionsListModel> professionList = <ProfessionsListModel>[];

  bool isLoading = false;
  bool isFilterLoading = false;
  bool isAssignLoading = false;
  bool isUserListLoading = false;
  bool isProfessionsLoading = false;
  bool isProjectListLoading = false;
  bool isSourceLoading = false;
  bool isCountriesLoading = false;
  bool isAgeLoading = false;
  int currentPage = 1;
  bool _isLoadingMore = false;
  bool hasMoreData = true;

  bool get isLoadingMore => _isLoadingMore;

  String? _currentSearchKeyword;
  String? _currentProjectId;
  String? _currentFromDate;
  String? _currentToDate;
  List<String>? _currentLeadSources;

  Future<void> fetchData(context, {int page = 1}) async {
    isLoading = page == 1;
    _currentSearchKeyword = null;
    _currentProjectId = null;
    _currentFromDate = null;
    _currentToDate = null;
    _currentLeadSources = null;

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
    _currentSearchKeyword = keyword;
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
    _currentProjectId = projectId;
    _currentFromDate = fromDate;
    _currentToDate = toDate;
    _currentLeadSources = leadSources;

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
        // AppUtils.oneTimeSnackBar(response["message"], context: context, textStyle: TextStyle(fontSize: 18));
      } else {
        AppUtils.oneTimeSnackBar(
          response?["message"] ?? "An unknown error occurred.",
          context: context,
          bgColor: Colors.redAccent,
        );
      }
    } catch (e) {
      AppUtils.oneTimeSnackBar(
        "An error occurred: $e",
        context: context,
        bgColor: Colors.redAccent,
      );
      log("quickEdit error: $e");
    }
  }

  Future<void> loadMoreData(BuildContext context) async {
    if (!isLoadingMore && hasMoreData) {
      _isLoadingMore = true;
      currentPage++;
      notifyListeners();

      try {
        // Determine which method to call based on current state
        if (_currentSearchKeyword != null) {
          await searchLeads(context, page: currentPage);
        } else if (_currentProjectId != null ||
            _currentFromDate != null ||
            _currentToDate != null ||
            _currentLeadSources != null) {
          await fetchFilterData(
              projectId: _currentProjectId,
              fromDate: _currentFromDate,
              toDate: _currentToDate,
              leadSources: _currentLeadSources,
              context: context,
              page: currentPage);
        } else {
          await fetchData(context, page: currentPage);
        }
      } catch (e) {
        log("LoadMoreData error: $e");
        AppUtils.oneTimeSnackBar("Error loading more data",
            context: context, bgColor: ColorTheme.red);
      } finally {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }
}
