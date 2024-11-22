import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';

class DetailSection extends StatelessWidget {
  final LeadDetailController controller;
  final List<String> details;
  final String Function(LeadDetailController, int) getDetailValue;

  const DetailSection({
    super.key,
    required this.controller,
    required this.details,
    required this.getDetailValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12,right: 12,top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          details.length,
          (index) {
            final detailValue = getDetailValue(controller, index);
            if (details[index].isNotEmpty && 
                detailValue.toString().isNotEmpty && 
                detailValue.toString() != "null") {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details[index],
                      style: GLTextStyles.cabinStyle(
                        size: 16,
                        weight: FontWeight.w400,
                        color: const Color.fromARGB(255, 126, 126, 126)
                      ),
                    ),
                    Text(
                      detailValue.toString(),
                      style: GLTextStyles.cabinStyle(
                        size: 18,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ).where((widget) => widget is! SizedBox).toList(), 
      ),
    );
  }
}