import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusReportContainer extends StatelessWidget {
  const StatusReportContainer(
      {super.key,
      required this.color,
      required this.icon,
      required this.borderColor,
      required this.shadowColor,
      required this.count,
      required this.statusType,
      required this.iconColor});

  final Color color;
  final Color borderColor;
  final Color shadowColor;
  final Color iconColor;
  final IconData icon;
  final String count;
  final String statusType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(22.06.r),
            bottomRight: Radius.circular(22.06.r),
            topLeft: Radius.circular(22.06.r),
            topRight: Radius.circular(60.43.r)),
        color: color,
      ),
      child: Padding(
        padding:
            EdgeInsets.only(right: 33.w, top: 10.h, left: 12.w, bottom: 17.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: (48 / ScreenUtil().screenWidth).sw,
              height: (48 / ScreenUtil().screenHeight).sh,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withOpacity(
                          0.4),
                      spreadRadius: 0, 
                      blurRadius: 19.18,
                      offset: const Offset(
                          0, 13.43), 
                    ),
                  ]),
              child: Center(
                  child: Icon(
                icon,
                color: iconColor,
                size: 22,
              )),
            ),
            SizedBox(height: 10.h),
            Text(
              count,
              style: GLTextStyles.manropeStyle(
                  size: 15.35.sp, weight: FontWeight.w700, color: Colors.black),
            ),
            SizedBox(height: 5.h),
            Text(
              statusType,
              style: GLTextStyles.manropeStyle(
                  size: 12.47.sp,
                  weight: FontWeight.w400,
                  color: const Color(0xff757575)),
            ),
          ],
        ),
      ),
    );
  }
}
