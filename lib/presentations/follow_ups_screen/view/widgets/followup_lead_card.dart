import 'package:another_flushbar/flushbar.dart';
import 'package:desaihomes_crm_application/global_widgets/dummy_status_list.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/lead_detail_screen_copy.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/duplicate_lead_modal.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/quick_edit_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:provider/provider.dart';

class FollowUpLeadCard extends StatelessWidget {
  final String name;
  final String location;
  final String platform;
  final String followupDate;
  final String initials;
  final String assignInitials;
  final String status;
  final List<String> users;
  final String leadId;
  final String userId;
  final String? selectedUser;
  final Function(String leadId, String? selectedUser) onUserSelected;
  final int index;
  final bool? duplicateFlag;
  final dynamic leadData;

  const FollowUpLeadCard({
    super.key,
    required this.name,
    required this.location,
    required this.platform,
    required this.followupDate,
    required this.initials,
    required this.status,
    required this.users,
    required this.leadId,
    required this.userId,
    required this.selectedUser,
    required this.onUserSelected,
    required this.index,
    this.duplicateFlag,
    this.leadData, required this.assignInitials,
  });

  Widget buildAvatar(String initials, int index) {
    final List<Color> colors = [
      const Color(0xFFBCFFBE),
      const Color(0xFFD9BCFF),
      const Color(0xFFFFF8BC),
      const Color(0xFFBCDBFF),
    ];

    final Color backgroundColor = colors[index % colors.length];

    return Container(
      width: (45 / ScreenUtil().screenWidth).sw,
      height: (45 / ScreenUtil().screenHeight).sh,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: GLTextStyles.robotoStyle(
            color: ColorTheme.blue,
            size: 20.sp,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildLeadDetails(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LeadDetailScreenCopy(
                leadId: int.tryParse(leadId) ?? 0,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: GLTextStyles.manropeStyle(
                      color: const Color(0xff120e2b),
                      size: 14.sp,
                      weight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: false,
                  ),
                ),
                if (duplicateFlag == true)
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DuplicateLeadModal(
                            leadId: leadId,
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      height: 18.h,
                      width: 40.w,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Icon(
                          Icons.warning_sharp,
                          size: 16.sp,
                          color: ColorTheme.yellow,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (location != null && location.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(
                  location,
                  style: GLTextStyles.manropeStyle(
                    color: ColorTheme.grey,
                    size: 14.sp,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            if (platform != null && platform.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                    top: (location != null && location.isNotEmpty) ? 4.h : 2.h),
                child: Text(
                  platform,
                  style: GLTextStyles.manropeStyle(
                    color: ColorTheme.black,
                    size: 14.sp,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            if (followupDate != null && followupDate.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  followupDate,
                  style: GLTextStyles.manropeStyle(
                    color: ColorTheme.lightBlue,
                    size: 12.5.sp,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildActions(BuildContext context) {
    final leadController = Provider.of<LeadController>(context, listen: false);
    final dummyStatus = DummyStatusList.getStatusDetails(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PopupMenuButton<String>(
              elevation: 8,
              shadowColor: Colors.black26,
              color: const Color.fromARGB(255, 255, 255, 255),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    padding: EdgeInsets.zero,
                    value: 'assign_user',
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      height: .45.sh,
                      width: .4.sw,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 5),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              final newSelectedUser = users[index];
                              final newUserId = leadController
                                      .userListModel.users?[index].id
                                      .toString() ??
                                  '';

                              onUserSelected(leadId, newSelectedUser);
                              await leadController.assignedToTapped(
                                  leadId, newUserId, newSelectedUser, context);

                              Navigator.pop(context);
                              Flushbar(
                                maxWidth: .55.sw,
                                backgroundColor: Colors.grey.shade100,
                                messageColor: ColorTheme.black,
                                icon: Icon(
                                  Iconsax.profile_tick,
                                  color: ColorTheme.green,
                                  size: 20.sp,
                                ),
                                message: 'Assign Successful',
                                duration: const Duration(seconds: 2),
                                flushbarPosition: FlushbarPosition.TOP,
                              ).show(context);

                              leadController.notifyListeners();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12.r,
                                        backgroundColor:
                                            const Color(0xff25274B),
                                        child: Text(
                                          users[index]
                                              .substring(0, 2)
                                              .toUpperCase(),
                                          style: GLTextStyles.manropeStyle(
                                            color: ColorTheme.white,
                                            size: 10.sp,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          users[index],
                                          style: GLTextStyles.manropeStyle(
                                            color: const Color(0xff1E232C),
                                            size: 12.sp,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (index != users.length - 1)
                                    Divider(
                                      color:
                                          const Color.fromARGB(44, 95, 95, 87),
                                      thickness: 0.55,
                                      height: 18.h,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ];
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffD8D8D8),
                    width: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  assignInitials.substring(0, 2).toUpperCase(),
                  style: GLTextStyles.robotoStyle(
                    color: ColorTheme.lightBlue,
                    size: 16.sp,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return QuickEditModal(
                      email: leadController.leadModel.leads?.data != null &&
                              index <
                                  leadController.leadModel.leads!.data!.length
                          ? (leadController
                                  .leadModel.leads?.data?[index].email ??
                              "")
                          : "",
                      phoneNumber: leadController.leadModel.leads?.data !=
                                  null &&
                              index <
                                  leadController.leadModel.leads!.data!.length
                          ? (leadController
                                  .leadModel.leads?.data?[index].phoneNumber ??
                              "")
                          : "",
                      leadId:
                          leadController.leadModel.leads?.data?[index].id ?? 0,
                    );
                  },
                );
              },
              child: const Icon(
                Icons.more_vert,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          width: (100 / ScreenUtil().screenWidth).sw,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          decoration: BoxDecoration(
            color: Color(int.parse(
                'FF${dummyStatus['bgColor']?.replaceFirst('#', '')}',
                radix: 16)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              status,
              style: GLTextStyles.manropeStyle(
                color: Color(int.parse(
                    'FF${dummyStatus['textColor']?.replaceFirst('#', '')}',
                    radix: 16)),
                size: 10.sp,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding:
          EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h, bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildAvatar(initials, index),
          SizedBox(width: 16.w),
          buildLeadDetails(context),
          buildActions(context),
        ],
      ),
    );
  }
}
