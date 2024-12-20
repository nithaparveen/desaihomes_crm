import 'dart:developer';
import 'package:desaihomes_crm_application/repository/api/lead_detail_screen/model/lead_detail_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_detail_screen/model/notes_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_detail_screen/model/site_visit_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_detail_screen/model/status_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_detail_screen/service/lead_detail_service.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/app_utils.dart';

class LeadDetailController extends ChangeNotifier {
  bool isLoading = false;
  LeadDetailModel leadDetailModel = LeadDetailModel();
  bool isNotesLoading = false;
  NotesModel notesModel = NotesModel();
  bool isSiteVisitsLoading = false;
  SiteVisitModel siteVisitModel = SiteVisitModel();
  bool isStatusListLoading = false;
  StatusListModel statusListModel = StatusListModel();

fetchDetailData(leadId, context) async {
  isLoading = true;
  notifyListeners(); // Notify the UI that loading has started
  try {
    final value = await LeadDetailService.fetchDetailData(leadId);
    if (value["status"] == true) {
      leadDetailModel = LeadDetailModel.fromJson(value);
    } else {
      AppUtils.oneTimeSnackBar(
        "Unable to fetch Data",
        context: context,
        bgColor: ColorTheme.red,
      );
    }
  } catch (e) {
    AppUtils.oneTimeSnackBar(
      "An error occurred while fetching data",
      context: context,
      bgColor: ColorTheme.red,
    );
  } finally {
    isLoading = false; // Ensure loading stops regardless of success or failure
    notifyListeners(); // Notify the UI that loading has ended
  }
}


  fetchNotes(leadId, context) async {
    isNotesLoading = true;
    notifyListeners();
    LeadDetailService.fetchNotes(leadId).then((value) {
      if (value["status"] == true) {
        notesModel = NotesModel.fromJson(value);
        isNotesLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  postNotes(leadId, date, notes, context) async {
    LeadDetailService.postNotes(leadId, date, notes).then((value) {
      if (value["status"] == true) {
        // AppUtils.oneTimeSnackBar(value["message"], context: context,textStyle: TextStyle(fontSize: 18));
      } else {
        AppUtils.oneTimeSnackBar(value["message"],
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  Future<void> editNotes(id, String note, date, BuildContext context) async {
    LeadDetailService.editNotes(id, date, note).then((value) {
      if (value != null && value["status"] == true) {
      } else {
        AppUtils.oneTimeSnackBar(value?["message"] ?? "An error occurred",
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  deleteNotes(id, context) async {
    LeadDetailService.deleteNotes(id).then((value) {
      if (value["status"] == true) {
        // AppUtils.oneTimeSnackBar(value["message"], context: context,textStyle: TextStyle(fontSize: 18));
      } else {
        AppUtils.oneTimeSnackBar(value["message"],
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  fetchSiteVisits(leadId, context) async {
    isSiteVisitsLoading = true;
    notifyListeners();
    log("LeadDetailController -> fetchSiteVisits()");
    LeadDetailService.fetchSiteVisits(leadId).then((value) {
      if (value["status"] == true) {
        siteVisitModel = SiteVisitModel.fromJson(value);
        isSiteVisitsLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  Future<void> editSiteVisits(id, remarks, date, context) async {
    LeadDetailService.editSiteVisits(id, remarks, date).then((value) {
      if (value != null && value["status"] == true) {
      } else {
        AppUtils.oneTimeSnackBar(value?["message"] ?? "An error occurred",
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  postSiteVisits(leadId, date, content, context) async {
    LeadDetailService.postSiteVisits(leadId, date, content).then((value) {
      if (value["status"] == true) {
        // AppUtils.oneTimeSnackBar(value["message"], context: context,textStyle: TextStyle(fontSize: 18));
      } else {
        AppUtils.oneTimeSnackBar(value["message"],
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  deleteSiteVisits(id, context) async {
    LeadDetailService.deleteSiteVisits(id).then((value) {
      if (value["status"] == true) {
        // AppUtils.oneTimeSnackBar(value["message"], context: context,textStyle: TextStyle(fontSize: 18));
      } else {
        AppUtils.oneTimeSnackBar(value["message"],
            context: context, bgColor: Colors.redAccent);
      }
    });
  }

  fetchStatusList(context) async {
    isStatusListLoading = true;
    notifyListeners();
    LeadDetailService.fetchStatusList().then((value) {
      if (value["status"] == true) {
        statusListModel = StatusListModel.fromJson(value);
        isStatusListLoading = false;
      } else {
        AppUtils.oneTimeSnackBar("Unable to fetch Data",
            context: context, bgColor: ColorTheme.red);
      }
      notifyListeners();
    });
  }

  updateStatus(leadId, slug, context) async {
    LeadDetailService.updateStatus(leadId, slug).then((value) {
      if (value["status"] == true) {
        // AppUtils.oneTimeSnackBar(value["message"], context: context,textStyle: TextStyle(fontSize: 18));
      } else {
        AppUtils.oneTimeSnackBar(value["message"],
            context: context, bgColor: Colors.redAccent);
      }
    });
  }
}
