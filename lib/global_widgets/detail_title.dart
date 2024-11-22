import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';

class DetailTitle extends StatelessWidget {
  const DetailTitle({
    super.key,
    required this.text,
    this.textSize,
    this.textFontWeight,
    this.textColor,
  });

  final String text;
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
          style: GLTextStyles.cabinStyle(size: 20, weight: FontWeight.w600,color: Colors.blue),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.5,
        )
      ],
    );
  }
}
