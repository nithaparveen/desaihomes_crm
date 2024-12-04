import 'dart:convert';
import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/logout_button.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/filter_modal.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/lead_chart_card.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/report_filter_modal.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/status_report_card.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/widgets/status_report_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.h),
        child: AppBar(
          backgroundColor: ColorTheme.desaiGreen,
          foregroundColor: ColorTheme.desaiGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          title: FutureBuilder<String?>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text("Unknown User");
              }
              String userName = snapshot.data ?? "Unknown User";
              return Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 202, 158, 208),
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.5, color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        userName.substring(0, 2).toUpperCase(),
                        style: GLTextStyles.robotoStyle(
                          color: ColorTheme.blue,
                          size: 13.sp,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    userName,
                    style: GLTextStyles.manropeStyle(
                      color: ColorTheme.white,
                      size: 14.sp,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
          actions: const [LogoutButton()],
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                        return const ReportFilterModal();
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
                        "May 24 - June 31",
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
                        color: Color(0xFFB5BEC6),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LeadChartCard(),
                  SizedBox(height: 30.h),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatusReportContainer(
                        color: Color(0xFFFFF1E3),
                        icon: Iconsax.arrow_up_3,
                        borderColor: Color(0xFFFFF9C6),
                        shadowColor: Color(0xFFFCF5B3),
                        count: "2142",
                        statusType: "New Leads",
                        iconColor: Color(0xffFF8800),
                      ),
                      StatusReportContainer(
                        color: Color(0xFFE9FFE3),
                        icon: Iconsax.home,
                        borderColor: Color(0xFFC6FFDD),
                        shadowColor: Color(0xffa6f083),
                        count: "316",
                        statusType: "Booked  ",
                        iconColor: Color(0xff52D22E),
                      ),
                      StatusReportContainer(
                        color: Color(0xFFE3E6FF),
                        icon: Iconsax.profile_tick,
                        borderColor: Color(0xFFC7C6FF),
                        shadowColor: Color(0xffb5aeff),
                        count: "8",
                        statusType: "In Followup",
                        iconColor: Color(0xff6270F0),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Lead Performance Overview",
                    style: GLTextStyles.manropeStyle(
                      size: 18.sp,
                      weight: FontWeight.w600,
                      color: const Color(0xff120e2b),
                    ),
                  ),
                  SizedBox(height: 30.h),
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
                        int row = index ~/ 2;
                        int column = index % 2;
                        IconData icon = ((row + column) % 2 == 0)
                            ? Icons.bar_chart_rounded
                            : Icons.trending_up_sharp;
                        return StatusReportCard(
                          icon: icon,
                          count: [
                            '18',
                            '5',
                            '18',
                            '5',
                            '1',
                            '6',
                            '5',
                            '8',
                            '13'
                          ][index],
                          statusType: [
                            'Casual Enquiry',
                            'Lost',
                            'No Response',
                            'Repeated Lead',
                            'Wrong Lead',
                            'Fake Lead',
                            'Wrong Location',
                            'Unable to Convert',
                            'Dropped'
                          ][index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
