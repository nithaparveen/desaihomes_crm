import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeadChartCard extends StatelessWidget {
  const LeadChartCard(
      {super.key, required this.totalLeadsCOunt, required this.leadCount});
  final String totalLeadsCOunt;
  final int leadCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF0F6FF),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 13.w, top: 24.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(
                color: const Color(0xff0B0D23),
                borderRadius: BorderRadius.circular(12.53.r)),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.w, top: 4.w),
              child: Text(
                "Total Leads",
                style: GLTextStyles.manropeStyle(
                    size: 12.sp, weight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 44.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    totalLeadsCOunt,
                    style: GLTextStyles.interStyle(
                      size: 32.sp,
                      weight: FontWeight.w600,
                      color: const Color(0xff181D27),
                    ),
                  ),
                  Text(
                    "Leads",
                    style: GLTextStyles.interStyle(
                      size: 16.sp,
                      weight: FontWeight.w600,
                      color: const Color(0xff181D27),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
