import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/follow_ups_screen/view/follow_ups_screen.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/lead_screen_copy.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../controller/bottom_navigation_controller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final NotchBottomBarController notchBottomBarController =
      NotchBottomBarController(index: 0);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BottomNavigationController>(context, listen: false)
          .selectedIndex = 0;
    });
    super.initState();
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
              FollowUpScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<BottomNavigationController>(
        builder: (context, controller, _) {
          return AnimatedNotchBottomBar(
            notchBottomBarController: notchBottomBarController,
            kIconSize: 24.0,
            kBottomRadius: 28.0,
            color: const Color(0xff001524),
            showLabel: true,
            notchColor: ColorTheme.desaiGreen,
            durationInMilliSeconds: 300,
            itemLabelStyle: GLTextStyles.manropeStyle(
              color: ColorTheme.white,
              size: 12,
              weight: FontWeight.w400,
            ),
            bottomBarItems: [
              BottomBarItem(
                inActiveItem:
                    const Icon(Iconsax.convertshape_2, color: Colors.white),
                activeItem:
                    Icon(Iconsax.convertshape_2, color: ColorTheme.white),
                itemLabel: "Leads",
              ),
              BottomBarItem(
                inActiveItem: const Icon(Iconsax.grid_5, color: Colors.white),
                activeItem: Icon(Iconsax.grid_5, color: ColorTheme.white),
                itemLabel: "Follow-Ups",
              ),
              BottomBarItem(
                inActiveItem: const Icon(Iconsax.chart_2, color: Colors.white),
                activeItem: Icon(Iconsax.chart_2, color: ColorTheme.white),
                itemLabel: "Reports",
              ),
            ],
            onTap: (index) {
              controller.selectedIndex = index;
              notchBottomBarController.index = index;
            },
          );
        },
      ),
    );
  }
}
