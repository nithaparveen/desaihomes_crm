import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/view/bottom_navigation_screen.dart';
import 'package:desaihomes_crm_application/presentations/dashboard_screen/view/dashboard_screen.dart';
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
                    builder: (context) => BottomNavBar(),
                  ));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            )),
      ),
      body: Consumer<LeadDetailController>(builder: (context, controller, _) {
        String formattedDate = controller.leadDetailModel.lead?.requestedDate != null
            ? DateFormat('dd/MM/yyyy').format(controller.leadDetailModel.lead!.requestedDate!)
            : '';
        return controller.isLoading
            ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.grey,
            ))
            : SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // surfaceTintColor: ColorTheme.white,
                // elevation: 0,
                margin: const EdgeInsets.all(6),
                child: Padding(
                  padding:  EdgeInsets.only(left: 16,right: 16,top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${controller.leadDetailModel.lead?.name}",
                                style: GLTextStyles.robotoStyle(
                                    size: 16, weight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(
                                "${controller.leadDetailModel.lead?.project?.name}",
                                style: GLTextStyles.robotoStyle(
                                    size: 15, weight: FontWeight.w400)),
                            const SizedBox(height: 4),
                            Text(
                                "${controller.leadDetailModel.lead?.source}",
                                style: GLTextStyles.robotoStyle(
                                    size: 15, weight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: controller.leadDetailModel.lead
                                  ?.assignedTo ==
                                  null
                                  ? null
                                  : Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: ColorTheme.yellow,
                                  borderRadius:
                                  BorderRadius.circular(15),
                                ),
                                child: Text(
                                    "${controller.leadDetailModel.lead?.assignedToDetails?.name}"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
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
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(details.length, (index) {
                        return Text(details[index], style: GLTextStyles.cabinStyle(size: 18));
                      }),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(": ${controller.leadDetailModel.lead?.crmLeadType?.name}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.project?.name}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.name}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.phoneNumber}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.email}", style: GLTextStyles.cabinStyle(size: 16, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.ageRange}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(controller.leadDetailModel.lead?.profession == null ? ":" : ": ${controller.leadDetailModel.lead!.profession}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.city}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(controller.leadDetailModel.lead?.countryId == null ? ":" : ": ${controller.leadDetailModel.lead?.country?.name}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.city}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": $formattedDate", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.referredBy}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.remarks}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.campaignName}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(controller.leadDetailModel.lead?.landingPageUrl == null ? ": " :": ${controller.leadDetailModel.lead?.landingPageUrl}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.source}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(controller.leadDetailModel.lead?.adset == null ? ": " : ": ${controller.leadDetailModel.lead?.adset}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(controller.leadDetailModel.lead?.adName == null ? ": " :": ${controller.leadDetailModel.lead?.adName}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(controller.leadDetailModel.lead?.ogSourceUrl == null ? ": " :": ${controller.leadDetailModel.lead?.ogSourceUrl}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(controller.leadDetailModel.lead?.utmSource == null ? ": " :": ${controller.leadDetailModel.lead?.utmSource}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                        Text(": ${controller.leadDetailModel.lead?.userAgent}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500),),
                        Text(": ", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),//agent
                        Text(": ${controller.leadDetailModel.lead?.referredBy}", style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

const List<String> details = [
  "Lead Type",
  "Project",
  "Customer Name",
  "Phone Number",
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
