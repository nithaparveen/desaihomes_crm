import 'dart:developer';

import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_datepicker.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
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
                    'Filter',
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomDatePicker(
                          onDateSelected: (DateTime date) {
                            setState(() {
                              fromDate = date;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomDatePicker(
                          onDateSelected: (DateTime date) {
                            setState(() {
                              toDate = date;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Project',
                style: GLTextStyles.manropeStyle(
                  color: ColorTheme.blue,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedProject,
                icon: const Icon(Iconsax.arrow_down_1, size: 15),
                style: GLTextStyles.manropeStyle(
                  weight: FontWeight.w400,
                  size: 15,
                  color: const Color.fromARGB(255, 87, 87, 87),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                items: leadController.projectListModel.projects
                    ?.map((item) => DropdownMenuItem(
                          value: item.id.toString(),
                          child: Text(
                            item.name ?? '',
                            style: GLTextStyles.manropeStyle(
                              weight: FontWeight.w400,
                              size: 15,
                              color: const Color.fromARGB(255, 87, 87, 87),
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProject = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Lead source',
                style: GLTextStyles.manropeStyle(
                  color: ColorTheme.blue,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedLeadSource,
                icon: const Icon(Iconsax.arrow_down_1, size: 15),
                style: GLTextStyles.manropeStyle(
                  weight: FontWeight.w400,
                  size: 15,
                  color: const Color.fromARGB(255, 87, 87, 87),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    borderSide: const BorderSide(color: Color(0xffD5D7DA)),
                  ),
                ),
                items: leadController.leadSourceModel.data
                    ?.map((item) => DropdownMenuItem(
                          value: item.source,
                          child: Text(
                            item.source ?? '',
                            style: GLTextStyles.manropeStyle(
                              weight: FontWeight.w400,
                              size: 15,
                              color: const Color.fromARGB(255, 87, 87, 87),
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLeadSource = value;
                  });
                },
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xffD5D7DA)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Clear',
                        style: GLTextStyles.manropeStyle(
                          color: ColorTheme.blue,
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
                        'Apply',
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
