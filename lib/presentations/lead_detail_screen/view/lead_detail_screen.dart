import 'dart:async';
import 'package:desaihomes_crm_application/global_widgets/detail_title.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/detail_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/notes_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/site_visit_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/source_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/status_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/textstyles.dart';

class LeadDetailScreen extends StatefulWidget {
  final int? leadId;

  const LeadDetailScreen({super.key, this.leadId});

  @override
  LeadDetailScreenState createState() => LeadDetailScreenState();
}

class LeadDetailScreenState extends State<LeadDetailScreen> {
  final TextEditingController noteController = TextEditingController();
  final TextEditingController siteVisitController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool remarkValidate = false;
  bool noteValidate = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
      fetchNotes();
      fetchSiteVisits();
    });

    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    siteVisitController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchDetailData(widget.leadId, context);
  }

  Future<void> fetchNotes() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchNotes(widget.leadId, context);
  }

  Future<void> fetchSiteVisits() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchSiteVisits(widget.leadId, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Details",
          style: GLTextStyles.robotoStyle(size: 22, weight: FontWeight.w500),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchData(),
        child: Consumer<LeadDetailController>(
          builder: (context, controller, _) {
            return controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.grey,
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LeadInfoCard(controller: controller),
                        const DetailTitle(
                          text: "Basic Information",
                          textSize: 20,
                          textFontWeight: FontWeight.w400,
                          textColor: Color.fromARGB(255, 54, 80, 196),
                        ),
                        DetailSection(
                          controller: controller,
                          details: details,
                          getDetailValue: getDetailValue,
                        ),
                        StatusSection(
                          controller: controller,
                          details1: details1,
                          getStatusValue: getStatusValue,
                        ),
                        SourceSection(
                          controller: controller,
                          details2: details2,
                          getSourceValue: getSourceValue,
                        ),
                        SiteVisitSection(
                          remarkValidate: remarkValidate,
                          fetchSiteVisits: fetchSiteVisits,
                          leadId: widget.leadId?.toString() ?? '',
                        ),
                        NotesSection(
                          noteValidate: noteValidate,
                          fetchNotes: fetchNotes,
                          leadId: widget.leadId?.toString() ?? '',
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  String getDetailValue(LeadDetailController controller, int index) {
    switch (details[index]) {
      case "Lead Type":
        return controller.leadDetailModel.lead?.crmLeadType?.name ?? "";
      case "Project":
        return controller.leadDetailModel.lead?.project?.name ?? "";
      case "Customer Name":
        return controller.leadDetailModel.lead?.name ?? "";
      case "Phone Number":
        return controller.leadDetailModel.lead?.phoneNumber ?? "";
      case "Alternative Phone Number":
        return controller.leadDetailModel.lead?.altPhoneNumber ?? "";
      case "Email":
        return controller.leadDetailModel.lead?.email ?? "";
      case "Age":
        return controller.leadDetailModel.lead?.ageRange ?? "";
      case "Profession":
        return controller.leadDetailModel.lead?.profession ?? "";
      case "City":
        return controller.leadDetailModel.lead?.city ?? "";
      case "Country":
        return controller.leadDetailModel.lead?.country?.name ?? "";
      case "Requested Date":
        return controller.leadDetailModel.lead?.requestedDate != null
            ? DateFormat('dd/MM/yyyy')
                .format(controller.leadDetailModel.lead!.requestedDate!)
            : "";
      case "Lead Source":
        return controller.leadDetailModel.lead?.source ?? "";
      case "Description":
        return controller.leadDetailModel.lead?.remarks ?? "";
      case "Campaign Name":
        return controller.leadDetailModel.lead?.campaignName ?? "";
      default:
        return "";
    }
  }

  String getSourceValue(LeadDetailController controller, int index) {
    switch (details2[index]) {
      case "source":
        return controller.leadDetailModel.lead?.source ?? "";
      case "city":
        return controller.leadDetailModel.lead?.city ?? "";
      case "campaign_ name":
        return controller.leadDetailModel.lead?.campaignName ?? "";
      case "message":
        return controller.leadDetailModel.lead?.message ?? "";
      case "ip_address":
        return controller.leadDetailModel.lead?.ipAddress ?? "";
      case "utm_source":
        return controller.leadDetailModel.lead?.utmSource ?? "";
      case "Source URL":
        return controller.leadDetailModel.lead?.sourceUrl ?? "";
      default:
        return "";
    }
  }

  String getStatusValue(LeadDetailController controller, int index) {
    switch (details1[index]) {
      case "Status":
        return controller.leadDetailModel.lead?.crmStatusDetails?.name ?? "";
      case "Next Follow Up Date":
        return controller.leadDetailModel.lead?.followUpDate != null
            ? DateFormat('dd/MM/yyyy')
                .format(controller.leadDetailModel.lead!.followUpDate!)
            : "";
      case "Assign To":
        return controller.leadDetailModel.lead?.assignedToDetails?.name ?? "";
      case "Label":
        return controller.leadDetailModel.lead?.phoneNumber ?? "";
      default:
        return "";
    }
  }
}

const List<String> details1 = [
  "Status",
  "Next Follow Up Date",
  "Assign To",
  "Label",
];

const List<String> details2 = [
  "source",
  "city",
  "campaign_ name",
  "message",
  "ip_address",
  "utm_source",
  "Source URL",
];

const List<String> details = [
  "Lead Type",
  "Project",
  "Customer Name",
  "Phone Number",
  "Alternative Phone Number",
  "Email",
  "Age",
  "Profession",
  "Country",
  "City",
  "Requested Date",
  "Lead Source",
  "Referred By",
  "Description",
  "Campaign Name",
];
