import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/lead_detail_screen_copy.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/duplicate_lead_card.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/duplicate_lead_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class DuplicateLeadModal extends StatefulWidget {
  const DuplicateLeadModal({super.key, this.leadId});
  final String? leadId;

  @override
  _DuplicateLeadModalState createState() => _DuplicateLeadModalState();
}

class _DuplicateLeadModalState extends State<DuplicateLeadModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.leadId != null) {
        Provider.of<LeadController>(context, listen: false)
            .fetchDuplicatelead(widget.leadId, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final leadController = Provider.of<LeadController>(context);

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
                    'Duplicate Leads',
                    style: GLTextStyles.manropeStyle(
                      color: ColorTheme.blue,
                      size: 16.sp,
                      weight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.close, size: 20.sp),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              if (leadController.isduplicateFlagLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: ColorTheme.desaiGreen,
                      size: 28,
                    ),
                  ),
                )
              else if (leadController.duplicateFlag.isNotEmpty)
                Column(
                  children: leadController.duplicateFlag.map((lead) {
                    final fieldData = lead.field?.email ??
                        lead.field?.phoneNumber ??
                        "Unknown";
                    final createdDate = lead.ogLead is String
                        ? "Invalid Date"
                        : (lead.ogLead is OgLead &&
                                lead.ogLead?.createdAt is DateTime)
                            ? DateFormat('dd-MM-yyyy')
                                .format(lead.ogLead!.createdAt as DateTime)
                            : (lead.ogLead?.createdAt != null
                                ? DateFormat('dd-MM-yyyy').format(
                                    DateTime.parse(
                                        lead.ogLead!.createdAt.toString()))
                                : "");

                    return GestureDetector(
                      onTap: () {
                        if (lead.ogLead is! String &&
                            (lead.ogLead as OgLead?)?.id != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LeadDetailScreenCopy(
                                leadId: int.tryParse(
                                    (lead.ogLead as OgLead?)?.id.toString() ??
                                        ""),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Original lead is missing')),
                          );
                        }
                      },
                      child: DuplicateLeadCard(
                        duplicateEmail: fieldData,
                        originalProject: lead.ogLead is String
                            ? "Unknown Project"
                            : (lead.ogLead as OgLead?)?.project ??
                                "Unknown Project",
                        createdDate: createdDate,
                        assignedTo: lead.assignedTo ?? '',
                        leadId: lead.ogLead is String
                            ? ""
                            : (lead.ogLead as OgLead?)?.id?.toString() ?? "",
                      ),
                    );
                  }).toList(),
                )
              else
                Center(
                  child: Text(
                    'No duplicate leads found.',
                    style: GLTextStyles.manropeStyle(
                      color: ColorTheme.red,
                      size: 14.sp,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
