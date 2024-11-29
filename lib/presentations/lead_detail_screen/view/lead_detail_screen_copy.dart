import 'dart:async';
import 'dart:convert';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/global_widgets/detail_card.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/notes_section_copy.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/site_visit_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/status_button.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/textstyles.dart';

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
  bool remarkValidate = false;
  bool noteValidate = false;
  late TabController _tabController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
      fetchNotes();
      fetchSiteVisits();
    });
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    siteVisitController.dispose();
    dateController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchDetailData(widget.leadId, context);
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
      body: RefreshIndicator(
        onRefresh: () => fetchData(),
        child: Consumer<LeadDetailController>(
          builder: (context, controller, _) {
            return controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.grey,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lead Details",
                              style: GLTextStyles.manropeStyle(
                                size: 18,
                                weight: FontWeight.w600,
                                color: const Color(0xff120e2b),
                              ),
                            ),
                            StatusButton(leadId: widget.leadId ?? 0)
                          ],
                        ),
                      ),
                      TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        controller: _tabController,
                        labelStyle: GLTextStyles.manropeStyle(
                            size: 14, weight: FontWeight.w500),
                        unselectedLabelStyle: GLTextStyles.manropeStyle(
                            size: 14, weight: FontWeight.w500),
                        labelColor: ColorTheme.lightBlue,
                        unselectedLabelColor: const Color(0xff909090),
                        indicatorColor: ColorTheme.lightBlue,
                        tabs: const [
                          Tab(text: "Overview"),
                          Tab(text: "Source"),
                          Tab(text: "Extra Data"),
                          Tab(text: "Site Visits"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              child: Center(
                                  child: Column(
                                children: [
                                  DetailCard(
                                    name: controller.leadDetailModel.lead?.name,
                                    email: controller.leadDetailModel.lead?.email,
                                    phone: controller
                                        .leadDetailModel.lead?.phoneNumber,
                                    age:
                                        controller.leadDetailModel.lead?.ageRange,
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
                                        value: controller
                                                .leadDetailModel.lead?.leadType ??
                                            "",
                                      ),
                                      DetailText(
                                        text: 'Source',
                                        value: controller
                                                .leadDetailModel.lead?.source ??
                                            "",
                                      ),
                                    ],
                                  ),
                                  NotesSectionCopy(
                                      fetchNotes: fetchNotes,
                                      leadId: widget.leadId.toString(),
                                      noteValidate: noteValidate)
                                ],
                              )),
                            ),
                            Center(
                                child: DetailCard(
                              detailTexts: [
                                DetailText(
                                  text: 'Landing Page URL',
                                  value: controller.leadDetailModel.lead
                                          ?.landingPageUrl ??
                                      "",
                                ),
                                DetailText(
                                  text: 'Source',
                                  value:
                                      controller.leadDetailModel.lead?.source ??
                                          "",
                                ),
                                DetailText(
                                  text: 'Adset',
                                  value:
                                      controller.leadDetailModel.lead?.adset ??
                                          "",
                                ),
                                DetailText(
                                  text: 'Ad Name',
                                  value:
                                      controller.leadDetailModel.lead?.adName ??
                                          "",
                                ),
                                DetailText(
                                  text: 'Og Source URL',
                                  value: controller
                                          .leadDetailModel.lead?.ogSourceUrl ??
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
                            )),
                            Center(
                                child: DetailCard(
                              detailTexts: [
                                DetailText(
                                  text: 'Source',
                                  value:
                                      controller.leadDetailModel.lead?.source ??
                                          "",
                                ),
                                DetailText(
                                  text: 'Campaign Name',
                                  value: controller
                                          .leadDetailModel.lead?.campaignName ??
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
                            )),
                            SiteVisitSection(
                                fetchSiteVisits: fetchSiteVisits,
                                leadId: widget.leadId.toString(),
                                remarkValidate: remarkValidate)
                          ],
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
