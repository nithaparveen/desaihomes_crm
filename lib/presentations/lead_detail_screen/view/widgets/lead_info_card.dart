import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';

class LeadInfoCard extends StatelessWidget {
  final LeadDetailController controller;

  const LeadInfoCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Lead Type",
                              style: GLTextStyles.cabinStyle(
                                  size: 13, weight: FontWeight.w400)),
                          Text(" : general",
                              style: GLTextStyles.cabinStyle(
                                  size: 14, weight: FontWeight.w500))
                        ],
                      ),
                      Row(
                        children: [
                          Text("Lead Source",
                              style: GLTextStyles.cabinStyle(
                                  size: 13, weight: FontWeight.w400)),
                          Text(" : Facebook",
                              style: GLTextStyles.cabinStyle(
                                  size: 14, weight: FontWeight.w500))
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.api,
                        size: 15,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "DD Queens Square",
                        style: GLTextStyles.robotoStyle(
                          size: 15,
                          weight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.person_rounded,
                        size: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "GopiKrishnan",
                        style: GLTextStyles.robotoStyle(
                          size: 16,
                          weight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
