import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color borderColor;
  final Color? backgroundColor;
  final double borderRadius;
  final double elevation;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.borderColor = const Color(0xffcc0033),
    this.borderRadius = 8.0,
    this.elevation = 0,
    this.width,
    this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(backgroundColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          elevation: MaterialStateProperty.all(elevation),
          side: MaterialStateProperty.all(
            BorderSide(
              width: 1,
              color: borderColor,
            ),
          ),
        ),
        child: Text(
          text,
          style: GLTextStyles.manropeStyle(
            weight: FontWeight.w500,
            size: 14.sp,
            color: textColor ?? const Color(0xffcc0033),
          ),
        ),
      ),
    );
  }
}