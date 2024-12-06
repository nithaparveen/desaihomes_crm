import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_datepicker.dart';
import 'package:desaihomes_crm_application/global_widgets/dropdowm_textfield.dart';
import 'package:desaihomes_crm_application/global_widgets/form_textfield.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/notes_section_copy.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QuickEditModal extends StatefulWidget {
  const QuickEditModal(
      {super.key,
      required this.email,
      required this.phoneNumber,
      required this.leadId});

  final String email;
  final String phoneNumber;
  final int leadId;

  @override
  _QuickEditModalState createState() => _QuickEditModalState();
}

class _QuickEditModalState extends State<QuickEditModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  DateTime? selectedDate;
  String? selectedStatus;
  String? selectedStatusId;
  String? selectedProject;
  String? selectedProjectId;
  String? selectedProfession;
  String? selectedCountry;
  String? selectedCountryId;
  String? selectedAge;
  TextEditingController altNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool noteValidate = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LeadController>(context, listen: false)
          .fetchLeadSourceList(context);
      Provider.of<LeadController>(context, listen: false)
          .fetchProjectList(context);
      Provider.of<LeadDetailController>(context, listen: false)
          .fetchStatusList(context);
      Provider.of<LeadController>(context, listen: false)
          .fetchProfessionsList(context);
      Provider.of<LeadController>(context, listen: false)
          .fetchCountries(context);
      Provider.of<LeadController>(context, listen: false).fetchAgeList(context);
      fetchNotes();
    });
    super.initState();
  }

  Future<void> fetchNotes() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchNotes(widget.leadId, context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void clearFilters() {
    setState(() {
      selectedDate = null;
      selectedStatus = null;
      selectedStatusId = null;
      selectedProject = null;
      selectedProjectId = null;
      selectedProfession = null;
      selectedCountry = null;
      selectedCountryId = null;
      selectedAge = null;
      altNumberController.clear();
      cityController.clear();
      ageController.clear();

      noteValidate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final leadController = Provider.of<LeadController>(context, listen: false);
    final statusController =
        Provider.of<LeadDetailController>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10),
      child: SingleChildScrollView(
        child: Container(
          height: (580 / ScreenUtil().screenHeight).sh,
          width: (600 / ScreenUtil().screenWidth).sw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 10.h),
                child: Row(
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
              ),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                labelStyle: GLTextStyles.manropeStyle(
                    size: 14.sp, weight: FontWeight.w500),
                unselectedLabelStyle: GLTextStyles.manropeStyle(
                    size: 14.sp, weight: FontWeight.w500),
                labelColor: ColorTheme.lightBlue,
                unselectedLabelColor: const Color(0xff909090),
                indicatorColor: ColorTheme.lightBlue,
                tabs: const [
                  Tab(text: 'Quick Edit'),
                  Tab(text: 'Notes'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 18.w, right: 18.w, top: 10.h, bottom: 20.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: GLTextStyles.manropeStyle(
                                color: ColorTheme.blue,
                                size: 14.sp,
                                weight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            SizedBox(
                              height: (35 / ScreenUtil().screenHeight).sh,
                              width: double.infinity,
                              child: TextField(
                                readOnly: true,
                                controller:
                                    TextEditingController(text: widget.email),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: const Color(0xff8C8E90),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffF4F4F4),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              'Phone number',
                              style: GLTextStyles.manropeStyle(
                                color: ColorTheme.blue,
                                size: 14.sp,
                                weight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            SizedBox(
                              height: (35 / ScreenUtil().screenHeight).sh,
                              width: double.infinity,
                              child: TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: widget.phoneNumber),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: const Color(0xff8C8E90),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffF4F4F4),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.w),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Alternative number',
                                        style: GLTextStyles.manropeStyle(
                                          color: ColorTheme.blue,
                                          size: 14.sp,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      FormTextField(
                                        controller: altNumberController,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status',
                                        style: GLTextStyles.manropeStyle(
                                          color: ColorTheme.blue,
                                          size: 14.sp,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      DropdownFormTextField(
                                        initialValue: selectedStatus,
                                        items: statusController
                                                .statusListModel.crmStatus
                                                ?.map((status) =>
                                                    status.name ??
                                                    "Unnamed Status")
                                                .toList() ??
                                            [],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedStatus = value;
                                            selectedStatusId = statusController
                                                .statusListModel.crmStatus
                                                ?.firstWhere((status) =>
                                                    status.name == value)
                                                .id
                                                .toString();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Preferred project',
                                        style: GLTextStyles.manropeStyle(
                                          color: ColorTheme.blue,
                                          size: 14.sp,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      DropdownFormTextField(
                                        initialValue: selectedProject,
                                        items: leadController
                                                .projectListModel.projects
                                                ?.map((project) =>
                                                    project.name ?? "")
                                                .toList() ??
                                            [],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedProject = value;
                                            selectedProjectId = leadController
                                                .projectListModel.projects
                                                ?.firstWhere((project) =>
                                                    project.name == value)
                                                .id
                                                .toString();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Profession',
                                        style: GLTextStyles.manropeStyle(
                                          color: ColorTheme.blue,
                                          size: 14.sp,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Consumer<LeadController>(
                                        builder:
                                            (context, leadController, child) {
                                          if (leadController
                                              .professionList.isEmpty) {
                                            return const DropdownFormTextField(
                                              items: ['Loading...'],
                                              onChanged: null,
                                            );
                                          }

                                          return DropdownFormTextField(
                                            initialValue: selectedProfession,
                                            items: leadController.professionList
                                                .map((profession) =>
                                                    profession.name ?? "")
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedProfession = value;
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Country',
                                        style: GLTextStyles.manropeStyle(
                                          color: ColorTheme.blue,
                                          size: 14.sp,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Consumer<LeadController>(
                                        builder:
                                            (context, leadController, child) {
                                          if (leadController
                                              .countriesList.isEmpty) {
                                            return const DropdownFormTextField(
                                              items: ['Loading...'],
                                              onChanged: null,
                                            );
                                          }

                                          return DropdownFormTextField(
                                            initialValue: selectedCountry,
                                            items: leadController.countriesList
                                                .map((country) =>
                                                    country.name ?? "")
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedCountry = value;
                                                selectedCountryId =
                                                    leadController.countriesList
                                                        .firstWhere(
                                                            (country) =>
                                                                country.name ==
                                                                value)
                                                        .id
                                                        .toString();
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'City',
                                        style: GLTextStyles.manropeStyle(
                                          color: ColorTheme.blue,
                                          size: 14.sp,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      FormTextField(
                                        controller: cityController,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Age',
                                        style: GLTextStyles.manropeStyle(
                                          color: ColorTheme.blue,
                                          size: 14.sp,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Consumer<LeadController>(
                                        builder:
                                            (context, leadController, child) {
                                          if (leadController.ageList.isEmpty) {
                                            return const DropdownFormTextField(
                                              items: ['Loading...'],
                                              onChanged: null,
                                            );
                                          }

                                          return DropdownFormTextField(
                                            initialValue: selectedAge,
                                            items: leadController.ageList
                                                .map((age) => age.name ?? "")
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedAge = value;
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Next followup date',
                                        style: GLTextStyles.manropeStyle(
                                          color: ColorTheme.blue,
                                          size: 14.sp,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      SizedBox(
                                        height:
                                            (35 / ScreenUtil().screenHeight).sh,
                                        width: double.infinity,
                                        child: CustomDatePicker(
                                          onDateSelected: (DateTime date) {
                                            setState(() {
                                              selectedDate = date;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: (45 / ScreenUtil().screenHeight).sh,
                                    child: OutlinedButton(
                                      onPressed: clearFilters,
                                      style: OutlinedButton.styleFrom(
                                        // padding:
                                        //     EdgeInsets.symmetric(vertical: 12.h),
                                        side: BorderSide(
                                            color: ColorTheme.red, width: 0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                      ),
                                      child: Text(
                                        'Clear',
                                        style: GLTextStyles.manropeStyle(
                                          color: ColorTheme.red,
                                          size: 15.sp,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: (45 / ScreenUtil().screenHeight).sh,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        int? countryId = selectedCountryId !=
                                                null
                                            ? int.tryParse(
                                                selectedCountryId.toString())
                                            : null;
                                        int? statusId = selectedStatusId != null
                                            ? int.tryParse(
                                                selectedStatusId.toString())
                                            : null;
                                        int? projectId = selectedProjectId !=
                                                null
                                            ? int.tryParse(
                                                selectedProjectId.toString())
                                            : null;

                                        Provider.of<LeadController>(context,
                                                listen: false)
                                            .quickEdit(
                                          widget.leadId,
                                          altNumberController.text,
                                          cityController.text,
                                          selectedDate.toString(),
                                          selectedAge,
                                          countryId,
                                          statusId,
                                          projectId,
                                          context,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        // padding:
                                        //     EdgeInsets.symmetric(vertical: 12.h),
                                        backgroundColor:
                                            const Color(0xFF3E9E7C),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                      ),
                                      child: Text(
                                        'Submit',
                                        style: GLTextStyles.manropeStyle(
                                          color: ColorTheme.white,
                                          size: 15.sp,
                                          weight: FontWeight.w600,
                                        ),
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
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: NotesSectionCopy(
                          fetchNotes: fetchNotes,
                          leadId: widget.leadId.toString(),
                          noteValidate: noteValidate),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
