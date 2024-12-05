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
        border: Border.all(color: const Color(0xffD5D7DA), width: 1.0),
        borderRadius: BorderRadius.circular(8.0.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 13.w, top: 13.h, bottom: 15.h),
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
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF0263FF), Color(0xFF04D1FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          totalLeadsCOunt,
                          style: GLTextStyles.interStyle(
                            size: 18.26.sp,
                            weight: FontWeight.w600,
                            color: const Color(0xff181D27),
                          ),
                        ),
                        Text(
                          "Leads",
                          style: GLTextStyles.interStyle(
                            size: 11.sp,
                            weight: FontWeight.w600,
                            color: const Color(0xff181D27),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
