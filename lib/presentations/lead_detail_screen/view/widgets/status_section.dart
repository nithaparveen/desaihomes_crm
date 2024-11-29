import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';

class StatusSection extends StatefulWidget {
 

  const StatusSection({
    super.key,
    
  });

  @override
  _StatusSectionState createState() => _StatusSectionState();
}

class _StatusSectionState extends State<StatusSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelStyle: GLTextStyles.cabinStyle(size: 16, weight: FontWeight.w600),
              unselectedLabelStyle: GLTextStyles.cabinStyle(size: 16),
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: "Overview"),
                Tab(text: "Source"),
                Tab(text: "Extra Data"),
                Tab(text: "Site Visits"),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200, // Adjust based on your content
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Overview
                  // _buildDetailsSection(widget.details1, widget.getStatusValue),
                  // Tab 2: Source
                  Center(child: Text("Source Content Here")),
                  // Tab 3: Extra Data
                  Center(child: Text("Extra Data Content Here")),
                  // Tab 4: Site Visits
                  Center(child: Text("Site Visits Content Here")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(
    List<String> details,
    String Function(LeadDetailController, int) getValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        details.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(details[index],
                      style: GLTextStyles.cabinStyle(size: 18)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Wrap(
                    children: [
                      Text(
                        ": ",
                        style: GLTextStyles.cabinStyle(
                            size: 18, weight: FontWeight.w500),
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
