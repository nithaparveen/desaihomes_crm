import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailText extends StatelessWidget {
  const DetailText({
    super.key,
    required this.text,
    required this.value,
    this.textSize,
    this.textFontWeight,
    this.textColor,
  });

  final String text;
  final String value;
  final double? textSize;
  final FontWeight? textFontWeight;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          thickness: 0.2,
          color: ColorTheme.lightgrey,
        ),
        SizedBox(height: 22.h),
        Text(
          text,
          style: GLTextStyles.interStyle(
              size: 12, weight: FontWeight.w400, color: ColorTheme.lightgrey),
        ),
        Text(value,
            style: GLTextStyles.interStyle(
                size: 14, weight: FontWeight.w400, color: ColorTheme.blue)),
      ],
    );
  }
}
