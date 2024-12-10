import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? icon;
  final bool isPasswordField;
  final bool obscureText;
  final TextInputType? keyboardType;
  final double? width;
  final double? height;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final double? border;
  final int? maxlines;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPasswordField = false,
    this.obscureText = false,
    this.keyboardType,
    this.width,
    this.height,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.validator,
    this.focusNode,
    this.inputFormatters,
    this.border,
    this.maxlines,
    this.icon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final bool shouldObscureText = isPasswordField && (maxlines ?? 1) == 1;
    final int actualMaxLines = isPasswordField ? 1 : (maxlines ?? 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          width: width,
          child: TextFormField(
            controller: controller,
            obscureText: shouldObscureText ? obscureText : false,
            keyboardType: keyboardType ?? TextInputType.text,
            style: GLTextStyles.manropeStyle(
              weight: FontWeight.w400,
              size: 14.sp,
              color: const Color.fromARGB(255, 105, 105, 105),
            ),
            validator: validator,
            cursorColor: ColorTheme.desaiGreen,
            onChanged: onChanged,
            onTap: onTap,
            readOnly: readOnly,
            focusNode: focusNode,
            maxLines: actualMaxLines,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(border ?? 8.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(border ?? 8.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(border ?? 8.r),
                borderSide: BorderSide.none,
              ),
              focusColor: Colors.transparent,
              hintText: hintText,
              icon: icon,
              hintStyle: GLTextStyles.manropeStyle(
                weight: FontWeight.w400,
                size: 12.sp,
                color: const Color(0xff4E4E4E),
              ),
              fillColor: const Color.fromARGB(26, 161, 161, 161),
              filled: true,
              errorStyle: const TextStyle(height: 0),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  width: 0.5.w,
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  width: 0.5.w,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.w, left: 8.w),
            child: Text(
              errorText!,
              style: GLTextStyles.manropeStyle(
                weight: FontWeight.w400,
                size: 12.sp,
                color: ColorTheme.red,
              ),
            ),
          ),
      ],
    );
  }
}
