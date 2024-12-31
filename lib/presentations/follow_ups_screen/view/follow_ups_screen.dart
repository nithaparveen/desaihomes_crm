import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/global_appbar.dart';
import 'package:desaihomes_crm_application/presentations/follow_ups_screen/controller/follow_up_controller.dart';
import 'package:desaihomes_crm_application/presentations/follow_ups_screen/view/widgets/followup_filter_modal.dart';
import 'package:desaihomes_crm_application/presentations/follow_ups_screen/view/widgets/followup_lead_card.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({super.key});

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  final Map<String, String?> selectedUsers = {};
  final ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isFilterApplied = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
      scrollController.addListener(scrollListener);
    });
  }

  void clearFilter() {
    setState(() {
      selectedUsers.clear();
      _isFilterApplied = false;
      Provider.of<LeadController>(context, listen: false)
          .searchController
          .clear();
      Provider.of<FollowUpController>(context, listen: false)
          .fetchData(context);
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void fetchData() async {
    await Provider.of<FollowUpController>(context, listen: false)
        .fetchData(context);
    Provider.of<FollowUpController>(context, listen: false)
        .fetchUserList(context);
    setState(() {});
  }

  void fetchMoreData() async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      await Provider.of<FollowUpController>(context, listen: false)
          .fetchMoreData(context);
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          backgroundColor: Color(0xffF0F6FF),
          hasRadius: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 0.12.sh,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: const Color(0xffF0F6FF),
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
                              valueListenable: Provider.of<FollowUpController>(
                                      context,
                                      listen: false)
                                  .searchController,
                              builder:
                                  (context, TextEditingValue value, child) {
                                return SearchBar(
                                  side: const WidgetStatePropertyAll(
                                      BorderSide(color: Color(0xffD5D7DA))),
                                  padding: WidgetStatePropertyAll(
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
                                  backgroundColor: const WidgetStatePropertyAll(
                                      Colors.white),
                                  elevation: const WidgetStatePropertyAll(0),
                                  surfaceTintColor:
                                      const WidgetStatePropertyAll(
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
                                              Icons.close,
                                              size: 18.sp,
                                              color: const Color.fromARGB(
                                                  255, 132, 132, 132),
                                            ),
                                            onPressed: () {
                                              Provider.of<FollowUpController>(
                                                      context,
                                                      listen: false)
                                                  .searchController
                                                  .clear();

                                              Provider.of<FollowUpController>(
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
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.38),
                                    ),
                                  ),
                                  controller: Provider.of<FollowUpController>(
                                          context,
                                          listen: false)
                                      .searchController,
                                  onChanged: (value) {
                                    Provider.of<FollowUpController>(context,
                                            listen: false)
                                        .searchLeads(context);
                                  },
                                  onSubmitted: (value) {
                                    Provider.of<FollowUpController>(context,
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
                              border: Border.all(
                                  color: const Color(0xffD5D7DA), width: 1)),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FollowUpFilterModal(
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Follow Up Leads",
                    style: GLTextStyles.manropeStyle(
                      size: 18.sp,
                      weight: FontWeight.w600,
                      color: const Color(0xff120e2b),
                    ),
                  ),
                  if (_isFilterApplied)
                    GestureDetector(
                      onTap: clearFilter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xff0B0D23),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8.w, right: 8.w, bottom: 4.w, top: 4.w),
                          child: Row(
                            children: [
                              Text(
                                "Remove Filter",
                                style: GLTextStyles.manropeStyle(
                                    size: 12.sp,
                                    weight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.close,
                                size: 14.sp,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
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
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // Show loader if at the end of the list and more data is available
                        if (index >=
                            (controller.leadModel.leads?.data?.length ?? 0)) {
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
                        final projectName = lead?.project?.name ?? '';
                        final sourceName = lead?.source ?? '';
                        final leadId = '${lead?.id}';

                        String formatDate(String? dateString) {
                          if (dateString == null || dateString.isEmpty)
                            return '';
                          try {
                            final date = DateTime.parse(dateString);
                            return DateFormat('dd-MM-yyyy').format(date);
                          } catch (e) {
                            return '';
                          }
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: FollowUpLeadCard(
                            name: lead?.name ?? '',
                            location: removeClassName(projectName),
                            platform: removeClassName(sourceName),
                            followupDate: formatDate(lead?.followUpDate),
                            initials: getInitials(lead?.name),
                            status: lead?.crmStatusDetails?.name ?? '',
                            users: controller.userListModel.users
                                    ?.map((user) => user.name ?? '')
                                    .toList() ??
                                [],
                            leadId: leadId,
                            userId: (controller.userListModel.users != null &&
                                    index <
                                        controller.userListModel.users!.length)
                                ? '${controller.userListModel.users![index].id}'
                                : '',
                            selectedUser: selectedUsers[leadId],
                            onUserSelected: updateSelectedUser,
                            index: index,
                            leadData: lead, 
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 14.w),
                      itemCount:
                          (controller.leadModel.leads?.data?.length ?? 0) +
                              (controller.hasMoreData ? 1 : 0),
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
