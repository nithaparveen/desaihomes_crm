import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/dummy_status_list.dart';
import 'package:desaihomes_crm_application/repository/api/lead_detail_screen/model/lead_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../controller/lead_detail_controller.dart';

class StatusButton extends StatefulWidget {
  const StatusButton({super.key, required this.leadId});
  final int leadId;

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchStatusList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadDetailController>(
      builder: (context, controller, _) {
        // Retrieve the currently selected status details
        final currentStatus = controller.leadDetailModel.lead?.crmStatusDetails;
        final currentDummyStatus =
            DummyStatusList.getStatusDetails(currentStatus?.name ?? '');

        return PopupMenuButton<String>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          position: PopupMenuPosition.under,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 140,
            maxWidth: 140,
          ),
          onSelected: (selectedValue) async {
            final selectedStatus = controller.statusListModel.crmStatus
                ?.firstWhere((status) => status.name == selectedValue);

            final dummyStatus = DummyStatusList.getStatusDetails(selectedValue);

            if (selectedStatus != null) {
              await controller.updateStatus(
                  widget.leadId, selectedStatus.slug, context);

              setState(() {
                controller.leadDetailModel.lead?.crmStatusDetails =
                    CrmStatusDetails(
                  id: selectedStatus.id,
                  name: selectedStatus.name,
                  bgColor: dummyStatus['bgColor'],
                  textColor: dummyStatus['textColor'],
                );
              });
            }
          },
          itemBuilder: (context) {
            return List.generate(
              controller.statusListModel.crmStatus?.length ?? 0,
              (index) {
                final status = controller.statusListModel.crmStatus?[index];
                final dummyStatus =
                    DummyStatusList.getStatusDetails(status?.name ?? '');

                return PopupMenuItem<String>(
                  height: 40,
                  padding: EdgeInsets.zero,
                  value: status?.name,
                  child: Container(
                    width: 140.w,
                    height: 45.h,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                          'FF${dummyStatus['bgColor']?.replaceFirst('#', '') ?? 'FFFFFF'}',
                          radix: 16)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      status?.name ?? 'Unknown Status',
                      style: GLTextStyles.manropeStyle(
                        size: 14.sp,
                        weight: FontWeight.w400,
                        color: Color(int.parse(
                            'FF${dummyStatus['textColor']?.replaceFirst('#', '') ?? '000000'}',
                            radix: 16)),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: currentStatus?.bgColor != null
                  ? Color(int.parse(
                      'FF${currentDummyStatus['bgColor']?.replaceFirst('#', '') ?? 'FFFFFF'}',
                      radix: 16))
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(5.5),
            ),
            child: Row(
              children: [
                Text(
                  currentStatus?.name ?? "Status",
                  style: GLTextStyles.manropeStyle(
                    color: currentStatus?.textColor != null
                        ? Color(int.parse(
                            'FF${currentDummyStatus['textColor']?.replaceFirst('#', '') ?? '000000'}',
                            radix: 16))
                        : ColorTheme.black,
                    size: 14.sp,
                    weight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 4.w),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Color(0xFFB5BEC6),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
