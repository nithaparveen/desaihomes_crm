import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/follow_ups_screen/view/follow_ups_screen.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/lead_screen_copy.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/view/reports_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../new_whatsapp_screen/view/new_whatsapp_screen.dart';
import '../controller/bottom_navigation_controller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final NotchBottomBarController notchBottomBarController =
      NotchBottomBarController(index: 0);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static List pageNames = [
    "LeadScreen",
    "FollowUpScreen",
    "ReportsScreen",
    "WhatsappScreen"
  ];

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
    ].request();

    if (statuses[Permission.phone]!.isGranted) {}
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BottomNavigationController>(context, listen: false)
          .selectedIndex = 0;
    });
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<BottomNavigationController>(
        builder: (context, provider, child) {
          return IndexedStack(
            index: provider.selectedIndex,
            children: const [
              LeadScreenCopy(),
              FollowUpScreen(),
              ReportsScreen(),
              WhatsappScreenCopy()
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<BottomNavigationController>(
        builder: (context, controller, _) {
          return AnimatedNotchBottomBar(
            notchBottomBarController: notchBottomBarController,
            kIconSize: 20,
            kBottomRadius: 30.r,
            color: const Color(0xff001524),
            showLabel: true,
            notchColor: ColorTheme.desaiGreen,
            durationInMilliSeconds: 300,
            itemLabelStyle: GLTextStyles.manropeStyle(
              color: ColorTheme.white,
              size: 12.sp,
              weight: FontWeight.w400,
            ),
            bottomBarItems: [
              BottomBarItem(
                inActiveItem: Icon(
                  Iconsax.convertshape_2,
                  color: Colors.white,
                  size: 22.sp,
                ),
                activeItem: Icon(Iconsax.convertshape_2,
                    color: ColorTheme.white, size: 22.sp),
                itemLabel: "Leads",
              ),
              BottomBarItem(
                inActiveItem:
                    Icon(Iconsax.grid_5, color: Colors.white, size: 22.sp),
                activeItem:
                    Icon(Iconsax.grid_5, color: ColorTheme.white, size: 22.sp),
                itemLabel: "Followups",
              ),
              BottomBarItem(
                inActiveItem:
                    Icon(Iconsax.chart_2, color: Colors.white, size: 22.sp),
                activeItem:
                    Icon(Iconsax.chart_2, color: ColorTheme.white, size: 22.sp),
                itemLabel: "Reports",
              ),
              BottomBarItem(
                inActiveItem: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 22.sp,
                ),
                activeItem: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: ColorTheme.white,
                  size: 22.sp,
                ),
                itemLabel: "WhatsApp",
              ),
            ],
            onTap: (index) {
              analytics.logEvent(name: 'pages_tracked', parameters: {
                "page_name": pageNames[index],
                "page_index": index
              });
              controller.selectedIndex = index;
              notchBottomBarController.index = index;
            },
          );
        },
      ),
    );
  }
}
