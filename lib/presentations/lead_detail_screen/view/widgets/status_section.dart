import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';

class StatusSection extends StatelessWidget {
  final LeadDetailController controller;
  final List<String> details1;
  final String Function(LeadDetailController, int) getStatusValue;

  const StatusSection({
    super.key,
    required this.controller,
    required this.details1,
    required this.getStatusValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            details1.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(details1[index],
                          style: GLTextStyles.cabinStyle(size: 18)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Wrap(
                        children: [
                          Text(
                            ": ${getStatusValue(controller, index)}",
                            style: GLTextStyles.cabinStyle(
                                size: 18, weight: FontWeight.w500),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
