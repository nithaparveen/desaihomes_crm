import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormTextField extends StatelessWidget {
  final String? hintText;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final Function()? onTap;
  final double? height;
  final double? width;
  final bool readOnly;
  final int? maxLines;

  const FormTextField({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.controller,
    this.textStyle,
    this.onTap,
    this.height = 35.0,
    this.width = double.infinity,
    this.readOnly = false,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: TextField( 
          controller: controller,
          readOnly: readOnly,
          style: textStyle ??
              GLTextStyles.manropeStyle(
                weight: FontWeight.w400,
                size: 14.sp,
                color: const Color.fromARGB(255, 87, 87, 87),
              ),
          cursorColor: ColorTheme.desaiGreen,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            suffixIcon: suffixIcon != null
                ? Icon(
                    suffixIcon,
                    size: 15.sp,
                  )
                : null,
            contentPadding:
                 EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xffD5D7DA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xffD5D7DA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
