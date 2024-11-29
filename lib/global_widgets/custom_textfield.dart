import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? Icon;
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
    this.maxlines, this.Icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          width: width,
          child: TextFormField(
            controller: controller,
            obscureText: isPasswordField ? obscureText : false,
            keyboardType: keyboardType ?? TextInputType.text,
            style: GLTextStyles.manropeStyle(
              weight: FontWeight.w400,
              size: 14,
              color: const Color.fromARGB(255, 105, 105, 105),
            ),
            validator: validator,
            cursorColor: ColorTheme.desaiGreen,
            onChanged: onChanged,
            onTap: onTap,
            readOnly: readOnly,
            focusNode: focusNode,
            maxLines: maxlines,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(border ?? 8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(border ?? 8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(border ?? 8),
                borderSide: BorderSide.none,
              ),
              
              focusColor: Colors.transparent,
              hintText: hintText,
              icon: Icon,
              hintStyle: GLTextStyles.manropeStyle(
                weight: FontWeight.w400,
                size: 12,
                color: const Color(0xff4E4E4E),
              ),
              fillColor: Color.fromARGB(26, 161, 161, 161),
              filled: true,
              errorStyle: const TextStyle(height: 0),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 0.5,
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 0.5,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
        if (validator != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Builder(
              builder: (BuildContext context) {
                final errorText = validator!(controller?.text ?? '');
                return errorText != null
                    ? Text(
                        errorText,
                        style: GLTextStyles.manropeStyle(
                          weight: FontWeight.w400,
                          size: 12,
                          color: ColorTheme.red,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
      ],
    );
  }
}
