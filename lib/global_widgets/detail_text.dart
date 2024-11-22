import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';

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
        Text(
          text,
          style: GLTextStyles.cabinStyle(size: 18, weight: FontWeight.w400),
        ),
        Text(value,
            style: GLTextStyles.cabinStyle(size: 20, weight: FontWeight.w500)),
      ],
    );
  }
}
