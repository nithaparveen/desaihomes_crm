import 'package:another_flushbar/flushbar.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/lead_detail_screen.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/quick_edit_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:provider/provider.dart';

class LeadCard extends StatelessWidget {
  final String name;
  final String location;
  final String platform;
  final String timeAgo;
  final String initials;
  final String status;
  final List<String> users;
  final String leadId;
  final String userId;
  final String? selectedUser;
  final Function(String leadId, String? selectedUser) onUserSelected;
  final int index;

  const LeadCard({
    super.key,
    required this.name,
    required this.location,
    required this.platform,
    required this.timeAgo,
    required this.initials,
    required this.status,
    required this.users,
    required this.leadId,
    required this.userId,
    required this.selectedUser,
    required this.onUserSelected,
    required this.index,
  });

  Widget _buildAvatar(String initials, int index) {
    final List<Color> colors = [
      const Color(0xFFBCFFBE),
      const Color(0xFFD9BCFF),
      const Color(0xFFFFF8BC),
      const Color(0xFFBCDBFF),
    ];

    final Color backgroundColor = colors[index % colors.length];

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: GLTextStyles.robotoStyle(
            color: ColorTheme.blue,
            size: 20,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLeadDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: GLTextStyles.manropeStyle(
              color: const Color(0xff120e2b),
              size: 14,
              weight: FontWeight.w700,
            ),
          ),
          Text(
            location,
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.grey,
              size: 14,
              weight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            platform,
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.black,
              size: 14,
              weight: FontWeight.w500,
            ),
          ),
          Text(
            timeAgo,
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.lightBlue,
              size: 12.5,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final leadController = Provider.of<LeadController>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PopupMenuButton<String>(
              color: const Color(0xfff5f5f5),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'assign_user',
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      height: size.width * .75,
                      width: size.width * .4,
                      child: Scrollbar(
                        thickness: 2,
                        radius: const Radius.circular(15),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 5),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: const Color(0xfff5f5f5),
                              title: Text(
                                users[index],
                                style: GLTextStyles.manropeStyle(
                                  color: ColorTheme.black,
                                  size: 14,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              onTap: () async {
                                final newSelectedUser = users[index];
                                final newUserId = leadController
                                        .userListModel.users?[index].id
                                        .toString() ??
                                    '';

                                onUserSelected(leadId, newSelectedUser);

                                leadController.assignedToTapped(
                                  leadId,
                                  newUserId,
                                  context,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LeadDetailScreen(
                                      leadId: int.tryParse(leadId),
                                    ),
                                  ),
                                );

                                await leadController.fetchData(context);

                                Flushbar(
                                  maxWidth: size.width * .55,
                                  backgroundColor: Colors.grey.shade100,
                                  messageColor: ColorTheme.black,
                                  icon: Icon(
                                    Iconsax.profile_tick,
                                    color: ColorTheme.green,
                                    size: 20,
                                  ),
                                  message: 'Assign Successful',
                                  duration: const Duration(seconds: 3),
                                  flushbarPosition: FlushbarPosition.TOP,
                                ).show(context);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ];
              },
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffD8D8D8),
                    width: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child:
                    leadController.leadModel.leads?.data?[index].assignedTo ==
                            null
                        ? const Icon(
                            Iconsax.profile_add,
                            size: 22,
                            color: Colors.black87,
                          )
                        : Text(
                            (leadController.leadModel.leads?.data?[index]
                                        .assignedToDetails?.name ??
                                    "")
                                .substring(0, 2)
                                .toUpperCase(),
                            style: GLTextStyles.robotoStyle(
                              color: ColorTheme.lightBlue,
                              size: 16,
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
                    return const QuickEditModal();
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
        const SizedBox(height: 16),
        Container(
          width: 95,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF4FF),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              status,
              style: GLTextStyles.manropeStyle(
                color: ColorTheme.lightBlue,
                size: 10,
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
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(initials, index),
          const SizedBox(width: 16),
          _buildLeadDetails(),
          _buildActions(context),
        ],
      ),
    );
  }
}