import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../lead_detail_screen/view/lead_detail_screen.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
  int selectedIndex = -1;
  final ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;

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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
        title: Text(
          "Leads",
          style: GLTextStyles.robotoStyle(size: 22, weight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<LeadController>(context, listen: false)
              .fetchData(context);
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: size.width * .02,
                ),
              ),
              Consumer<LeadController>(
                builder: (context, controller, _) {
                  return controller.isLoading
                      ? const SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : SliverList.separated(
                          itemCount: controller.isLoadingMore
                              ? controller.leadModel.leads!.data!.length + 1
                              : controller.leadModel.leads?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            if (index >=
                                controller.leadModel.leads!.data!.length) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  color: Colors.grey,
                                ),
                              );
                            }
                            final projectName = controller
                                .leadModel.leads?.data?[index].project?.name
                                .toString();
                            final sourceName = controller
                                .leadModel.leads?.data?[index].source
                                .toString();
                            final id = controller
                                .leadModel.leads?.data?[index].id
                                ?.toInt();

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
                                                "${controller.leadModel.leads?.data?[index].name}",
                                                style: GLTextStyles.robotoStyle(
                                                    size: 16,
                                                    weight: FontWeight.w500)),
                                            const SizedBox(height: 4),
                                            Text(
                                                projectName != null
                                                    ? removeClassName(
                                                        projectName)
                                                    : '',
                                                style: GLTextStyles.robotoStyle(
                                                    size: 15,
                                                    weight: FontWeight.w400)),
                                            const SizedBox(height: 4),
                                            Text(
                                                sourceName != null
                                                    ? removeClassName(
                                                        sourceName)
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
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                        height:
                                                            size.width * .75,
                                                        width: size.width * .4,
                                                        child: Scrollbar(
                                                          thickness: 2,
                                                          radius: const Radius
                                                              .circular(15),
                                                          child:
                                                              ListView.builder(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5),
                                                            itemCount: controller
                                                                .userListModel
                                                                .users
                                                                ?.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ListTile(
                                                                title: Text(
                                                                  "${controller.userListModel.users?[index].name}",
                                                                  style: GLTextStyles
                                                                      .cabinStyle(
                                                                          size:
                                                                              14),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  final dashboardController = Provider.of<
                                                                          LeadController>(
                                                                      context,
                                                                      listen:
                                                                          false);

                                                                  dashboardController
                                                                      .assignedToTapped(
                                                                    id.toString(),
                                                                    "${controller.userListModel.users?[index].id}",
                                                                    context,
                                                                  );

                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              LeadDetailScreen(
                                                                        leadId:
                                                                            id,
                                                                      ),
                                                                    ),
                                                                  );
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
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            3),
                                                                    flushbarPosition:
                                                                        FlushbarPosition
                                                                            .TOP,
                                                                  ).show(
                                                                      context);
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
                                                            .leadModel
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
                                                        margin: const EdgeInsets
                                                            .only(top: 8),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8,
                                                                vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              ColorTheme.yellow,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Text(
                                                            "${controller.leadModel.leads?.data?[index].assignedToDetails?.name}"),
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.orange[100],
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                  GetTimeAgo.parse(DateTime.parse(
                                                      "${controller.leadModel.leads?.data?[index].updatedAt}")),
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
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
