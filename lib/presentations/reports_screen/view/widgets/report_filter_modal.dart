import 'package:another_flushbar/flushbar.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_datepicker.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/controller/reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

class ReportFilterModal extends StatefulWidget {
  const ReportFilterModal(
      {super.key, required this.clearFiltersCallback, this.onFilterApplied});
  final VoidCallback clearFiltersCallback;
  final VoidCallback? onFilterApplied;

  @override
  _ReportFilterModalState createState() => _ReportFilterModalState();
}

class _ReportFilterModalState extends State<ReportFilterModal> {
  DateTime? fromDate;
  DateTime? toDate;
  String? selectedCampaign;
  List<String> selectedLeadSources = [];

  final MultiSelectController<String> leadSourceController =
      MultiSelectController<String>();

  void _clearFilters() {
    setState(() {
      fromDate = null;
      toDate = null;
      selectedCampaign = null;
      selectedLeadSources.clear();
      leadSourceController.clearAll();
    });
    widget.clearFiltersCallback();
  }

  @override
  void initState() {
    Provider.of<LeadController>(context, listen: false)
        .fetchLeadSourceList(context);
    Provider.of<ReportsController>(context, listen: false)
        .fetchCampaignList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leadController = Provider.of<LeadController>(context, listen: false);
    final reportController =
        Provider.of<ReportsController>(context, listen: false);
    final leadSourceItems = leadController.leadSourceModel.data
            ?.map((item) => item.source ?? '')
            .toList() ??
        [];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: SingleChildScrollView(
        child: Container(
          width: (600 / ScreenUtil().screenWidth).sw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.all(15.w),
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
              SizedBox(height: 15.h),
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
                            size: 14.sp,
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
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
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To',
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.blue,
                            size: 14.sp,
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
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
              SizedBox(height: 20.h),
              Text(
                'Campaign',
                style: GLTextStyles.manropeStyle(
                  color: ColorTheme.blue,
                  size: 14.sp,
                  weight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedCampaign,
                icon: Icon(Iconsax.arrow_down_1, size: 15.sp),
                style: GLTextStyles.manropeStyle(
                  weight: FontWeight.w400,
                  size: 15.sp,
                  color: const Color.fromARGB(255, 87, 87, 87),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xffD5D7DA)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xffD5D7DA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                items: reportController.campaignListModel.data
                    ?.map((item) => DropdownMenuItem(
                          value: item.name,
                          child: Text(
                            item.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GLTextStyles.manropeStyle(
                              weight: FontWeight.w400,
                              size: 15.sp,
                              color: const Color.fromARGB(255, 87, 87, 87),
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCampaign = value;
                  });
                },
              ),
              SizedBox(height: 20.h),
              Text(
                'Lead source',
                style: GLTextStyles.manropeStyle(
                  color: ColorTheme.blue,
                  size: 14.sp,
                  weight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
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
                chipDecoration: ChipDecoration(
                  backgroundColor: const Color(0xffECEEFF),
                  deleteIcon: Icon(Iconsax.close_circle, size: 15.sp),
                  wrap: true,
                  runSpacing: 2,
                  spacing: 10,
                ),
                fieldDecoration: FieldDecoration(
                  hintText: "",
                  suffixIcon: Icon(Iconsax.arrow_down_1, size: 15.sp),
                  showClearIcon: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xffD5D7DA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                dropdownDecoration: DropdownDecoration(
                  marginTop: 2,
                  maxHeight: (300 / ScreenUtil().screenHeight).sh,
                ),
                dropdownItemDecoration: DropdownItemDecoration(
                  selectedIcon: Icon(Iconsax.tick_square, size: 18.sp),
                ),
                onSelectionChange: (selectedItems) {
                  setState(() {
                    selectedLeadSources =
                        selectedItems.map((item) => item).toList();
                  });
                },
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: const BorderSide(color: Color(0xffD5D7DA)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Clear',
                        style: GLTextStyles.manropeStyle(
                          color: ColorTheme.blue,
                          size: 15.sp,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (fromDate == null &&
                            toDate == null &&
                            selectedCampaign == null &&
                            selectedLeadSources.isEmpty) {
                          Flushbar(
                            maxWidth: .55.sw,
                            backgroundColor: Colors.grey.shade100,
                            messageColor: ColorTheme.black,
                            icon: Icon(
                              Iconsax.info_circle,
                              color: ColorTheme.red,
                              size: 20.sp,
                            ),
                            message: 'Filters cannot be empty',
                            duration: const Duration(seconds: 3),
                            flushbarPosition: FlushbarPosition.TOP,
                          ).show(context);
                        } else {
                          Provider.of<ReportsController>(context, listen: false)
                              .fetchFilterData(
                            campaignName: selectedCampaign,
                            fromDate: fromDate?.toIso8601String(),
                            toDate: toDate?.toIso8601String(),
                            leadSources: selectedLeadSources,
                            context: context,
                          );
                          Navigator.of(context).pop();
                          widget.onFilterApplied?.call();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        backgroundColor: const Color(0xFF3E9E7C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Apply',
                        style: GLTextStyles.manropeStyle(
                          color: ColorTheme.white,
                          size: 15.sp,
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
