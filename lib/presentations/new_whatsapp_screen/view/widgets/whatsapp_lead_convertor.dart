import 'dart:math';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/project_list_model.dart';
import 'package:desaihomes_crm_application/repository/api/lead_screen/model/user_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';

class WhatsappLeadConvertor extends StatefulWidget {
  final List<String> leads;
  final List<int> leadIds;
  final Function(List<Map<String, dynamic>>) onConvert;

  const WhatsappLeadConvertor({
    super.key,
    required this.leads,
    required this.leadIds,
    required this.onConvert,
  });

  @override
  State<WhatsappLeadConvertor> createState() => _WhatsappLeadConvertorState();
}

class _WhatsappLeadConvertorState extends State<WhatsappLeadConvertor> {
  List<String> selectedLeads = [];
  bool selectAll = false;
  Map<String, String?> assignedUsers = {};
  Map<String, String?> selectedProjects = {};
  Map<String, String?> assignedUserNames = {};
  Map<String, String?> selectedProjectNames = {};

  @override
  void initState() {
    super.initState();
    for (var lead in widget.leads) {
      assignedUsers[lead] = null;
      selectedProjects[lead] = null;
      assignedUserNames[lead] = null;
      selectedProjectNames[lead] = null;
    }
  }

  void toggleSelectAll() {
    setState(() {
      selectAll = !selectAll;
      selectedLeads = selectAll ? List.from(widget.leads) : [];
    });
  }

  void toggleLeadSelection(String lead) {
    setState(() {
      if (selectedLeads.contains(lead)) {
        selectedLeads.remove(lead);
      } else {
        selectedLeads.add(lead);
      }
      selectAll = selectedLeads.length == widget.leads.length;
    });
  }

  void clearSelection() {
    setState(() {
      selectedLeads.clear();
      selectAll = false;
    });
  }

  Future<void> _assignUser(
      String leadId, String userId, String userName) async {
    setState(() {
      assignedUsers[leadId] = userId;
      assignedUserNames[leadId] = userName;
    });
    _showSuccessMessage('User assigned successfully');
  }

  Future<void> _selectProject(
      String leadId, String projectId, String projectName) async {
    setState(() {
      selectedProjects[leadId] = projectId;
      selectedProjectNames[leadId] = projectName;
    });
    _showSuccessMessage('Project assigned successfully');
  }

  bool _hasUnassignedLeads() {
    for (var lead in selectedLeads) {
      if (assignedUsers[lead] == null || selectedProjects[lead] == null) {
        return true;
      }
    }
    return false;
  }

  bool _hasAssignedLeads() {
    for (var lead in selectedLeads) {
      if (assignedUsers[lead] != null && selectedProjects[lead] != null) {
        return true;
      }
    }
    return false;
  }

  void _showSuccessMessage(String message) {
    Flushbar(
      maxWidth: .55.sw,
      backgroundColor: Colors.grey.shade100,
      messageColor: ColorTheme.black,
      icon: Icon(Iconsax.tick_circle, color: ColorTheme.green, size: 20.sp),
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  void _showErrorMessage(String message) {
    Flushbar(
      maxWidth: .55.sw,
      backgroundColor: Colors.grey.shade100,
      messageColor: ColorTheme.black,
      icon: Icon(Iconsax.close_circle, color: Colors.red, size: 20.sp),
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  void _showBulkAssignmentModal() {
    showDialog(
      context: context,
      builder: (context) => BulkAssignmentModal(
        leadIds: selectedLeads,
        onAssign: (userId, projectId, userName, projectName) {
          // Update all selected leads with the same assignment
          for (var lead in selectedLeads) {
            assignedUsers[lead] = userId;
            selectedProjects[lead] = projectId;
            assignedUserNames[lead] = userName;
            selectedProjectNames[lead] = projectName;
          }
          Navigator.pop(context);
          _showSuccessMessage('Bulk assignment successful');
          setState(() {});
        },
        leadController: Provider.of<LeadController>(context, listen: false),
      ),
    );
  }

void _convertLeads() {
  final List<Map<String, dynamic>> leadsToConvert = [];

  // Create a mapping of lead names to their IDs
  final Map<String, int> nameToIdMap = {};
  for (int i = 0; i < widget.leads.length; i++) {
    nameToIdMap[widget.leads[i]] = widget.leadIds[i];
  }

  for (var leadName in selectedLeads) {
    final leadId = nameToIdMap[leadName];
    if (leadId != null) {
      leadsToConvert.add({
        'id': leadId,  // Use the actual ID here
        'project_id': selectedProjects[leadName],
        'assigned_to': assignedUsers[leadName],
      });
    }
  }

  widget.onConvert(leadsToConvert);
  Navigator.of(context).pop();
}

  @override
  Widget build(BuildContext context) {
    final leadController = Provider.of<LeadController>(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: (400 / ScreenUtil().screenWidth).sw,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.only(left: 18.w, right: 10.w, top: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Whatsapp Lead Conversion',
                        style: GLTextStyles.manropeStyle(
                          color: ColorTheme.blue,
                          size: 16.sp,
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

                // Select all row
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: Checkbox(
                              activeColor: ColorTheme.desaiGreen,
                              value: selectAll,
                              onChanged: (_) => toggleSelectAll(),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r)),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Select all',
                            style: GLTextStyles.manropeStyle(
                              color: Colors.black87,
                              size: 14.sp,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: clearSelection,
                        child: Row(
                          children: [
                            Text(
                              'Clear',
                              style: GLTextStyles.manropeStyle(
                                color: Colors.black54,
                                size: 14.sp,
                                weight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Iconsax.close_circle,
                                size: 18.sp, color: Colors.black54)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Leads list
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: widget.leads.length,
                    itemBuilder: (context, index) {
                      final lead = widget.leads[index];
                      final isSelected = selectedLeads.contains(lead);
                      final assignedUserName = assignedUserNames[lead];
                      final selectedProjectName = selectedProjectNames[lead];

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.w, vertical: 4.h),
                        child: Row(
                          children: [
                            // Checkbox
                            SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: Checkbox(
                                activeColor: ColorTheme.desaiGreen,
                                value: isSelected,
                                onChanged: (_) => toggleLeadSelection(lead),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r)),
                              ),
                            ),

                            // Lead name
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Text(
                                lead,
                                style: GLTextStyles.manropeStyle(
                                  color: Colors.black87,
                                  size: 14.sp,
                                  weight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // User assignment button
                            _UserAssignmentButton(
                              leadId: lead,
                              assignedUserName: assignedUserName,
                              users: leadController.userListModel.users ?? [],
                              onUserSelected: _assignUser,
                            ),

                            SizedBox(width: 15.w),

                            // Project selection button
                            _ProjectSelectionButton(
                              leadId: lead,
                              selectedProjectName: selectedProjectName,
                              projects:
                                  leadController.projectListModel.projects ??
                                      [],
                              onProjectSelected: _selectProject,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Action buttons
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            side: BorderSide(color: Colors.red.shade300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Close',
                            style: GLTextStyles.manropeStyle(
                              color: Colors.red.shade400,
                              size: 14.sp,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            backgroundColor: ColorTheme.desaiGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                          onPressed: selectedLeads.isEmpty
                              ? null
                              : () {
                                  if (_hasUnassignedLeads()) {
                                    _showBulkAssignmentModal();
                                  } else {
                                    _convertLeads();
                                  }
                                },
                          child: Text(
                            _hasUnassignedLeads() ? 'NEXT' : 'CONVERT',
                            style: GLTextStyles.manropeStyle(
                              color: Colors.white,
                              size: 14.sp,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BulkAssignmentModal extends StatefulWidget {
  final List<String> leadIds;
  final Function(String, String, String, String) onAssign;
  final LeadController leadController;

  const BulkAssignmentModal({
    super.key,
    required this.leadIds,
    required this.onAssign,
    required this.leadController,
  });

  @override
  State<BulkAssignmentModal> createState() => _BulkAssignmentModalState();
}

class _BulkAssignmentModalState extends State<BulkAssignmentModal> {
  String? selectedUserId;
  String? selectedProjectId;
  String? selectedUserName;
  String? selectedProjectName;

  void _showSuccessMessage(String message) {
    Flushbar(
      maxWidth: .55.sw,
      backgroundColor: Colors.grey.shade100,
      messageColor: ColorTheme.black,
      icon: Icon(Iconsax.tick_circle, color: ColorTheme.green, size: 20.sp),
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: (400 / ScreenUtil().screenWidth).sw,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.only(left: 18.w, right: 10.w, top: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bulk Assign  ${widget.leadIds.length}  Lead(s)',
                        style: GLTextStyles.manropeStyle(
                          color: ColorTheme.blue,
                          size: 14.sp,
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

                SizedBox(height: 16.h),

                // User assignment
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: PopupMenuButton<String>(
                          elevation: 8,
                          shadowColor: Colors.black26,
                          color: Colors.white,
                          offset: const Offset(0, 10),
                          position: PopupMenuPosition.over,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            maxWidth: 180.w,
                            maxHeight: 200.h,
                          ),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem<String>(
                                padding: EdgeInsets.zero,
                                height: 200.h,
                                enabled: false,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: SizedBox(
                                    width: 160.w,
                                    height: 180.h,
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                        color: Color.fromARGB(44, 95, 95, 87),
                                        thickness: 0.55,
                                        height: 1,
                                        indent: 0,
                                        endIndent: 0,
                                      ),
                                      itemCount: widget.leadController
                                              .userListModel.users?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final user = widget.leadController
                                            .userListModel.users![index];
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              selectedUserId =
                                                  user.id.toString();
                                              selectedUserName = user.name;
                                            });
                                            _showSuccessMessage(
                                                'User selected');
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 8.h,
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 12.r,
                                                  backgroundColor:
                                                      const Color(0xff25274B),
                                                  child: Text(
                                                    (user.name ?? '').isNotEmpty
                                                        ? (user.name ?? '')
                                                            .substring(
                                                                0,
                                                                min(
                                                                    2,
                                                                    (user.name ??
                                                                            '')
                                                                        .length))
                                                            .toUpperCase()
                                                        : '',
                                                    style: GLTextStyles
                                                        .manropeStyle(
                                                      color: ColorTheme.white,
                                                      size: 10.sp,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: Text(
                                                    user.name ?? '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GLTextStyles
                                                        .manropeStyle(
                                                      color: const Color(
                                                          0xff1E232C),
                                                      size: 12.sp,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ];
                          },
                          child: Center(
                            child: selectedUserName == null ||
                                    selectedUserName!.isEmpty
                                ? Icon(Iconsax.profile_add,
                                    size: 20.sp, color: Colors.black87)
                                : Text(
                                    selectedUserName!
                                        .substring(
                                            0, min(2, selectedUserName!.length))
                                        .toUpperCase(),
                                    style: GLTextStyles.robotoStyle(
                                      color: ColorTheme.lightBlue,
                                      size: 16.sp,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          selectedUserName ?? 'Assign to User',
                          style: GLTextStyles.manropeStyle(
                            color: selectedUserName == null
                                ? Colors.black54
                                : Colors.black87,
                            size: 14.sp,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Project assignment
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: PopupMenuButton<String>(
                          elevation: 8,
                          shadowColor: Colors.black26,
                          color: Colors.white,
                          offset: const Offset(0, 10),
                          position: PopupMenuPosition.over,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            maxWidth: 180.w,
                            maxHeight: 200.h,
                          ),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem<String>(
                                padding: EdgeInsets.zero,
                                height: 200.h,
                                enabled: false,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: SizedBox(
                                    width: 160.w,
                                    height: 180.h,
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                        color: Color.fromARGB(44, 95, 95, 87),
                                        thickness: 0.55,
                                        height: 1,
                                        indent: 0,
                                        endIndent: 0,
                                      ),
                                      itemCount: widget
                                              .leadController
                                              .projectListModel
                                              .projects
                                              ?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final project = widget.leadController
                                            .projectListModel.projects![index];
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              selectedProjectId =
                                                  project.id.toString();
                                              selectedProjectName =
                                                  project.name;
                                            });
                                            _showSuccessMessage(
                                                'Project selected');
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 8.h,
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 12.r,
                                                  backgroundColor:
                                                      const Color(0xff25274B),
                                                  child: Text(
                                                    (project.name ?? '')
                                                            .isNotEmpty
                                                        ? (project.name ?? '')
                                                            .substring(
                                                                0,
                                                                min(
                                                                    2,
                                                                    (project.name ??
                                                                            '')
                                                                        .length))
                                                            .toUpperCase()
                                                        : '',
                                                    style: GLTextStyles
                                                        .manropeStyle(
                                                      color: ColorTheme.white,
                                                      size: 10.sp,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: Text(
                                                    project.name ?? '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GLTextStyles
                                                        .manropeStyle(
                                                      color: const Color(
                                                          0xff1E232C),
                                                      size: 12.sp,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ];
                          },
                          child: Center(
                            child: selectedProjectName == null ||
                                    selectedProjectName!.isEmpty
                                ? Icon(Iconsax.activity,
                                    size: 20.sp, color: Colors.black87)
                                : Text(
                                    selectedProjectName!
                                        .substring(0,
                                            min(2, selectedProjectName!.length))
                                        .toUpperCase(),
                                    style: GLTextStyles.robotoStyle(
                                      color: ColorTheme.lightBlue,
                                      size: 16.sp,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          selectedProjectName ?? 'Select Project',
                          style: GLTextStyles.manropeStyle(
                            color: selectedProjectName == null
                                ? Colors.black54
                                : Colors.black87,
                            size: 14.sp,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Action buttons
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            side: BorderSide(color: Colors.red.shade300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: GLTextStyles.manropeStyle(
                              color: Colors.red.shade400,
                              size: 14.sp,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            backgroundColor: ColorTheme.desaiGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                          onPressed: (selectedUserId == null ||
                                  selectedProjectId == null)
                              ? null
                              : () {
                                  widget.onAssign(
                                    selectedUserId!,
                                    selectedProjectId!,
                                    selectedUserName!,
                                    selectedProjectName!,
                                  );
                                },
                          child: Text(
                            'CONVERT',
                            style: GLTextStyles.manropeStyle(
                              color: Colors.white,
                              size: 14.sp,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserAssignmentButton extends StatelessWidget {
  final String leadId;
  final String? assignedUserName;
  final List<User> users;
  final Function(String, String, String) onUserSelected;

  const _UserAssignmentButton({
    required this.leadId,
    required this.assignedUserName,
    required this.users,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: PopupMenuButton<String>(
        elevation: 8,
        shadowColor: Colors.black26,
        color: Colors.white,
        offset: const Offset(0, 10),
        position: PopupMenuPosition.over,
        padding: EdgeInsets.zero, // Remove default padding
        constraints: BoxConstraints(
          maxWidth: 180.w,
          maxHeight: 200.h,
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem<String>(
              padding: EdgeInsets.zero, // Remove padding from the menu item
              height: 200.h,
              enabled: false,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 160.w,
                  height: 180.h,
                  child: ListView.separated(
                    padding: EdgeInsets.zero, // Remove padding from ListView
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(
                      color: Color.fromARGB(44, 95, 95, 87),
                      thickness: 0.55,
                      height: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          onUserSelected(
                              leadId, user.id.toString(), user.name ?? '');

                          // Show success notification
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
                            duration: const Duration(seconds: 3),
                            flushbarPosition: FlushbarPosition.TOP,
                          ).show(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12.r,
                                backgroundColor: const Color(0xff25274B),
                                child: Text(
                                  (user.name ?? '').isNotEmpty
                                      ? (user.name ?? '')
                                          .substring(0,
                                              min(2, (user.name ?? '').length))
                                          .toUpperCase()
                                      : '',
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
                                  user.name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: GLTextStyles.manropeStyle(
                                    color: const Color(0xff1E232C),
                                    size: 12.sp,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ];
        },
        child: Center(
          child: assignedUserName == null || assignedUserName!.isEmpty
              ? Icon(Iconsax.profile_add, size: 20.sp, color: Colors.black87)
              : Text(
                  assignedUserName!
                      .substring(0, min(2, assignedUserName!.length))
                      .toUpperCase(),
                  style: GLTextStyles.robotoStyle(
                    color: ColorTheme.lightBlue,
                    size: 16.sp,
                    weight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ProjectSelectionButton extends StatelessWidget {
  final String leadId;
  final String? selectedProjectName;
  final List<Project> projects;
  final Function(String, String, String) onProjectSelected;

  const _ProjectSelectionButton({
    required this.leadId,
    required this.selectedProjectName,
    required this.projects,
    required this.onProjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: PopupMenuButton<String>(
        elevation: 8,
        shadowColor: Colors.black26,
        color: Colors.white,
        onSelected: (_) {},
        itemBuilder: (context) => projects
            .map((project) => PopupMenuItem<String>(
                  value: project.id.toString(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                      onProjectSelected(
                          leadId, project.id.toString(), project.name ?? '');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12.r,
                            backgroundColor: const Color(0xff25274B),
                            child: Text(
                              (project.name ?? '')
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
                          Text(
                            project.name ?? '',
                            style: GLTextStyles.manropeStyle(
                              color: const Color(0xff1E232C),
                              size: 12.sp,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
        child: Center(
          child: selectedProjectName == null
              ? Icon(Iconsax.activity, size: 20.sp, color: Colors.black87)
              : Text(
                  selectedProjectName!.substring(0, 2).toUpperCase(),
                  style: GLTextStyles.robotoStyle(
                    color: ColorTheme.lightBlue,
                    size: 16.sp,
                    weight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
