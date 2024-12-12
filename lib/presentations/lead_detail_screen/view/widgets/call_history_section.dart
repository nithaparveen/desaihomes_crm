import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/call_log_listing.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallHistorySection extends StatefulWidget {
  const CallHistorySection(
      {super.key,
      required this.leadId,
      required this.phoneNumber,
      required this.name});
  final String leadId;
  final String phoneNumber;
  final String name;

  @override
  State<CallHistorySection> createState() => _CallHistorySectionState();
}

class _CallHistorySectionState extends State<CallHistorySection> {
  late LeadDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = LeadDetailController();
  }

  @override
  Widget build(BuildContext context) {
    var userName = widget.name;
    var phoneNumber = widget.phoneNumber;

    return Padding(
      padding:  EdgeInsets.only(left: 18.w, right: 18.w, top: 5.w, bottom: 15.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Call Logs",
            style: GLTextStyles.manropeStyle(
              size: 18.sp,
              weight: FontWeight.w600,
              color: const Color(0xff170e2b),
            ),
          ),
          SizedBox(height: 22.h),
          Row(
            children: [
              Container(
                width: (36.12 / ScreenUtil().screenWidth).sw,
                height: (36.12 / ScreenUtil().screenHeight).sh,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: GLTextStyles.manropeStyle(
                      color: ColorTheme.blue,
                      size: 16.sp,
                      weight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    phoneNumber,
                    style: GLTextStyles.manropeStyle(
                      color: ColorTheme.grey,
                      size: 12.sp,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 22.h),
          CallLogList(
            number: phoneNumber,
          )
        ],
      ),
    );
  }
}
