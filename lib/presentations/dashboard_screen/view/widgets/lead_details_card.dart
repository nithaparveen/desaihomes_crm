import 'package:flutter/material.dart';

class LeadDetailsCard extends StatelessWidget {
  const LeadDetailsCard(
      {super.key,
      required this.size,
      this.date,
      this.projectName,
      this.source,
      this.time,
      this.isAssigned,
      this.assignPressed});

  final Size size;
  final String? date;
  final String? projectName;
  final String? source;
  final String? time;
  final bool? isAssigned;
  final Function()? assignPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
