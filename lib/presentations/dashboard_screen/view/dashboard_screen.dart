import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/dashboard_screen/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:another_flushbar/flushbar.dart';

import '../../lead_detail_screen/view/lead_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = -1;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    fetchData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Provider.of<DashboardController>(context, listen: false)
            .loadMoreData(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  fetchData() {
    Provider.of<DashboardController>(context, listen: false).fetchData(context);
    Provider.of<DashboardController>(context, listen: false)
        .fetchUserList(context);
  }

  String removeClassName(String input) {
    return input.replaceAll(RegExp(r'.*\.'), '');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/icons/desaihomes_icon.jpeg"),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
      ),
      endDrawer: Drawer(
        width: size.width * .75,
        child: ListView(
          children: [
            ListTile(
              splashColor: Colors.transparent,
              leading: Icon(
                Icons.leaderboard_outlined,
                color: _selectedIndex == 0 ? ColorTheme.yellow : Colors.black,
              ),
              title: Text(
                "Leads",
                style: GLTextStyles.robotoStyle(
                  size: 18,
                  weight: FontWeight.w500,
                  color: _selectedIndex == 0 ? ColorTheme.white : Colors.black,
                ),
              ),
              tileColor: _selectedIndex == 0 ? ColorTheme.lightBlue : null,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              leading: Icon(
                Icons.warning_amber,
                color: _selectedIndex == 1 ? ColorTheme.yellow : Colors.black,
              ),
              title: Text(
                "Triage Leads",
                style: GLTextStyles.robotoStyle(
                  size: 18,
                  weight: FontWeight.w500,
                  color: _selectedIndex == 1 ? ColorTheme.white : Colors.black,
                ),
              ),
              tileColor: _selectedIndex == 1 ? ColorTheme.lightBlue : null,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              splashColor: Colors.transparent,
            ),
            ListTile(
              leading: Icon(
                Icons.campaign,
                color: _selectedIndex == 2 ? ColorTheme.yellow : Colors.black,
              ),
              title: Text(
                "Campaigns",
                style: GLTextStyles.robotoStyle(
                  size: 18,
                  weight: FontWeight.w500,
                  color: _selectedIndex == 2 ? ColorTheme.white : Colors.black,
                ),
              ),
              tileColor: _selectedIndex == 2 ? ColorTheme.lightBlue : null,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              splashColor: Colors.transparent,
            ),
            ListTile(
              leading: Icon(
                Icons.sticky_note_2_outlined,
                color: _selectedIndex == 3 ? ColorTheme.yellow : Colors.black,
              ),
              title: Text(
                "Follow Ups",
                style: GLTextStyles.robotoStyle(
                  size: 18,
                  weight: FontWeight.w500,
                  color: _selectedIndex == 3 ? ColorTheme.white : Colors.black,
                ),
              ),
              tileColor: _selectedIndex == 3 ? ColorTheme.lightBlue : null,
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
              },
              splashColor: Colors.transparent,
            ),
            ListTile(
              leading: Icon(
                Icons.pin_drop_outlined,
                color: _selectedIndex == 4 ? ColorTheme.yellow : Colors.black,
              ),
              title: Text(
                "Site Visits",
                style: GLTextStyles.robotoStyle(
                  size: 18,
                  weight: FontWeight.w500,
                  color: _selectedIndex == 4 ? ColorTheme.white : Colors.black,
                ),
              ),
              tileColor: _selectedIndex == 4 ? ColorTheme.lightBlue : null,
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
              },
              splashColor: Colors.transparent,
            ),
            ListTile(
              leading: Icon(
                Icons.article_outlined,
                color: _selectedIndex == 5 ? ColorTheme.yellow : Colors.black,
              ),
              title: Text(
                "Reports",
                style: GLTextStyles.robotoStyle(
                  size: 18,
                  weight: FontWeight.w500,
                  color: _selectedIndex == 5 ? ColorTheme.white : Colors.black,
                ),
              ),
              tileColor: _selectedIndex == 5 ? ColorTheme.lightBlue : null,
              onTap: () {
                setState(() {
                  _selectedIndex = 5;
                });
              },
              splashColor: Colors.transparent,
            ),
            ListTile(
              leading: Icon(
                Icons.label_outline,
                color: _selectedIndex == 6 ? ColorTheme.yellow : Colors.black,
              ),
              title: Text(
                "Labels",
                style: GLTextStyles.robotoStyle(
                  size: 18,
                  weight: FontWeight.w500,
                  color: _selectedIndex == 6 ? ColorTheme.white : Colors.black,
                ),
              ),
              tileColor: _selectedIndex == 6 ? ColorTheme.lightBlue : null,
              onTap: () {
                setState(() {
                  _selectedIndex = 6;
                });
              },
              splashColor: Colors.transparent,
            ),
            ListTile(
              leading: Icon(
                Icons.archive_outlined,
                color: _selectedIndex == 7 ? ColorTheme.yellow : Colors.black,
              ),
              title: Text(
                "Archived Leads",
                style: GLTextStyles.robotoStyle(
                  size: 18,
                  weight: FontWeight.w500,
                  color: _selectedIndex == 7 ? ColorTheme.white : Colors.black,
                ),
              ),
              tileColor: _selectedIndex == 7 ? ColorTheme.lightBlue : null,
              onTap: () {
                setState(() {
                  _selectedIndex = 7;
                });
              },
              splashColor: Colors.transparent,
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: _selectedIndex == 8 ? ColorTheme.yellow : Colors.black,
              ),
              title: Text(
                "Recycle Bin",
                style: GLTextStyles.robotoStyle(
                  size: 18,
                  weight: FontWeight.w500,
                  color: _selectedIndex == 8 ? ColorTheme.white : Colors.black,
                ),
              ),
              tileColor: _selectedIndex == 8 ? ColorTheme.lightBlue : null,
              onTap: () {
                setState(() {
                  _selectedIndex = 8;
                });
              },
              splashColor: Colors.transparent,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<DashboardController>(context, listen: false)
              .fetchData(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                  "Leads",
                  style: GLTextStyles.robotoStyle(
                      size: 22, weight: FontWeight.w500),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: size.width * .02,
                ),
              ),
              Consumer<DashboardController>(builder: (context, controller, _) {
                return controller.isLoading
                    ? const SliverToBoxAdapter(
                        child: Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.grey,
                        )),
                      )
                    : SliverList.separated(
                        itemCount: controller.isLoadingMore
                            ? controller.dashboardModel.leads!.data!.length + 1
                            : controller.dashboardModel.leads?.data?.length,
                        itemBuilder: (context, index) {
                          if (index >=
                              controller.dashboardModel.leads!.data!.length) {
                            return const Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Colors.grey,
                            ));
                          }

                          final projectName = controller
                              .dashboardModel.leads?.data?[index].project?.name
                              .toString();
                          final sourceName = controller
                              .dashboardModel.leads?.data?[index].source
                              .toString();
                          final id = controller
                              .dashboardModel.leads?.data?[index].id
                              ?.toInt();

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LeadDetailScreen(id: id),
                                  ));
                            },
                            child: Card(
                              surfaceTintColor: ColorTheme.white,
                              elevation: 2,
                              margin: const EdgeInsets.all(6),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${controller.dashboardModel.leads?.data?[index].name}",
                                              style: GLTextStyles.robotoStyle(
                                                  size: 16,
                                                  weight: FontWeight.w500)),
                                          const SizedBox(height: 4),
                                          Text(
                                              projectName != null
                                                  ? removeClassName(projectName)
                                                  : '',
                                              style: GLTextStyles.robotoStyle(
                                                  size: 15,
                                                  weight: FontWeight.w400)),
                                          const SizedBox(height: 4),
                                          Text(
                                              sourceName != null
                                                  ? removeClassName(sourceName)
                                                  : '',
                                              style: GLTextStyles.robotoStyle(
                                                  size: 15,
                                                  weight: FontWeight.w400)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: PopupMenuButton(
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return [
                                                  PopupMenuItem(
                                                    child: Container(
                                                      decoration:
                                                          ShapeDecoration(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                      height: size.width * .75,
                                                      width: size.width * .4,
                                                      child: Scrollbar(
                                                        thickness: 2,
                                                        radius: const Radius
                                                            .circular(15),
                                                        child: ListView.builder(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          itemCount: controller
                                                              .userListModel
                                                              .users
                                                              ?.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              title: Text(
                                                                "${controller.userListModel.users?[index].name}",
                                                                style: GLTextStyles
                                                                    .cabinStyle(
                                                                        size:
                                                                            14),
                                                              ),
                                                              onTap: () async {
                                                                final dashboardController =
                                                                    Provider.of<
                                                                            DashboardController>(
                                                                        context,
                                                                        listen:
                                                                            false);

                                                                dashboardController
                                                                    .assignedToTapped(
                                                                  id.toString(),
                                                                  "${controller.userListModel.users?[index].id}",
                                                                  context,
                                                                );

                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          LeadDetailScreen(
                                                                              id: id),
                                                                    ));
                                                                await dashboardController
                                                                    .fetchData(
                                                                        context);
                                                                Flushbar(
                                                                  maxWidth:
                                                                      size.width *
                                                                          .55,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey
                                                                          .shade100,
                                                                  messageColor:
                                                                      ColorTheme
                                                                          .black,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .done_outline,
                                                                    color: ColorTheme
                                                                        .green,
                                                                    size: 20,
                                                                  ),
                                                                  message:
                                                                      'Assign Successful',
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              3),
                                                                  flushbarPosition:
                                                                      FlushbarPosition
                                                                          .TOP,
                                                                ).show(context);
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ];
                                              },
                                              elevation: 0.5,
                                              child: controller
                                                          .dashboardModel
                                                          .leads
                                                          ?.data?[index]
                                                          .assignedTo ==
                                                      null
                                                  ? CircleAvatar(
                                                      radius: 22,
                                                      backgroundColor:
                                                          ColorTheme.yellow,
                                                      child: const Icon(
                                                        Icons.person_add_alt,
                                                        size: 22,
                                                      ),
                                                    )
                                                  : Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 8),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            ColorTheme.yellow,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Text(
                                                          "${controller.dashboardModel.leads?.data?[index].assignedToDetails?.name}"),
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.orange[100],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Text(
                                                GetTimeAgo.parse(DateTime.parse(
                                                    "${controller.dashboardModel.leads?.data?[index].updatedAt}")),
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: size.width * .02,
                          );
                        },
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}
