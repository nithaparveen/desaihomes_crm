import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/view/bottom_navigation_screen.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/textstyles.dart';
import '../../dashboard_screen/controller/dashboard_controller.dart';

class LeadDetailScreen extends StatefulWidget {
  const LeadDetailScreen({
    super.key,
    required this.id,
  });

  final int? id;

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() {
    Provider.of<LeadDetailController>(context, listen: false)
        .fetchDetailData(widget.id, context);
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
              Provider.of<DashboardController>(context, listen: false)
                  .fetchData(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBar(),
                  ));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            )),
      ),
      body: Consumer<LeadDetailController>(builder: (context, controller, _) {
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
              ))
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
      }),
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
                  Text("${controller.leadDetailModel.lead?.name}",
                      style: GLTextStyles.robotoStyle(
                          size: 18, weight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text("${controller.leadDetailModel.lead?.project?.name}",
                      style: GLTextStyles.robotoStyle(
                          size: 15, weight: FontWeight.w400)),
                  const SizedBox(height: 4),
                  Text("${controller.leadDetailModel.lead?.source}",
                      style: GLTextStyles.robotoStyle(
                          size: 15, weight: FontWeight.w400)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                controller.leadDetailModel.lead?.assignedToDetails?.name != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ColorTheme.yellow,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                            "${controller.leadDetailModel.lead?.assignedToDetails?.name}"),
                      )
                    : const SizedBox.shrink(),
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
                      style: const TextStyle(fontSize: 12)),
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
          children: List.generate(details.length, (index) {
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
                    child: Wrap(children: [
                      Text(
                        ": ${getDetailValue(controller, index)}",
                        style: GLTextStyles.cabinStyle(
                            size: 18, weight: FontWeight.w500),
                        overflow: TextOverflow.fade,
                      ),
                    ]),
                  ),
                ],
              ),
            );
          }),
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
          children: List.generate(details1.length, (index) {
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
                    child: Wrap(children: [
                      Text(
                        ": ${getStatusValue(controller, index)}",
                        style: GLTextStyles.cabinStyle(
                            size: 18, weight: FontWeight.w500),
                        overflow: TextOverflow.fade,
                      ),
                    ]),
                  ),
                ],
              ),
            );
          }),
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
          children: List.generate(details2.length, (index) {
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
                    child: Wrap(children: [
                      Text(
                        ": ${getSourceValue(controller, index)}",
                        style: GLTextStyles.cabinStyle(
                            size: 18, weight: FontWeight.w500),
                        overflow: TextOverflow.fade,
                      ),
                    ]),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildSiteVisitSection(LeadDetailController controller) {
    var size = MediaQuery.sizeOf(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Site Visits", style: GLTextStyles.cabinStyle(size: 18)),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Remarks",
                  border: OutlineInputBorder(
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
                onPressed: () {},
                child: Text(
                  "Submit",
                  style: GLTextStyles.robotoStyle(
                      color: ColorTheme.white,
                      size: 16,
                      weight: FontWeight.w400),
                ),
              ),
            )
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Notes", style: GLTextStyles.cabinStyle(size: 18)),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Notes",
                  border: OutlineInputBorder(
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
                onPressed: () {},
                child: Text(
                  "Submit",
                  style: GLTextStyles.robotoStyle(
                      color: ColorTheme.white,
                      size: 16,
                      weight: FontWeight.w400),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // SizedBox(
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     itemBuilder: (context, index) => ListTile(
            //       title: Text("${controller.notesModel.data?[index].notes}"),
            //       trailing: Row(
            //         children: [
            //           IconButton(
            //               onPressed: () {}, icon: Icon(Icons.delete_outline)),
            //           IconButton(
            //               onPressed: () {}, icon: Icon(Icons.edit)),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
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
