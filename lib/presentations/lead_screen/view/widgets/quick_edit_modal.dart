import 'dart:developer';

import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_datepicker.dart';
import 'package:desaihomes_crm_application/global_widgets/form_textfield.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class QuickEditModal extends StatefulWidget {
  const QuickEditModal({super.key});

  @override
  _QuickEditModalState createState() => _QuickEditModalState();
}

class _QuickEditModalState extends State<QuickEditModal> {
  DateTime? fromDate;
  DateTime? toDate;
  String? selectedProject;
  String? selectedLeadSource;

  void _clearFilters() {
    setState(() {
      fromDate = null;
      toDate = null;
      selectedProject = null;
      selectedLeadSource = null;
    });
  }

  @override
  void initState() {
    Provider.of<LeadController>(context, listen: false)
        .fetchLeadSourceList(context);
    Provider.of<LeadController>(context, listen: false)
        .fetchProjectList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leadController = Provider.of<LeadController>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: SingleChildScrollView(
        child: Container(
          width: 600.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick edit',
                    style: GLTextStyles.manropeStyle(
                      color: ColorTheme.blue,
                      size: 20.sp,
                      weight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // TextField(
              //   readOnly: true,
              //   style: const TextStyle(
              //     fontWeight: FontWeight.w400,
              //     fontSize: 14,
              //     color: Color(0xff8C8E90),
              //   ),
              //   decoration: InputDecoration(
              //     filled: true,
              //     fillColor: Color(0xffF4F4F4),
              //     contentPadding:
              //         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: const BorderSide(color: Color(0xffD5D7DA)),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: const BorderSide(color: Color(0xffD5D7DA)),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: const BorderSide(color: Colors.grey),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alternative Number',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const FormTextField(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const FormTextField(
                          suffixIcon: Iconsax.arrow_down_1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Preferred Project',
                style: GLTextStyles.manropeStyle(
                  color: ColorTheme.blue,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const FormTextField(
                suffixIcon: Iconsax.arrow_down_1,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Country',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const FormTextField(
                          suffixIcon: Iconsax.arrow_down_1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'City',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const FormTextField(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const FormTextField(
                          suffixIcon: Iconsax.arrow_down_1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profession',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const FormTextField(
                          suffixIcon: Iconsax.arrow_down_1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Age',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const FormTextField(
                          suffixIcon: Iconsax.arrow_down_1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next Followup date',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 35,
                          width: double.infinity,
                          child: CustomDatePicker(
                            onDateSelected: (DateTime date) {
                              setState(() {
                                toDate = date;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: ColorTheme.red, width: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: GLTextStyles.manropeStyle(
                          color: ColorTheme.red,
                          size: 15,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        log("Button Pressed -> projectId: $selectedProject, fromDate: $fromDate, toDate: $toDate");

                        Provider.of<LeadController>(context, listen: false)
                            .fetchFilterData(
                          projectId: selectedProject,
                          fromDate: fromDate?.toIso8601String(),
                          toDate: toDate?.toIso8601String(),
                          context: context,
                        );

                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: const Color(0xFF3E9E7C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: GLTextStyles.manropeStyle(
                          color: ColorTheme.white,
                          size: 15,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
