import 'dart:async';
import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_datepicker.dart';
import 'package:desaihomes_crm_application/global_widgets/dropdowm_textfield.dart';
import 'package:desaihomes_crm_application/global_widgets/form_textfield.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/new_whatsapp_screen/controller/new_whatsapp_controller.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/controller/reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

import '../../../../repository/api/whatsapp_screen/service/whatsapp_service.dart';

class CreateLeadModal extends StatefulWidget {
  const CreateLeadModal({
    super.key,
  });

  @override
  _CreateLeadModalState createState() => _CreateLeadModalState();
}

class _CreateLeadModalState extends State<CreateLeadModal>
    with SingleTickerProviderStateMixin {
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
  List<String> selectedLabels = [];
  List<int> selectedLabelId = [];
  String? selectedLeadType;
  String? selectedCampaign;
  String? selectedPerson;
  TextEditingController altNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController followUpDateController = TextEditingController();
  TextEditingController requestedDateController = TextEditingController();
  TextEditingController referredByController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool noteValidate = false;

  @override
  void initState() {
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
      Provider.of<LeadController>(context, listen: false)
          .fetchLeadTypeList(context);
      Provider.of<LeadController>(context, listen: false)
          .fetchLabelList(context);
      Provider.of<ReportsController>(context, listen: false)
          .fetchCampaignList(context);
      Provider.of<WhatsappControllerCopy>(context, listen: false)
          .validatePhoneNumber(
        phoneController.text,
        context,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leadController = Provider.of<LeadController>(context, listen: false);
    final statusController =
        Provider.of<LeadDetailController>(context, listen: false);
    bool phoneExists = false;
    Timer? _debounce;

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
                                              value: selectedLeadType,
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
                                              items: (leadController
                                                          .leadTypeModel
                                                          ?.crmLeadTypes ??
                                                      [])
                                                  .map((leadType) =>
                                                      DropdownMenuItem<String>(
                                                        value: leadType.id
                                                            .toString(),
                                                        child: Text(
                                                            leadType.name ??
                                                                ""),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedLeadType = value;
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
                                                  value: users.id.toString(),
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
                                              onChanged: (value) {
                                                if (_debounce?.isActive ??
                                                    false) _debounce!.cancel();
                                                _debounce = Timer(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  Provider.of<WhatsappControllerCopy>(
                                                          context,
                                                          listen: false)
                                                      .validatePhoneNumber(
                                                          value, context);
                                                });
                                              },
                                              errorText: phoneExists == true
                                                  ? 'This phone number already exists'
                                                  : null),
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
                                            child: MultiDropdown<int>(
                                              items: leadController
                                                      .labelModel.data
                                                      ?.map((label) =>
                                                          DropdownItem<int>(
                                                            label:
                                                                label.title ??
                                                                    "",
                                                            value:
                                                                label.id ?? 0,
                                                          ))
                                                      .toList() ??
                                                  [],
                                              enabled: true,
                                              chipDecoration: ChipDecoration(
                                                backgroundColor:
                                                    const Color(0xffECEEFF),
                                                deleteIcon: Icon(
                                                    Iconsax.close_circle,
                                                    size: 15.sp),
                                                wrap: false,
                                                runSpacing: 1,
                                                spacing: 5,
                                              ),
                                              fieldDecoration: FieldDecoration(
                                                hintText: "",
                                                suffixIcon: Icon(
                                                    Iconsax.arrow_down_1,
                                                    size: 15.sp),
                                                showClearIcon: true,
                                                border: OutlineInputBorder(
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
                                              dropdownDecoration:
                                                  DropdownDecoration(
                                                marginTop: 2,
                                                maxHeight: (300 /
                                                        ScreenUtil()
                                                            .screenHeight)
                                                    .sh,
                                              ),
                                              dropdownItemDecoration:
                                                  DropdownItemDecoration(
                                                selectedIcon: Icon(
                                                    Iconsax.tick_square,
                                                    size: 18.sp),
                                              ),
                                              onSelectionChange:
                                                  (selectedItems) {
                                                setState(() {
                                                  selectedLabelId =
                                                      (selectedItems ?? [])
                                                          .map((id) => id)
                                                          .toList();
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
                                            child: DropdownButtonFormField<
                                                    String>(
                                                dropdownColor: Colors.white,
                                                value: selectedStatus,
                                                icon: Icon(Iconsax.arrow_down_1,
                                                    size: 15.sp),
                                                style:
                                                    GLTextStyles.manropeStyle(
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
                                                items: statusController
                                                    .statusListModel.crmStatus
                                                    ?.map((status) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: status.slug,
                                                          child: Text(
                                                              status.name ??
                                                                  ""),
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
                                                                    status
                                                                        .slug ==
                                                                    value)
                                                            .id
                                                            .toString();
                                                  });
                                                }),
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
                                              isExpanded: true,
                                              dropdownColor: Colors.white,
                                              value: selectedLeadSource,
                                              icon: Icon(Iconsax.arrow_down_1,
                                                  size: 15.sp),
                                              style: GLTextStyles.manropeStyle(
                                                weight: FontWeight.w400,
                                                size: 13.sp,
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
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                  requestedDateController,
                                              onDateSelected: (DateTime date) {
                                                setState(() {
                                                  selectedDate = date;
                                                  requestedDateController.text =
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
                                                          ?.data ==
                                                      null ||
                                                  reportsController
                                                      .campaignListModel!
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
                                                    .campaignListModel!.data!
                                                    .map((campaign) =>
                                                        campaign.name ?? "")
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedCampaign = value;
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
                                            controller: referredByController,
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
                                  controller: descriptionController,
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
                                          onPressed: () async {
                                            if (phoneExists == true) {
                                              Flushbar(
                                                message:
                                                    "Phone number already exists",
                                                duration:
                                                    const Duration(seconds: 2),
                                                backgroundColor: Colors.red,
                                              ).show(context);
                                              return;
                                            }

                                            if (selectedLeadType == null ||
                                                selectedLeadType!.isEmpty ||
                                                selectedProjectId == null ||
                                                selectedProjectId!.isEmpty ||
                                                nameController.text.isEmpty ||
                                                selectedStatus == null ||
                                                selectedStatus!.isEmpty) {
                                              Flushbar(
                                                maxWidth: .8.sw,
                                                backgroundColor:
                                                    Colors.grey.shade100,
                                                messageColor: ColorTheme.black,
                                                icon: Icon(
                                                  Iconsax.info_circle,
                                                  color: ColorTheme.red,
                                                  size: 20.sp,
                                                ),
                                                message:
                                                    'Please fill all required fields (Lead Type, Project, Customer Name, Status)',
                                                duration:
                                                    const Duration(seconds: 5),
                                                flushbarPosition:
                                                    FlushbarPosition.BOTTOM,
                                              ).show(context);
                                              return;
                                            }

                                            try {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) => Center(
                                                  child: LoadingAnimationWidget
                                                      .fourRotatingDots(
                                                    color:
                                                        ColorTheme.desaiGreen,
                                                    size: 32,
                                                  ),
                                                ),
                                              );

                                              String ipAddresss =
                                                  await getIpAddress();
                                              String userAgentt =
                                                  await getUserAgent();
                                              String inputFormat = 'dd-MM-yyyy';

                                              if (requestedDateController
                                                  .text.isEmpty) {
                                                final now = DateTime.now();
                                                requestedDateController.text =
                                                    '${now.day}-${now.month}-${now.year}';
                                              }

                                              String followUpDate =
                                                  followUpDateController
                                                          .text.isNotEmpty
                                                      ? parseAndFormatDate(
                                                          followUpDateController
                                                              .text,
                                                          inputFormat)
                                                      : '';
                                              String requestedDate =
                                                  parseAndFormatDate(
                                                requestedDateController.text,
                                                inputFormat,
                                              );

                                              String ageRange =
                                                  selectedAge ?? '';
                                              int assignedTo = int.tryParse(
                                                      selectedPerson ?? '') ??
                                                  0;
                                              int assignedToUser = assignedTo;
                                              String campaignName =
                                                  selectedCampaign ?? '';
                                              int countryId = int.tryParse(
                                                      selectedCountryId ??
                                                          '') ??
                                                  0;
                                              int crmLeadTypeId = int.tryParse(
                                                      selectedLeadType ?? '') ??
                                                  0;
                                              String crmStatus =
                                                  selectedStatus ?? '';
                                              String email =
                                                  emailController.text;
                                              int id = 0;
                                              String ipAddress = ipAddresss;
                                              String userAgent = userAgentt;
                                              String name = nameController.text;
                                              String phoneNumber =
                                                  phoneController.text;
                                              String profession =
                                                  selectedProfession ?? '';
                                              int projectId = int.tryParse(
                                                      selectedProjectId ??
                                                          '') ??
                                                  0;
                                              String referredBy =
                                                  referredByController.text;
                                              String remarks =
                                                  descriptionController.text;
                                              String source =
                                                  selectedLeadSource ?? '';
                                              List<int> labelsId =
                                                  selectedLabelId;

                                              Provider.of<LeadController>(
                                                      context,
                                                      listen: false)
                                                  .createLead(
                                                ageRange: ageRange,
                                                assignedTo: assignedTo,
                                                assignedToUser: assignedToUser,
                                                campaignName: campaignName,
                                                countryId: countryId,
                                                crmLeadTypeId: crmLeadTypeId,
                                                crmStatus: crmStatus,
                                                email: email,
                                                followUpDate: followUpDate,
                                                id: id,
                                                ipAddress: ipAddress,
                                                labelsId: labelsId,
                                                name: name,
                                                phoneNumber: phoneNumber,
                                                profession: profession,
                                                projectId: projectId,
                                                referredBy: referredBy,
                                                remarks: remarks,
                                                requestedDate: requestedDate,
                                                source: source,
                                                userAgent: userAgent,
                                                context: context,
                                              );

                                              await Provider.of<LeadController>(
                                                      context,
                                                      listen: false)
                                                  .fetchData(context);

                                              Navigator.of(context).pop();

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Lead created successfully!'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );

                                              Navigator.of(context).pop();
                                            } catch (e) {
                                              Navigator.of(context).pop();

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Failed to create lead: ${e.toString()}'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
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

  String parseAndFormatDate(String dateText, String inputFormat) {
    if (dateText.isEmpty) return "";

    try {
      DateTime parsedDate = DateFormat(inputFormat).parse(dateText);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return "";
    }
  }
}

Future<String> getIpAddress() async {
  try {
    // Using a public API to get the IP address
    final response = await http.get(Uri.parse('https://api.ipify.org'));
    if (response.statusCode == 200) {
      return response.body;
    }

    // Alternative API if the first one fails
    final backupResponse = await http.get(Uri.parse('https://api64.ipify.org'));
    if (backupResponse.statusCode == 200) {
      return backupResponse.body;
    }

    return '';
  } catch (e) {
    debugPrint('Error getting IP address: $e');
    return '';
  }
}

Future<String> getUserAgent() async {
  if (Platform.isAndroid || Platform.isIOS) {
    return "Mobile App (Android/iOS)";
  } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    return "Desktop App (${Platform.operatingSystem})";
  } else {
    return "Unknown Platform";
  }
}
