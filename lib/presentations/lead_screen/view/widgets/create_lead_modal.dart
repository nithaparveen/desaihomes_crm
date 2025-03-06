import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_datepicker.dart';
import 'package:desaihomes_crm_application/global_widgets/dropdowm_textfield.dart';
import 'package:desaihomes_crm_application/global_widgets/form_textfield.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/notes_section_copy.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/controller/reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class CreateLeadModal extends StatefulWidget {
  const CreateLeadModal({
    super.key,
  });

  @override
  _CreateLeadModalState createState() => _CreateLeadModalState();
}

class _CreateLeadModalState extends State<CreateLeadModal>
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
  String? selectedLeadSource;
  String? selectedCampaign;
  String? selectedPerson;
  TextEditingController altNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController followUpDateController = TextEditingController();
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
      Provider.of<ReportsController>(context, listen: false)
          .fetchCampaignList(context);
    });
    super.initState();
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
      insetPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20),
      child: SingleChildScrollView(
        child: Container(
          height: (680 / ScreenUtil().screenHeight).sh,
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
                      'Create Lead',
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
              Expanded(
                child: Consumer<LeadDetailController>(
                    builder: (context, leadDetailController, child) {
                  return leadDetailController.isLoading
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: LoadingAnimationWidget.fourRotatingDots(
                              color: ColorTheme.desaiGreen,
                              size: 28,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 18.w,
                                right: 18.w,
                                top: 10.h,
                                bottom: 20.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Lead Type',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 14.sp,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          SizedBox(
                                            height: 38.sp,
                                            child:
                                                DropdownButtonFormField<String>(
                                              dropdownColor: Colors.white,
                                              value: selectedAge,
                                              icon: Icon(Iconsax.arrow_down_1,
                                                  size: 15.sp),
                                              style: GLTextStyles.manropeStyle(
                                                weight: FontWeight.w400,
                                                size: 14.sp,
                                                color: const Color.fromARGB(
                                                    255, 87, 87, 87),
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12.w,
                                                        vertical: 8.h),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD5D7DA)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD5D7DA)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: BorderSide(
                                                      color: ColorTheme
                                                          .desaiGreen),
                                                ),
                                              ),
                                              items: statusController
                                                  .statusListModel.crmStatus
                                                  ?.map((status) =>
                                                      DropdownMenuItem<String>(
                                                        value: status.name,
                                                        child: Text(
                                                            status.name ?? ""),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedStatus = value;
                                                  selectedStatusId =
                                                      statusController
                                                          .statusListModel
                                                          .crmStatus
                                                          ?.firstWhere(
                                                              (status) =>
                                                                  status.name ==
                                                                  value)
                                                          .id
                                                          .toString();
                                                });
                                              },
                                            ),
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
                                            'Project',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 14.sp,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          SearchableDropdownFormTextField(
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
                                                selectedProjectId =
                                                    leadController
                                                        .projectListModel
                                                        .projects
                                                        ?.firstWhere(
                                                            (project) =>
                                                                project.name ==
                                                                value)
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Assign To',
                                      style: GLTextStyles.manropeStyle(
                                        color: ColorTheme.blue,
                                        size: 14.sp,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    SizedBox(
                                      height: 38.sp,
                                      child: DropdownButtonFormField<String>(
                                        dropdownColor: Colors.white,
                                        value: selectedPerson,
                                        icon: Icon(Iconsax.arrow_down_1,
                                            size: 15.sp),
                                        style: GLTextStyles.manropeStyle(
                                          weight: FontWeight.w400,
                                          size: 14.sp,
                                          color: const Color.fromARGB(
                                              255, 87, 87, 87),
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12.w, vertical: 8.h),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: const BorderSide(
                                                color: Color(0xffD5D7DA)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: const BorderSide(
                                                color: Color(0xffD5D7DA)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: BorderSide(
                                                color: ColorTheme.desaiGreen),
                                          ),
                                        ),
                                        items: leadController
                                            .userListModel.users
                                            ?.map((users) =>
                                                DropdownMenuItem<String>(
                                                  value: users.name,
                                                  child: Text(users.name ?? ""),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedPerson = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Customer Name',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 14.sp,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          FormTextField(
                                            controller: nameController,
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
                                            'Phone Number',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 14.sp,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          FormTextField(
                                            controller: phoneController,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          FormTextField(
                                            controller: emailController,
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
                                            'Age',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 14.sp,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Consumer<LeadController>(
                                            builder: (context, leadController,
                                                child) {
                                              // if (leadController
                                              //     .ageList.isEmpty) {
                                              //   return const SearchableDropdownFormTextField(
                                              //     items: ['Loading...'],
                                              //     onChanged: null,
                                              //   );
                                              // }

                                              return
                                                  // SearchableDropdownFormTextField(
                                                  //   initialValue: selectedAge,
                                                  //   items: leadController
                                                  //       .ageList
                                                  //       .map((age) =>
                                                  //           age.name ?? "")
                                                  //       .toList(),
                                                  //   onChanged: (value) {
                                                  //     setState(() {
                                                  //       selectedAge = value;
                                                  //     });
                                                  //   },
                                                  // );
                                                  SizedBox(
                                                height: 38.sp,
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  dropdownColor: Colors.white,
                                                  value: selectedAge,
                                                  icon: Icon(
                                                      Iconsax.arrow_down_1,
                                                      size: 15.sp),
                                                  style:
                                                      GLTextStyles.manropeStyle(
                                                    weight: FontWeight.w400,
                                                    size: 15.sp,
                                                    color: const Color.fromARGB(
                                                        255, 87, 87, 87),
                                                  ),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 8.h),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color(
                                                                  0xffD5D7DA)),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color(
                                                                  0xffD5D7DA)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                      borderSide: BorderSide(
                                                          color: ColorTheme
                                                              .desaiGreen),
                                                    ),
                                                  ),
                                                  items: leadController.ageList
                                                      .map((age) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: age.name,
                                                            child: Text(
                                                                age.name ?? ""),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedAge = value;
                                                    });
                                                  },
                                                ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Professions',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 14.sp,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          SizedBox(
                                            height: 38.sp,
                                            child:
                                                DropdownButtonFormField<String>(
                                              dropdownColor: Colors.white,
                                              value: selectedProfession,
                                              icon: Icon(Iconsax.arrow_down_1,
                                                  size: 15.sp),
                                              style: GLTextStyles.manropeStyle(
                                                weight: FontWeight.w400,
                                                size: 14.sp,
                                                color: const Color.fromARGB(
                                                    255, 87, 87, 87),
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12.w,
                                                        vertical: 8.h),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD5D7DA)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD5D7DA)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: BorderSide(
                                                      color: ColorTheme
                                                          .desaiGreen),
                                                ),
                                              ),
                                              items: leadController
                                                  .professionList
                                                  .map((profession) =>
                                                      DropdownMenuItem<String>(
                                                        value: profession.name,
                                                        child: Text(
                                                            profession.name ??
                                                                ""),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedProfession = value;
                                                });
                                              },
                                            ),
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
                                            'Labels',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 14.sp,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          SizedBox(
                                            height: 38.sp,
                                            child:
                                                DropdownButtonFormField<String>(
                                              dropdownColor: Colors.white,
                                              value: selectedAge,
                                              icon: Icon(Iconsax.arrow_down_1,
                                                  size: 15.sp),
                                              style: GLTextStyles.manropeStyle(
                                                weight: FontWeight.w400,
                                                size: 14.sp,
                                                color: const Color.fromARGB(
                                                    255, 87, 87, 87),
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12.w,
                                                        vertical: 8.h),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD5D7DA)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD5D7DA)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: BorderSide(
                                                      color: ColorTheme
                                                          .desaiGreen),
                                                ),
                                              ),
                                              items: statusController
                                                  .statusListModel.crmStatus
                                                  ?.map((status) =>
                                                      DropdownMenuItem<String>(
                                                        value: status.name,
                                                        child: Text(
                                                            status.name ?? ""),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedStatus = value;
                                                  selectedStatusId =
                                                      statusController
                                                          .statusListModel
                                                          .crmStatus
                                                          ?.firstWhere(
                                                              (status) =>
                                                                  status.name ==
                                                                  value)
                                                          .id
                                                          .toString();
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            builder: (context, leadController,
                                                child) {
                                              if (leadController
                                                  .countriesList.isEmpty) {
                                                return const SearchableDropdownFormTextField(
                                                  items: ['Loading...'],
                                                  onChanged: null,
                                                );
                                              }
                                              return SearchableDropdownFormTextField(
                                                initialValue: selectedCountry,
                                                items: leadController
                                                    .countriesList
                                                    .map((country) =>
                                                        country.name ?? "")
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedCountry = value;
                                                    selectedCountryId =
                                                        leadController
                                                            .countriesList
                                                            .firstWhere(
                                                                (country) =>
                                                                    country
                                                                        .name ==
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
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
                                          SizedBox(
                                            height: 38.sp,
                                            child:
                                                DropdownButtonFormField<String>(
                                              dropdownColor: Colors.white,
                                              value: selectedStatus,
                                              icon: Icon(Iconsax.arrow_down_1,
                                                  size: 15.sp),
                                              style: GLTextStyles.manropeStyle(
                                                weight: FontWeight.w400,
                                                size: 14.sp,
                                                color: const Color.fromARGB(
                                                    255, 87, 87, 87),
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12.w,
                                                        vertical: 8.h),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD5D7DA)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD5D7DA)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: BorderSide(
                                                      color: ColorTheme
                                                          .desaiGreen),
                                                ),
                                              ),
                                              items: statusController
                                                  .statusListModel.crmStatus
                                                  ?.map((status) =>
                                                      DropdownMenuItem<String>(
                                                        value: status.name,
                                                        child: Text(
                                                            status.name ?? ""),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedStatus = value;
                                                  selectedStatusId =
                                                      statusController
                                                          .statusListModel
                                                          .crmStatus
                                                          ?.firstWhere(
                                                              (status) =>
                                                                  status.name ==
                                                                  value)
                                                          .id
                                                          .toString();
                                                });
                                              },
                                            ),
                                          ),
                                          // SearchableDropdownFormTextField(
                                          //   initialValue: selectedStatus,
                                          //   items: statusController
                                          //           .statusListModel
                                          //           .crmStatus
                                          //           ?.map((status) =>
                                          //               status.name ??
                                          //               "Unnamed Status")
                                          //           .toList() ??
                                          //       [],
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       selectedStatus = value;
                                          //       selectedStatusId =
                                          //           statusController
                                          //               .statusListModel
                                          //               .crmStatus
                                          //               ?.firstWhere(
                                          //                   (status) =>
                                          //                       status
                                          //                           .name ==
                                          //                       value)
                                          //               .id
                                          //               .toString();
                                          //     });
                                          //   },
                                          // ),
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
                                            'Lead Source',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 14.sp,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          SizedBox(
                                            height: 38.sp,
                                            child:
                                                DropdownButtonFormField<String>(
                                              dropdownColor: Colors.white,
                                              value: selectedLeadSource,
                                              icon: Icon(Iconsax.arrow_down_1,
                                                  size: 15.sp),
                                              style: GLTextStyles.manropeStyle(
                                                weight: FontWeight.w400,
                                                size: 9.sp,
                                                color: const Color.fromARGB(
                                                    255, 87, 87, 87),
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12.w,
                                                        vertical: 8.h),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD5D7DA)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffD5D7DA)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  borderSide: BorderSide(
                                                      color: ColorTheme
                                                          .desaiGreen),
                                                ),
                                              ),
                                              items: leadController
                                                  .leadSourceModel.data
                                                  ?.map((leadsource) =>
                                                      DropdownMenuItem<String>(
                                                        value:
                                                            leadsource.source,
                                                        child: Text(
                                                            leadsource.source ??
                                                                ""),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedLeadSource = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Requested date',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 14.sp,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          SizedBox(
                                            height:
                                                (38 / ScreenUtil().screenHeight)
                                                    .sh,
                                            width: double.infinity,
                                            child: CustomDatePicker(
                                              controller:
                                                  followUpDateController,
                                              onDateSelected: (DateTime date) {
                                                setState(() {
                                                  selectedDate = date;
                                                  followUpDateController.text =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(date);
                                                });
                                              },
                                            ),
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
                                                (38 / ScreenUtil().screenHeight)
                                                    .sh,
                                            width: double.infinity,
                                            child: CustomDatePicker(
                                              controller:
                                                  followUpDateController,
                                              onDateSelected: (DateTime date) {
                                                setState(() {
                                                  selectedDate = date;
                                                  followUpDateController.text =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(date);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Campaign Name',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 14.sp,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Consumer<ReportsController>(
                                            builder: (context,
                                                reportsController, child) {
                                              if (reportsController
                                                  .campaignListModel
                                                  .data!
                                                  .isEmpty) {
                                                return const SearchableDropdownFormTextField(
                                                  items: ['Loading...'],
                                                  onChanged: null,
                                                );
                                              }
                                              return SearchableDropdownFormTextField(
                                                initialValue: selectedCampaign,
                                                items: reportsController
                                                    .campaignListModel.data!
                                                    .map((campaign) =>
                                                        campaign.name ?? "")
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedCampaign = value;
                                                    // selectedCountryId =
                                                    //     reportsController
                                                    //         .campaignListModel
                                                    //         .firstWhere(
                                                    //             (country) =>
                                                    //                 country
                                                    //                     .name ==
                                                    //                 value)
                                                    //         .id
                                                    //         .toString();
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
                                            'Referred By',
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
                                Text(
                                  'Description',
                                  style: GLTextStyles.manropeStyle(
                                    color: ColorTheme.blue,
                                    size: 14.sp,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                FormTextField(
                                  maxLines: 3,
                                  controller: phoneController,
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: double.infinity,
                                        height:
                                            (45 / ScreenUtil().screenHeight).sh,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            String? formattedDate;
                                            if (selectedDate != null) {
                                              formattedDate =
                                                  "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
                                            }
                                            int? countryId =
                                                selectedCountryId != null
                                                    ? int.tryParse(
                                                        selectedCountryId
                                                            .toString())
                                                    : null;
                                            int? statusId = selectedStatusId !=
                                                    null
                                                ? int.tryParse(
                                                    selectedStatusId.toString())
                                                : null;
                                            int? projectId =
                                                selectedProjectId != null
                                                    ? int.tryParse(
                                                        selectedProjectId
                                                            .toString())
                                                    : null;

                                            // Provider.of<LeadController>(
                                            //         context,
                                            //         listen: false)
                                            //     .quickEdit(
                                            //   widget.leadId,
                                            //   altNumberController.text,
                                            //   cityController.text,
                                            //   formattedDate,
                                            //   selectedAge,
                                            //   countryId,
                                            //   statusId,
                                            //   projectId,
                                            //   context,
                                            // );
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
                        );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
