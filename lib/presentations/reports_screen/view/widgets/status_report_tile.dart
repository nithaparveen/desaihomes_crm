import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusReportTile extends StatelessWidget {
  const StatusReportTile({
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
    return ListTile(
      title: Text(
        statusType,
        style: GLTextStyles.interStyle(
            size: 12.sp,
            weight: FontWeight.w400,
            color: const Color(0xff707070)),
      ),
      leading: Container(
        width: (35 / ScreenUtil().screenWidth).sw,
        height: (35 / ScreenUtil().screenHeight).sh,
        decoration: const BoxDecoration(
          color: Color(0xffF4F4F4),
          shape: BoxShape.circle,
        ),
        child: Center(
            child: Icon(
          icon,
          color: const Color(0xff170E2B),
          size: 18.sp,
        )),
      ),
      trailing: Text(
        count,
        style: GLTextStyles.manropeStyle(
            size: 16.sp,
            weight: FontWeight.w600,
            color: const Color(0xff242424)),
      ),
    );
  }
}
