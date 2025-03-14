import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_datepicker.dart';
import 'package:desaihomes_crm_application/global_widgets/detail_card.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/call_history_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/notes_section_copy.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/site_visit_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/status_button.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/textstyles.dart';
import '../../new_whatsapp_screen/controller/new_whatsapp_controller.dart';

class LeadDetailScreenCopy extends StatefulWidget {
  final int? leadId;

  const LeadDetailScreenCopy({super.key, this.leadId});

  @override
  LeadDetailScreenCopyState createState() => LeadDetailScreenCopyState();
}

class LeadDetailScreenCopyState extends State<LeadDetailScreenCopy>
    with SingleTickerProviderStateMixin {
  final TextEditingController noteController = TextEditingController();
  final TextEditingController siteVisitController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController followUpDateController = TextEditingController();
  bool remarkValidate = false;
  bool noteValidate = false;
  late TabController tabController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
      fetchNotes();
      fetchSiteVisits();
    });
  }

  @override
  void dispose() {
    noteController.dispose();
    siteVisitController.dispose();
    dateController.dispose();
    tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchDetailData(widget.leadId, context);

    final leadDetails =
        Provider.of<LeadDetailController>(context, listen: false)
            .leadDetailModel;

    if (leadDetails.lead?.followUpDate != null) {
      try {
        String? followUpDateString;

        // Check if the follow-up date is a DateTime or String
        if (leadDetails.lead?.followUpDate is DateTime) {
          followUpDateString =
              (leadDetails.lead?.followUpDate as DateTime).toIso8601String();
        } else if (leadDetails.lead?.followUpDate is String) {
          followUpDateString = leadDetails.lead?.followUpDate as String?;
        } else {
          followUpDateString = leadDetails.lead?.followUpDate?.toString();
        }

        if (followUpDateString != null && followUpDateString.isNotEmpty) {
          // Parse the string to DateTime
          selectedDate = DateTime.tryParse(followUpDateString);

          if (selectedDate != null) {
            followUpDateController.text =
                DateFormat('dd-MM-yyyy').format(selectedDate!);
          }
        }
      } catch (e) {
        print('Error parsing follow-up date: $e');
        selectedDate = null;
      }
    }
  }

  Future<void> fetchNotes() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchNotes(widget.leadId, context);
  }

  Future<void> fetchSiteVisits() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchSiteVisits(widget.leadId, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
             Provider.of<WhatsappControllerCopy>(context, listen: false)
        .fetchConversations(context);
          },
          icon: Icon(
            Iconsax.arrow_left,
            size: 20.sp,
          ),
        ),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: Icon(Iconsax.refresh, size: 20.sp),
            onPressed: fetchData,
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          onRefresh: () => fetchData(),
          child: Consumer<LeadDetailController>(
            builder: (context, controller, _) {
              return controller.isLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: ColorTheme.desaiGreen,
                          size: 32,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lead Details",
                                style: GLTextStyles.manropeStyle(
                                  size: 18.sp,
                                  weight: FontWeight.w600,
                                  color: const Color(0xff120e2b),
                                ),
                              ),
                              StatusButton(leadId: widget.leadId ?? 0)
                            ],
                          ),
                        ),
                        TabBar(
                          tabAlignment: TabAlignment.center,
                          controller: tabController,
                          isScrollable: true,
                          labelStyle: GLTextStyles.manropeStyle(
                              size: 14.sp, weight: FontWeight.w500),
                          unselectedLabelStyle: GLTextStyles.manropeStyle(
                              size: 14.sp, weight: FontWeight.w500),
                          labelColor: ColorTheme.lightBlue,
                          unselectedLabelColor: const Color(0xff909090),
                          indicatorColor: ColorTheme.lightBlue,
                          tabs: const [
                            Tab(text: "Overview"),
                            Tab(text: "Source"),
                            Tab(text: "Extra Data"),
                            Tab(text: "Site Visits"),
                            Tab(text: "Call Logs"),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              SingleChildScrollView(
                                child: Center(
                                    child: Column(
                                  children: [
                                    DetailCard(
                                      name:
                                          controller.leadDetailModel.lead?.name,
                                      email: controller
                                          .leadDetailModel.lead?.email,
                                      phone: controller
                                          .leadDetailModel.lead?.phoneNumber,
                                      age: controller
                                          .leadDetailModel.lead?.ageRange,
                                          leadId: controller.leadDetailModel.lead?.id,
                                      detailTexts: [
                                        DetailText(
                                          text: 'Project',
                                          value: controller.leadDetailModel.lead
                                                  ?.project?.name ??
                                              "",
                                        ),
                                        DetailText(
                                          text: 'Location',
                                          value: controller
                                                  .leadDetailModel.lead?.city ??
                                              "",
                                        ),
                                        DetailText(
                                          text: 'Profession',
                                          value: controller.leadDetailModel.lead
                                                  ?.profession ??
                                              "",
                                        ),
                                        DetailText(
                                          text: 'Lead Type',
                                          value: controller.leadDetailModel.lead
                                                  ?.leadType ??
                                              "",
                                        ),
                                        DetailText(
                                          text: 'Source',
                                          value: controller.leadDetailModel.lead
                                                  ?.source ??
                                              "",
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 18.w,
                                          right: 18.w,
                                          top: 5.h,
                                          bottom: 15.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Next Follow Up date",
                                            style: GLTextStyles.manropeStyle(
                                              size: 18.sp,
                                              weight: FontWeight.w600,
                                              color: const Color(0xff170e2b),
                                            ),
                                          ),
                                          SizedBox(height: 15.h),
                                          SizedBox(
                                            height:
                                                (35 / ScreenUtil().screenHeight)
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
                                                  Provider.of<LeadDetailController>(
                                                          context,
                                                          listen: false)
                                                      .updateFollowupdate(
                                                          widget.leadId,
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(date),
                                                          context);
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 300),
                                                      () {
                                                    Flushbar(
                                                      maxWidth: .55.sw,
                                                      backgroundColor:
                                                          Colors.grey.shade100,
                                                      messageColor:
                                                          ColorTheme.black,
                                                      icon: Icon(
                                                        Iconsax.calendar_tick,
                                                        color: ColorTheme.green,
                                                        size: 20.sp,
                                                      ),
                                                      message:
                                                          'Follow-up Date Updated',
                                                      duration: const Duration(
                                                          seconds: 3),
                                                      flushbarPosition:
                                                          FlushbarPosition.TOP,
                                                    ).show(context);
                                                  });
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    NotesSectionCopy(
                                        fetchNotes: fetchNotes,
                                        leadId: widget.leadId.toString(),
                                        noteValidate: noteValidate)
                                  ],
                                )),
                              ),
                              DetailCard(
                                detailTexts: [
                                  DetailText(
                                    text: 'Landing Page URL',
                                    value: controller.leadDetailModel.lead
                                            ?.landingPageUrl ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Source',
                                    value: controller
                                            .leadDetailModel.lead?.source ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Adset',
                                    value: controller
                                            .leadDetailModel.lead?.adset ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Ad Name',
                                    value: controller
                                            .leadDetailModel.lead?.adName ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Og Source URL',
                                    value: controller.leadDetailModel.lead
                                            ?.ogSourceUrl ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Utm Source ',
                                    value: controller
                                            .leadDetailModel.lead?.utmSource ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'User Agent',
                                    value: controller
                                            .leadDetailModel.lead?.userAgent ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Agent',
                                    value: controller
                                            .leadDetailModel.lead?.userAgent ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Referred by',
                                    value: controller
                                            .leadDetailModel.lead?.referredBy ??
                                        "",
                                  ),
                                ],
                              ),
                              DetailCard(
                                detailTexts: [
                                  DetailText(
                                    text: 'Source',
                                    value: controller
                                            .leadDetailModel.lead?.source ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Campaign Name',
                                    value: controller.leadDetailModel.lead
                                            ?.campaignName ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Message',
                                    value: controller
                                            .leadDetailModel.lead?.message ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'IP Address',
                                    value: controller
                                            .leadDetailModel.lead?.ipAddress ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Utm Source ',
                                    value: controller
                                            .leadDetailModel.lead?.utmSource ??
                                        "",
                                  ),
                                  DetailText(
                                    text: 'Campaign Type ID',
                                    value: jsonDecode(controller.leadDetailModel
                                                    .lead?.extraData ??
                                                '{}')['campaign_type_id']
                                            ?.toString() ??
                                        'N/A',
                                  ),
                                  DetailText(
                                    text: 'Source URL',
                                    value: controller
                                            .leadDetailModel.lead?.sourceUrl ??
                                        "",
                                  ),
                                ],
                              ),
                              SiteVisitSection(
                                  fetchSiteVisits: fetchSiteVisits,
                                  leadId: widget.leadId.toString(),
                                  remarkValidate: remarkValidate),
                              CallHistorySection(
                                leadId: widget.leadId.toString(),
                                phoneNumber: controller
                                        .leadDetailModel.lead?.phoneNumber ??
                                    "",
                                name:
                                    controller.leadDetailModel.lead?.name ?? "",
                              )
                            ],
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
