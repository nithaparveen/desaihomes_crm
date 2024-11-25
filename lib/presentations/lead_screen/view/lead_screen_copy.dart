import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/logout_button.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/filter_modal.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/lead_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:get_time_ago/get_time_ago.dart';
import '../../lead_detail_screen/view/lead_detail_screen.dart';

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

  @override
  void dispose() {
    scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.desaiGreen,
        title: Row(
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
                  "AJ",
                  style: GLTextStyles.robotoStyle(
                    color: ColorTheme.blue,
                    size: 13,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Akhil Joy",
              style: GLTextStyles.manropeStyle(
                color: ColorTheme.white,
                size: 14,
                weight: FontWeight.w600,
              ),
            )
          ],
        ),
        actions: const [LogoutButton()],
        automaticallyImplyLeading: false,
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
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 0.75.sw,
                        height: 0.13.sw,
                        child: SearchBar(
                          hintText: "Search ...",
                          hintStyle: MaterialStatePropertyAll(
                            GLTextStyles.manropeStyle(
                              size: 13,
                              weight: FontWeight.w400,
                              color: const Color(0xffABB7C2),
                            ),
                          ),
                          elevation: const MaterialStatePropertyAll(0),
                          surfaceTintColor:
                              const MaterialStatePropertyAll(Colors.white),
                          leading: const Icon(
                            Iconsax.search_normal_1,
                            size: 18,
                            color: Color(0xffABB7C2),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.38),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(7.38),
                        ),
                        child: Center(
                            child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const FilterModal();
                              },
                            );
                          },
                          icon: const Icon(
                            Iconsax.setting_5,
                            size: 18,
                            color: Color(0xffABB7C2),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              "Leads",
              style: GLTextStyles.manropeStyle(
                size: 18,
                weight: FontWeight.w600,
                color: const Color(0xff120e2b),
              ),
            ),
          ),
          Expanded(
            child: Consumer<LeadController>(
              builder: (context, controller, _) {
                if (controller.leadModel.leads?.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    if (index >= controller.leadModel.leads!.data!.length) {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.grey,
                        ),
                      );
                    }

                    final lead = controller.leadModel.leads?.data?[index];
                    final projectName = lead?.project?.name.toString();
                    final sourceName = lead?.source.toString();
                    final id = lead?.id?.toInt();
                    final leadId = '${lead?.id}';

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeadDetailScreen(
                              leadId: id,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
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
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 14.w),
                  itemCount: controller.isLoadingMore
                      ? controller.leadModel.leads!.data!.length + 1
                      : controller.leadModel.leads?.data?.length ?? 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
