import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../lead_detail_screen/controller/lead_detail_controller.dart';

class StatusButton extends StatefulWidget {
  const StatusButton({super.key});

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchStatusList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadDetailController>(
      builder: (context, controller, _) {
        return PopupMenuButton<String>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          position: PopupMenuPosition.under,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 200,  // Fixed width for the popup menu
            maxWidth: 200,
          ),
          itemBuilder: (context) {
            return List.generate(
              controller.statusListModel.crmStatus?.length ?? 0,
              (index) {
                final status = controller.statusListModel.crmStatus?[index];
                return PopupMenuItem<String>(
                  height: 40, 
                  padding: EdgeInsets.zero,
                  value: status?.name,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(
                          'FF${status?.bgColor?.replaceFirst('#', '') ?? 'FFFFFF'}',
                          radix: 16,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      status?.name ?? 'Unknown Status',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(
                          int.parse(
                            'FF${status?.textColor?.replaceFirst('#', '') ?? 'FFFFFF'}',
                            radix: 16,
                          ),
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text(
                  "New Leads",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}