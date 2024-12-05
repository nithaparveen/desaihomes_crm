import 'dart:convert';

import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/logout_button.dart';
import 'package:desaihomes_crm_application/presentations/follow_ups_screen/controller/follow_up_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/lead_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({super.key});

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  final Map<String, String?> selectedUsers = {};

  Future<String?> getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? storedData = sharedPreferences.getString(AppConfig.loginData);

    if (storedData != null) {
      var loginData = jsonDecode(storedData);
      if (loginData["user"] != null && loginData["user"]['name'] != null) {
        return loginData["user"]['name'];
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  void fetchData() async {
    await Provider.of<FollowUpController>(context, listen: false)
        .fetchData(context);
    Provider.of<FollowUpController>(context, listen: false)
        .fetchUserList(context);
    setState(() {});
  }

  void updateSelectedUser(String leadId, String? user) {
    setState(() {
      selectedUsers[leadId] = user;
    });
  }

  String removeClassName(String input) {
    return input.replaceAll(RegExp(r'.*\.'), '');
  }

  String getInitials(String? name) {
    if (name == null || name.isEmpty) return '';

    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }
    return words
        .take(2)
        .map((word) => word.substring(0, 1).toUpperCase())
        .join();
  }

  Future<void> _refreshData() async {
    await Provider.of<FollowUpController>(context, listen: false)
        .fetchData(context);
    await Provider.of<FollowUpController>(context, listen: false)
        .fetchUserList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.h),
        child: AppBar(
          backgroundColor: ColorTheme.desaiGreen,
          foregroundColor: ColorTheme.desaiGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          title: FutureBuilder<String?>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text("Unknown User");
              }
              String userName = snapshot.data ?? "Unknown User";
              return Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 202, 158, 208),
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.5, color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        userName.substring(0, 2).toUpperCase(),
                        style: GLTextStyles.robotoStyle(
                          color: ColorTheme.blue,
                          size: 13.sp,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    userName,
                    style: GLTextStyles.manropeStyle(
                      color: ColorTheme.white,
                      size: 14.sp,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
          actions: const [LogoutButton()],
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Text(
              "Follow Up Leads",
              style: GLTextStyles.manropeStyle(
                size: 18.sp,
                weight: FontWeight.w600,
                color: const Color(0xff120e2b),
              ),
            ),
          ),
          Expanded(
            child: Consumer<FollowUpController>(
              builder: (context, controller, _) {
                if (controller.leadModel.leads?.data == null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: ColorTheme.desaiGreen,
                        size: 32,
                      ),
                    ),
                  );
                }
                final leads = controller.leadModel.leads?.data ?? [];

                if (leads.isEmpty) {
                  return Center(
                    child: Text(
                      "No Leads Found",
                      style: GLTextStyles.manropeStyle(
                        size: 16.sp,
                        weight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: ColorTheme.desaiGreen,
                  onRefresh: _refreshData,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index >= controller.leadModel.leads!.data!.length) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: ColorTheme.desaiGreen,
                              size: 32,
                            ),
                          ),
                        );
                      }

                      final lead = controller.leadModel.leads?.data?[index];
                      final projectName = lead?.project?.name.toString();
                      final sourceName = lead?.source.toString();
                      final leadId = '${lead?.id}';

                      return Padding(
                        padding: EdgeInsets.only(left: 15.w, right: 15.w),
                        child: LeadCard(
                          name: '${lead?.name}',
                          location: projectName != null
                              ? removeClassName(projectName)
                              : '',
                          platform: sourceName != null
                              ? removeClassName(sourceName)
                              : '',
                          timeAgo: GetTimeAgo.parse(
                            DateTime.parse("${lead?.updatedAt}"),
                          ),
                          initials: getInitials(lead?.name),
                          status: '${lead?.crmStatusDetails?.name}',
                          users: controller.userListModel.users
                                  ?.map((user) => user.name ?? '')
                                  .toList() ??
                              [],
                          leadId: leadId,
                          userId: index <
                                  (controller.userListModel.users?.length ?? 0)
                              ? '${controller.userListModel.users?[index].id}'
                              : '',
                          selectedUser: selectedUsers[leadId],
                          onUserSelected: updateSelectedUser,
                          index: index,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 14.w),
                    itemCount: controller.leadModel.leads?.data?.length ?? 0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
