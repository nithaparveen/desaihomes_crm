import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/view/bottom_navigation_screen.dart';
import 'package:desaihomes_crm_application/presentations/dashboard_screen/view/dashboard_screen.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/textstyles.dart';
import '../../dashboard_screen/controller/dashboard_controller.dart';

class LeadDetailScreen extends StatefulWidget {
  const LeadDetailScreen({
    super.key,
    required this.id,
  });

  final int? id;

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() {
    Provider.of<LeadDetailController>(context, listen: false)
        .fetchDetailData(widget.id, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Details",
          style: GLTextStyles.robotoStyle(size: 22, weight: FontWeight.w500),
        ),
        leading: IconButton(
            onPressed: () {
              Provider.of<DashboardController>(context, listen: false)
                  .fetchData(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(),
                  ));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Consumer<LeadDetailController>(builder: (context, controller, _) {
            return Container(
              // surfaceTintColor: ColorTheme.white,
              // elevation: 0,
              margin: const EdgeInsets.all(6),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${controller.leadDetailModel.lead?.name}",
                              style: GLTextStyles.robotoStyle(
                                  size: 16, weight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                              "${controller.leadDetailModel.lead?.project?.name}",
                              style: GLTextStyles.robotoStyle(
                                  size: 15, weight: FontWeight.w400)),
                          const SizedBox(height: 4),
                          Text("${controller.leadDetailModel.lead?.source}",
                              style: GLTextStyles.robotoStyle(
                                  size: 15, weight: FontWeight.w400)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: controller
                                        .leadDetailModel.lead?.assignedTo ==
                                    null
                                ? null
                                : Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: ColorTheme.yellow,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                        "${controller.leadDetailModel.lead?.assignedToDetails?.name}"),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                                GetTimeAgo.parse(DateTime.parse(
                                    "${controller.leadDetailModel.lead?.updatedAt}")),
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
