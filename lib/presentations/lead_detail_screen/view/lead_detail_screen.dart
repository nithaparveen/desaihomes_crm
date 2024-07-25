import 'dart:async';

import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
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
    fetchData();
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
            // Provider.of<DashboardController>(context, listen: false)
            //     .fetchData(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const BottomNavBar(),
            //   ),
            // );
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
            String formattedDate =
                controller.leadDetailModel.lead?.requestedDate != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.leadDetailModel.lead!.requestedDate!)
                    : '';
            return controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.grey,
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLeadInfoCard(controller, formattedDate),
                        buildDetailSection(controller),
                        buildStatusSection(controller),
                        buildSourceSection(controller),
                        buildSiteVisitSection(controller),
                        buildNotesSection(controller),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget buildLeadInfoCard(
      LeadDetailController controller, String formattedDate) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${controller.leadDetailModel.lead?.name}",
                    style: GLTextStyles.robotoStyle(
                        size: 18, weight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${controller.leadDetailModel.lead?.project?.name}",
                    style: GLTextStyles.robotoStyle(
                        size: 15, weight: FontWeight.w400),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${controller.leadDetailModel.lead?.source}",
                    style: GLTextStyles.robotoStyle(
                        size: 15, weight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (controller.leadDetailModel.lead?.assignedToDetails?.name !=
                    null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorTheme.yellow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                        "${controller.leadDetailModel.lead?.assignedToDetails?.name}"),
                  ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    GetTimeAgo.parse(DateTime.parse(
                        "${controller.leadDetailModel.lead?.updatedAt}")),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailSection(LeadDetailController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            details.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(details[index],
                          style: GLTextStyles.cabinStyle(size: 18)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Wrap(
                        children: [
                          Text(
                            ": ${getDetailValue(controller, index)}",
                            style: GLTextStyles.cabinStyle(
                                size: 18, weight: FontWeight.w500),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildStatusSection(LeadDetailController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            details1.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(details1[index],
                          style: GLTextStyles.cabinStyle(size: 18)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Wrap(
                        children: [
                          Text(
                            ": ${getStatusValue(controller, index)}",
                            style: GLTextStyles.cabinStyle(
                                size: 18, weight: FontWeight.w500),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSourceSection(LeadDetailController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            details2.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(details2[index],
                          style: GLTextStyles.cabinStyle(size: 18)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Wrap(
                        children: [
                          Text(
                            ": ${getSourceValue(controller, index)}",
                            style: GLTextStyles.cabinStyle(
                                size: 18, weight: FontWeight.w500),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSiteVisitSection(LeadDetailController controller) {
    var size = MediaQuery.sizeOf(context);

    Future<void> selectDate(
        BuildContext context, TextEditingController dateController) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null && pickedDate != DateTime.now()) {
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Site Visits", style: GLTextStyles.cabinStyle(size: 18)),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xff1A3447)),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  selectDate(context, dateController);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    remarkValidate = siteVisitController.text.isEmpty;
                  });
                },
                controller: siteVisitController,
                decoration: InputDecoration(
                  labelText: "Remarks",
                  errorText: remarkValidate ? "Value can't be empty" : null,
                  errorStyle: GLTextStyles.robotoStyle(
                    color: ColorTheme.red,
                    size: 14,
                    weight: FontWeight.w400,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xff1A3447),
                    ),
                  ),
                ),
                maxLines: 3,
              ),
            ),
            SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.3,
              child: MaterialButton(
                color: ColorTheme.blue,
                onPressed: () {
                  final leadDetailController =
                      Provider.of<LeadDetailController>(context, listen: false);
                  if (siteVisitController.text.isNotEmpty) {
                    setState(
                      () {
                        leadDetailController.postSiteVisits(
                          widget.leadId.toString(),
                          dateController.text,
                          siteVisitController.text,
                          context,
                        );
                        siteVisitController.clear();
                        dateController.clear();
                        remarkValidate = false;
                      },
                    );
                  } else {
                    setState(() {
                      remarkValidate = true;
                    });
                  }
                  // remarkValidate = siteVisitController.text.isEmpty;
                  fetchSiteVisits();
                },
                child: Text(
                  "Submit",
                  style: GLTextStyles.robotoStyle(
                    color: ColorTheme.white,
                    size: 16,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.siteVisitModel.data?.length ?? 0,
                itemBuilder: (context, index) => ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${controller.siteVisitModel.data?[index].siteVisitRemarks}"),
                      Text(
                        DateFormat('dd/MM/yyyy').format(controller
                                .siteVisitModel.data?[index].siteVisitDate ??
                            DateTime.now()),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Provider.of<LeadDetailController>(
                                                context,
                                                listen: false)
                                            .deleteSiteVisits(
                                                controller.siteVisitModel
                                                    .data?[index].id,
                                                context);
                                        fetchSiteVisits();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.delete_outline, size: 22),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController
                                  editSiteVisitController =
                                  TextEditingController(
                                text: controller.siteVisitModel.data?[index]
                                    .siteVisitRemarks,
                              );
                              final TextEditingController editDateController =
                                  TextEditingController(
                                text: DateFormat('yyyy-MM-dd').format(controller
                                        .siteVisitModel
                                        .data?[index]
                                        .siteVisitDate ??
                                    DateTime.now()),
                              );
                              return AlertDialog(
                                title: const Text('Edit Note'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: editDateController,
                                      decoration: const InputDecoration(
                                        labelText: 'Date',
                                        prefixIcon: Icon(
                                            Icons.calendar_today_outlined,
                                            size: 20),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xff1A3447)),
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () {
                                        selectDate(context, editDateController);
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    TextField(
                                      controller: editSiteVisitController,
                                      decoration: const InputDecoration(
                                        labelText: 'Note',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xff1A3447)),
                                        ),
                                      ),
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final updatedRemark =
                                          editSiteVisitController.text;
                                      final updatedDate =
                                          editDateController.text;
                                      if (updatedRemark.isNotEmpty &&
                                          updatedDate.isNotEmpty) {
                                        Provider.of<LeadDetailController>(
                                                context,
                                                listen: false)
                                            .editSiteVisits(
                                                controller.siteVisitModel
                                                    .data![index].id,
                                                updatedRemark,
                                                updatedDate,
                                                context);
                                        fetchSiteVisits();
                                        // Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit, size: 22),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotesSection(LeadDetailController controller) {
    var size = MediaQuery.sizeOf(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Notes", style: GLTextStyles.cabinStyle(size: 18)),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: noteController,
                decoration: InputDecoration(
                  labelText: "Notes",
                  errorStyle: GLTextStyles.robotoStyle(
                    color: ColorTheme.red,
                    size: 14,
                    weight: FontWeight.w400,
                  ),
                  errorText: noteValidate ? "Value can't be empty" : null,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xff1A3447)),
                  ),
                ),
                maxLines: 3,
              ),
            ),
            SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.3,
              child: MaterialButton(
                color: ColorTheme.blue,
                onPressed: () {
                  final leadDetailController =
                      Provider.of<LeadDetailController>(context, listen: false);
                  if (noteController.text.isNotEmpty) {
                    leadDetailController.postNotes(
                        widget.leadId.toString(), noteController.text, context);
                  }
                  noteValidate = noteController.text.isEmpty;
                  fetchNotes();
                  noteController.clear();
                },
                child: Text(
                  "Submit",
                  style: GLTextStyles.robotoStyle(
                    color: ColorTheme.white,
                    size: 16,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.notesModel.data?.length ?? 0,
                itemBuilder: (context, index) => ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${controller.notesModel.data?[index].notes}"),
                      Text(
                        controller.notesModel.data?[index].createdUser?.name ??
                            '',
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(
                            controller.notesModel.data?[index].createdAt ??
                                DateTime.now()),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Provider.of<LeadDetailController>(
                                                context,
                                                listen: false)
                                            .deleteNotes(
                                                controller
                                                    .notesModel.data?[index].id,
                                                context);
                                        fetchNotes();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.delete_outline, size: 22),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController editNoteController =
                                  TextEditingController(
                                text: controller.notesModel.data?[index].notes,
                              );
                              return AlertDialog(
                                title: const Text('Edit Note'),
                                content: TextField(
                                  controller: editNoteController,
                                  decoration: const InputDecoration(
                                    labelText: 'Note',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Color(0xff1A3447)),
                                    ),
                                  ),
                                  maxLines: 3,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final updatedNote =
                                          editNoteController.text;
                                      if (updatedNote.isNotEmpty) {
                                        Provider.of<LeadDetailController>(
                                                context,
                                                listen: false)
                                            .editNotes(
                                                controller
                                                    .notesModel.data![index].id,
                                                updatedNote,
                                                context);
                                        fetchData();
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
      case "Location":
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
      case "Referred By":
        return controller.leadDetailModel.lead?.referredBy ?? "";
      case "Description":
        return controller.leadDetailModel.lead?.remarks ?? "";
      case "Campaign Name":
        return controller.leadDetailModel.lead?.campaignName ?? "";
      case "Landing Page URL":
        return controller.leadDetailModel.lead?.landingPageUrl ?? "";
      case "Source":
        return controller.leadDetailModel.lead?.source ?? "";
      case "Adset":
        return controller.leadDetailModel.lead?.adset ?? "";
      case "Ad Name":
        return controller.leadDetailModel.lead?.adName ?? "";
      case "Og Source URL":
        return controller.leadDetailModel.lead?.ogSourceUrl ?? "";
      case "Utm Source":
        return controller.leadDetailModel.lead?.utmSource ?? "";
      case "User Agent":
        return controller.leadDetailModel.lead?.userAgent ?? "";
      case "Agent":
        return "";
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
  "Location",
  "Country",
  "City",
  "Requested Date",
  "Lead Source",
  "Referred By",
  "Description",
  "Campaign Name",
  "Landing Page URL",
  "Source",
  "Adset",
  "Ad Name",
  "Og Source URL",
  "Utm Source",
  "User Agent",
  "Agent",
  "Referred by",
];
