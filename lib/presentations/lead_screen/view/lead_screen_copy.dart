import 'dart:convert';
import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/logout_button.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/filter_modal.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/lead_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadScreenCopy extends StatefulWidget {
  const LeadScreenCopy({super.key});

  @override
  State<LeadScreenCopy> createState() => _LeadScreenCopyState();
}

class _LeadScreenCopyState extends State<LeadScreenCopy> {
  int selectedIndex = -1;
  final ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  final Map<String, String?> selectedUsers = {};
  final FocusNode _searchFocusNode = FocusNode();
  bool _isFilterApplied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
      scrollController.addListener(scrollListener);
    });
  }

  void fetchData() async {
    await Provider.of<LeadController>(context, listen: false)
        .fetchData(context);
    Provider.of<LeadController>(context, listen: false).fetchUserList(context);
    setState(() {});
  }

  void fetchMoreData() async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      await Provider.of<LeadController>(context, listen: false)
          .loadMoreData(context);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void scrollListener() {
    if (scrollController.position.extentAfter < 500) {
      fetchMoreData();
    }
  }

  void updateSelectedUser(String leadId, String? user) {
    setState(() {
      selectedUsers[leadId] = user;
    });
  }

  void clearFilter() {
    setState(() {
      selectedUsers.clear();
      _isFilterApplied = false;
      Provider.of<LeadController>(context, listen: false)
          .searchController
          .clear();
      Provider.of<LeadController>(context, listen: false)
          .fetchData(context); // Refetch original data
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _searchFocusNode.dispose();
    Provider.of<LeadController>(context, listen: false)
        .searchController
        .dispose();
    super.dispose();
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
    await Provider.of<LeadController>(context, listen: false)
        .fetchData(context);
    await Provider.of<LeadController>(context, listen: false)
        .fetchUserList(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorTheme.desaiGreen,
          title: FutureBuilder<String?>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingAnimationWidget.staggeredDotsWave(
                  color: ColorTheme.desaiGreen,
                  size: 32,
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text("Unknown User");
              }
              String userName = snapshot.data ?? "Unknown User";
              return Row(
                children: [
                  Container(
                    width: (35 / ScreenUtil().screenWidth).sw,
                    height: (35 / ScreenUtil().screenHeight).sh,
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 0.14.sh,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: ColorTheme.desaiGreen,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 15.w),
                      Flexible(
                        child: SizedBox(
                            height: 44.h,
                            child: ValueListenableBuilder(
                              valueListenable: Provider.of<LeadController>(
                                      context,
                                      listen: false)
                                  .searchController,
                              builder:
                                  (context, TextEditingValue value, child) {
                                return SearchBar(
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.only(left: 15.w)),
                                  hintText: "Search ...",
                                  hintStyle: WidgetStatePropertyAll(
                                    GLTextStyles.manropeStyle(
                                      size: 13.sp,
                                      weight: FontWeight.w400,
                                      color: const Color.fromARGB(
                                          255, 132, 132, 132),
                                    ),
                                  ),
                                  elevation: const MaterialStatePropertyAll(0),
                                  surfaceTintColor:
                                      const MaterialStatePropertyAll(
                                          Colors.white),
                                  leading: Icon(
                                    Iconsax.search_normal_1,
                                    size: 18.sp,
                                    color: const Color.fromARGB(
                                        255, 132, 132, 132),
                                  ),
                                  trailing: value.text.isNotEmpty
                                      ? [
                                          IconButton(
                                            icon: Icon(
                                              Iconsax.close_circle,
                                              size: 18.sp,
                                              color: const Color.fromARGB(
                                                  255, 132, 132, 132),
                                            ),
                                            onPressed: () {
                                              Provider.of<LeadController>(
                                                      context,
                                                      listen: false)
                                                  .searchController
                                                  .clear();

                                              Provider.of<LeadController>(
                                                      context,
                                                      listen: false)
                                                  .searchLeads(context);
                                            },
                                          ),
                                        ]
                                      : null,
                                  textStyle: WidgetStatePropertyAll(
                                    GLTextStyles.manropeStyle(
                                      weight: FontWeight.w400,
                                      size: 15.sp,
                                      color:
                                          const Color.fromARGB(255, 87, 87, 87),
                                    ),
                                  ),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.38),
                                    ),
                                  ),
                                  controller: Provider.of<LeadController>(
                                          context,
                                          listen: false)
                                      .searchController,
                                  onChanged: (value) {
                                    Provider.of<LeadController>(context,
                                            listen: false)
                                        .searchLeads(context);
                                  },
                                  onSubmitted: (value) {
                                    Provider.of<LeadController>(context,
                                            listen: false)
                                        .searchLeads(context);
                                  },
                                );
                              },
                            )),
                      ),
                      SizedBox(width: 10.w),
                      SizedBox(
                        height: 44.h,
                        child: Container(
                          width: 44.w,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(7.38.r),
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FilterModal(
                                      clearFiltersCallback: clearFilter,
                                      onFilterApplied: () {
                                        setState(() {
                                          _isFilterApplied = true;
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Iconsax.setting_5,
                                size: 18.sp,
                                color: const Color.fromARGB(255, 132, 132, 132),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Text(
                    "Leads",
                    style: GLTextStyles.manropeStyle(
                      size: 18.sp,
                      weight: FontWeight.w600,
                      color: const Color(0xff120e2b),
                    ),
                  ),
                ),
                if (_isFilterApplied)
                  GestureDetector(
                    onTap: clearFilter,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(5.5.r),
                      ),
                      child: Row(children: [
                        Text(
                          "Remove filter",
                          style: GLTextStyles.manropeStyle(
                            color: ColorTheme.grey,
                            size: 13.sp,
                            weight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Iconsax.close_circle,
                          size: 14.sp,
                          color: const Color.fromARGB(255, 127, 127, 127),
                        ),
                      ]),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Consumer<LeadController>(
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
                      controller: scrollController,
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
                                    (controller.userListModel.users?.length ??
                                        0)
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
                      itemCount: controller.isLoadingMore
                          ? controller.leadModel.leads!.data!.length + 1
                          : controller.leadModel.leads?.data?.length ?? 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
