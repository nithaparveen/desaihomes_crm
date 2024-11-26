import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String? hintText;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final Function()? onTap;
  final double? height;
  final double? width;
  final bool readOnly;

  const FormTextField({
    Key? key,
    this.hintText,
    this.suffixIcon,
    this.controller,
    this.textStyle,
    this.onTap,
    this.height = 35.0,
    this.width = double.infinity,
    this.readOnly = true,
  }) : super(key: key);

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
          style: textStyle ?? const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Color.fromARGB(255, 87, 87, 87),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon , size: 15,) : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffD5D7DA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffD5D7DA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
