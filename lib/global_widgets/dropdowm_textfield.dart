import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class DropdownFormTextField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final TextStyle? textStyle;
  final Function(String?)? onChanged;
  final List<String> items;
  final double? height;
  final double? width;
  final String? initialValue;

  const DropdownFormTextField({
    super.key,
    this.hintText,
    this.icon = Iconsax.arrow_down_1,
    this.textStyle,
    this.onChanged,
    required this.items,
    this.height = 35.0,
    this.width = double.infinity,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure initialValue is in items or set it to null
    final validatedInitialValue =
        (initialValue != null && items.contains(initialValue))
            ? initialValue
            : null;
    return SizedBox(
      height: height,
      width: width,
      child: DropdownButtonFormField<String>(
        value: validatedInitialValue,
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
        style: textStyle ??
            GLTextStyles.manropeStyle(
              weight: FontWeight.w400,
              size: 14.sp,
              color: const Color.fromARGB(255, 87, 87, 87),
            ),
        icon: Icon(icon, size: 15.sp),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Tooltip(
              message: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
