import 'dart:async';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/global_widgets/detail_title.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/detail_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/notes_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/site_visit_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/source_section.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/widgets/status_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/textstyles.dart';

class LeadDetailScreenCopy extends StatefulWidget {
  final int? leadId;

  const LeadDetailScreenCopy({super.key, this.leadId});

  @override
  LeadDetailScreenCopyState createState() => LeadDetailScreenCopyState();
}

class LeadDetailScreenCopyState extends State<LeadDetailScreenCopy> {
  final TextEditingController noteController = TextEditingController();
  final TextEditingController siteVisitController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool remarkValidate = false;
  bool noteValidate = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
      fetchNotes();
      fetchSiteVisits();
    });

    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    siteVisitController.dispose();
    dateController.dispose();
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
          icon: const Icon(
            Iconsax.arrow_left,
            size: 20,
          ),
        ),
        forceMaterialTransparency: true,
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
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                backgroundColor: const Color(0xFFF5F5F5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    controller.leadDetailModel.lead
                                            ?.crmStatusDetails?.name ??
                                        "",
                                    style: GLTextStyles.manropeStyle(
                                      color: ColorTheme.black,
                                      size: 14.sp,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: Color(0xFFB5BEC6),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const DetailTitle(
                          text: "Basic Information",
                          textSize: 20,
                          textFontWeight: FontWeight.w400,
                          textColor: Color.fromARGB(255, 54, 80, 196),
                        ),
                        SiteVisitSection(
                          remarkValidate: remarkValidate,
                          fetchSiteVisits: fetchSiteVisits,
                          leadId: widget.leadId?.toString() ?? '',
                        ),
                        NotesSection(
                          noteValidate: noteValidate,
                          fetchNotes: fetchNotes,
                          leadId: widget.leadId?.toString() ?? '',
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
