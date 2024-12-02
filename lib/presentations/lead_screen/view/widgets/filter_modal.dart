import 'dart:developer';

import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_datepicker.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
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
  List<String> selectedLeadSources = [];

  final MultiSelectController<String> leadSourceController =
      MultiSelectController<String>();

  void _clearFilters() {
    setState(() {
      fromDate = null;
      toDate = null;
      selectedProject = null;
      selectedLeadSources.clear();
      leadSourceController.clearAll();
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

    // Prepare lead source dropdown items
    final leadSourceItems = leadController.leadSourceModel.data
            ?.map((item) => item.source ?? '')
            .toList() ??
        [];

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
              MultiDropdown<String>(
                // searchDecoration: SearchFieldDecoration(
                //   border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(8),
                //     borderSide: const BorderSide(color: Color(0xffD5D7DA)),
                //   ),
                // ),
                items: leadSourceItems
                    .map((source) => DropdownItem<String>(
                          label: source,
                          value: source,
                        ))
                    .toList(),
                controller: leadSourceController,
                enabled: true,
                // searchEnabled: true,
                chipDecoration: const ChipDecoration(
                  backgroundColor: Color(0xffECEEFF),
                  deleteIcon: Icon(Iconsax.close_circle, size: 15),
                  wrap: true,
                  runSpacing: 2,
                  spacing: 10,
                ),
                fieldDecoration: FieldDecoration(
                  hintText: "",
                  suffixIcon: const Icon(Iconsax.arrow_down_1, size: 15),
                  showClearIcon: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffD5D7DA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                dropdownDecoration: const DropdownDecoration(
                  marginTop: 2,
                  maxHeight: 300,
                ),
                dropdownItemDecoration: const DropdownItemDecoration(
                  selectedIcon: Icon(Iconsax.tick_square, size: 18),
                ),
                onSelectionChange: (selectedItems) {
                  setState(() {
                    selectedLeadSources =
                        selectedItems.map((item) => item).toList();
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
                        log("Button Pressed -> projectId: $selectedProject, fromDate: $fromDate, toDate: $toDate, leadSources: $selectedLeadSources");

                        Provider.of<LeadController>(context, listen: false)
                            .fetchFilterData(
                          projectId: selectedProject,
                          fromDate: fromDate?.toIso8601String(),
                          toDate: toDate?.toIso8601String(),
                          leadSources: selectedLeadSources,
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
