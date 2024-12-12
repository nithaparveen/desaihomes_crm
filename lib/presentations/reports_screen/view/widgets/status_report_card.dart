import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusReportCard extends StatelessWidget {
  const StatusReportCard({
    super.key,
    required this.icon,
    required this.count,
    required this.statusType,
  });

  final IconData icon;
  final String count;
  final String statusType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0xffF5F5F5),
      ),
      child: Center(
        child: Padding(
          padding:
              EdgeInsets.only(right: 10.w, top: 10.h, left: 10.w, bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: (35 / ScreenUtil().screenWidth).sw,
                height: (35 / ScreenUtil().screenHeight).sh,
                decoration: const BoxDecoration(
                  color: Color(0xffF6F7FE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: Icon(
                  icon,
                  color: const Color(0xff0097FE),
                  size: 15,
                )),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusType,
                      style: GLTextStyles.interStyle(
                          size: 12.sp,
                          weight: FontWeight.w400,
                          color: const Color(0xff707070)),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      count,
                      style: GLTextStyles.manropeStyle(
                          size: 16.sp,
                          weight: FontWeight.w600,
                          color: const Color(0xff242424)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
