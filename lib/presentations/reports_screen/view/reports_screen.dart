import 'dart:convert';
import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/global_appbar.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/controller/reports_controller.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/report_filter_modal.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/status_report_tile.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/status_report_container.dart';
import 'package:desaihomes_crm_application/repository/api/reports_screen/model/reports_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
      Provider.of<ReportsController>(context, listen: false).fetchData(context);
    });
  }

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
        preferredSize: Size.fromHeight(70.h),
        child: const CustomAppBar(
          backgroundColor: Color(0xffF0F6FF),
          hasRadius: false,
        ),
      ),
      body: Consumer<ReportsController>(
        builder: (context, controller, _) {
          if (controller == null || controller.reportsModel.data == null) {
            return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 32,
                ));
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Container(
                      height: 218.h,
                      width: 1.sw,
                      decoration: const BoxDecoration(
                        color: Color(0xffF0F6FF),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    controller.reportsModel.data?.totalLeads
                                        .toString() ?? " ",
                                    style: GLTextStyles.interStyle(
                                      size: 42.sp,
                                      weight: FontWeight.w600,
                                      color: const Color(0xff181D27),
                                    ),
                                  ),
                                  Text(
                                    "Total Leads",
                                    style: GLTextStyles.interStyle(
                                      size: 16.sp,
                                      weight: FontWeight.w500,
                                      color: const Color(0xff181D27),
                                    ),
                                  ),
                                ],
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
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF170E2B),
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                      child: Row(children: [
                                        Icon(
                                          Iconsax.calendar_2,
                                          size: 18.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "Filter Reports",
                                          style: GLTextStyles.manropeStyle(
                                            color: ColorTheme.white,
                                            size: 13.sp,
                                            weight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 16.sp,
                                          color: Colors.white,
                                        )
                                      ]),
                                    ),
                                    SizedBox(width: 4.w),
                                    if (_isFilterApplied)
                                      GestureDetector(
                                        onTap: clearFilter,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 7.w, vertical: 7.h),
                                          child: Icon(
                                            Icons.close,
                                            size: 18.sp,
                                            color: const Color.fromARGB(
                                                255, 79, 79, 79),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StatusReportContainer(
                              color: const Color(0xFFFFF1E3),
                              icon: Iconsax.people,
                              borderColor: const Color(0xFFFFF9C6),
                              shadowColor: const Color(0xFFFCF5B3),
                              count: controller
                                      .reportsModel.data?.statusLeadData
                                      ?.firstWhere(
                                        (element) =>
                                            element.statusName == "New Leads",
                                        orElse: () =>
                                            StatusLeadDatum(leadCount: 0),
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
                              count:
                                  controller.reportsModel.data?.statusLeadData
                                          ?.firstWhere(
                                            (element) =>
                                                element.statusName == "Booked",
                                            orElse: () =>
                                                StatusLeadDatum(leadCount: 0),
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
                              count: controller
                                      .reportsModel.data?.statusLeadData
                                      ?.firstWhere(
                                        (element) =>
                                            element.statusName == "In Followup",
                                        orElse: () =>
                                            StatusLeadDatum(leadCount: 0),
                                      )
                                      .leadCount ??
                                  0,
                              statusType: "In Followup",
                              iconColor: const Color(0xff6270F0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        "Lead Performance Overview",
                        style: GLTextStyles.manropeStyle(
                          size: 18.sp,
                          weight: FontWeight.w600,
                          color: const Color(0xff120e2b),
                        ),
                      ),
                      SizedBox(height: 25.h),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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

                    final count = controller.reportsModel.data?.statusLeadData
                            ?.firstWhere(
                              (element) =>
                                  element.statusName == statusTypes[index],
                              orElse: () => StatusLeadDatum(leadCount: 0),
                            )
                            .leadCount ??
                        0;

                    return StatusReportTile(
                      icon: ((index ~/ 1) + (index % 1)) % 2 == 0
                          ? Icons.bar_chart_rounded
                          : Icons.trending_up_sharp,
                      count: count.toString(),
                      statusType: statusTypes[index],
                    );
                  },
                  childCount: 9,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
