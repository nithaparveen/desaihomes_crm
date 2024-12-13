import 'dart:convert';
import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/global_appbar.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/controller/reports_controller.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/lead_chart_card.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/report_filter_modal.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/status_report_card.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/status_report_container.dart';
import 'package:desaihomes_crm_application/repository/api/reports_screen/model/reports_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isFilterApplied = false;
  Future<String?> getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? storedData = sharedPreferences.getString(AppConfig.loginData);

    if (storedData != null) {
      var loginData = jsonDecode(storedData);
      if (loginData["user"] != null && loginData["user"]['name'] != null) {
        return loginData["user"]['name'];
      }
    }
    return null;
  }

  void clearFilter() {
    setState(() {
      _isFilterApplied = false;
      Provider.of<ReportsController>(context, listen: false)
          .fetchData(context); // Refetch original data
    });
  }

  // @override
  // void initState() {
  //   Provider.of<ReportsController>(context).fetchData(context);
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportsController>(context, listen: false).fetchData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.h),
        child: CustomAppBar(backgroundColor: ColorTheme.desaiGreen),
      ),
      body: Consumer<ReportsController>(builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Lead Reports",
                    style: GLTextStyles.manropeStyle(
                      size: 18.sp,
                      weight: FontWeight.w600,
                      color: const Color(0xff120e2b),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ReportFilterModal(
                            clearFiltersCallback: clearFilter,
                            onFilterApplied: () {
                              setState(() {
                                _isFilterApplied = true;
                              });
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(5.5.r),
                      ),
                      child: Row(children: [
                        Icon(
                          Iconsax.calendar,
                          size: 18.sp,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Filter Reports",
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.grey,
                            size: 13.sp,
                            weight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16.sp,
                          color: const Color(0xFFB5BEC6),
                        )
                      ]),
                    ),
                  ),
                  if (_isFilterApplied)
                    GestureDetector(
                      onTap: clearFilter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xff0B0D23),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8.w, right: 8.w, bottom: 4.w, top: 4.w),
                          child: Icon(
                            Icons.close,
                            size: 16.sp,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LeadChartCard(
                      totalLeadsCOunt:
                          controller.reportsModel.data!.totalLeads.toString(),
                      leadCount: controller.reportsModel.data?.statusLeadData
                              ?.firstWhere(
                                (element) => element.statusName == "New Leads",
                                orElse: () => StatusLeadDatum(leadCount: 0),
                              )
                              .leadCount ??
                          0,
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StatusReportContainer(
                          color: const Color(0xFFFFF1E3),
                          icon: Iconsax.people,
                          borderColor: const Color(0xFFFFF9C6),
                          shadowColor: const Color(0xFFFCF5B3),
                          count: controller.reportsModel.data?.statusLeadData
                                  ?.firstWhere(
                                    (element) =>
                                        element.statusName == "New Leads",
                                    orElse: () => StatusLeadDatum(leadCount: 0),
                                  )
                                  .leadCount ??
                              0,
                          statusType: "New Leads",
                          iconColor: const Color(0xffFF8800),
                        ),
                        StatusReportContainer(
                          color: const Color(0xFFE9FFE3),
                          icon: Iconsax.home,
                          borderColor: const Color(0xFFC6FFDD),
                          shadowColor: const Color(0xffa6f083),
                          count: controller.reportsModel.data?.statusLeadData
                                  ?.firstWhere(
                                    (element) => element.statusName == "Booked",
                                    orElse: () => StatusLeadDatum(leadCount: 0),
                                  )
                                  .leadCount ??
                              0,
                          statusType: "Booked        ",
                          iconColor: const Color(0xff52D22E),
                        ),
                        StatusReportContainer(
                          color: const Color(0xFFE3E6FF),
                          icon: Iconsax.profile_tick,
                          borderColor: const Color(0xFFC7C6FF),
                          shadowColor: const Color(0xffb5aeff),
                          count: controller.reportsModel.data?.statusLeadData
                                  ?.firstWhere(
                                    (element) =>
                                        element.statusName == "In Followup",
                                    orElse: () => StatusLeadDatum(leadCount: 0),
                                  )
                                  .leadCount ??
                              0,
                          statusType: "In Followup",
                          iconColor: const Color(0xff6270F0),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Text(
                      "Lead Performance Overview",
                      style: GLTextStyles.manropeStyle(
                        size: 18.sp,
                        weight: FontWeight.w600,
                        color: const Color(0xff120e2b),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xffD5D7DA), width: 1.0),
                        borderRadius: BorderRadius.circular(6.0.r),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.8,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: 9,
                        padding: EdgeInsets.symmetric(
                            vertical: 21.h, horizontal: 16.w),
                        itemBuilder: (context, index) {
                          final statusTypes = [
                            'Casual Enquiry',
                            'Lost',
                            'No Responce',
                            'Repeated Lead',
                            'Wrong Lead',
                            'Fake Lead',
                            'Wrong Location',
                            'Unable to Convert',
                            'Dropped'
                          ];

                          final count =
                              controller.reportsModel.data?.statusLeadData
                                      ?.firstWhere(
                                        (element) =>
                                            element.statusName ==
                                            statusTypes[index],
                                        orElse: () =>
                                            StatusLeadDatum(leadCount: 0),
                                      )
                                      .leadCount ??
                                  0;

                          return StatusReportCard(
                            icon: ((index ~/ 2) + (index % 2)) % 2 == 0
                                ? Icons.bar_chart_rounded
                                : Icons.trending_up_sharp,
                            count: count.toString(),
                            statusType: statusTypes[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
