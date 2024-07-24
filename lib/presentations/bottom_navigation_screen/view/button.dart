import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/textstyles.dart';
import '../../lead_detail_screen/controller/lead_detail_controller.dart';

class StatusButton extends StatefulWidget {
  const StatusButton({super.key});

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchStatusList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Consumer<LeadDetailController>(builder: (context, controller, _) {
          return PopupMenuButton(
            itemBuilder: (context) {
              var size = MediaQuery.sizeOf(context);
              return [
                PopupMenuItem(
                    child: Container(
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  height: size.width * .75,
                  width: size.width * .4,
                  child: Scrollbar(
                    thickness: 2,
                    radius: const Radius.circular(15),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 5),
                      itemCount: controller.statusListModel.crmStatus?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Color(controller.statusListModel
                              .crmStatus?[index].bgColor as int),
                          title: Text(
                            "${controller.statusListModel.crmStatus?[index].name}",
                            style: GLTextStyles.cabinStyle(size: 14),
                          ),
                        );
                      },
                    ),
                  ),
                ))
              ];
            },
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {},
              color: const Color(0xff23ccfe),
              child: const Text(
                "New Leads",
                style: TextStyle(color: Color(0xff6962f7)),
              ),
            ),
          );
        }),
      ),
    );
  }
}
