import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/follow_ups_screen/view/follow_ups_screen.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/lead_screen_copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../lead_screen/view/lead_screen.dart';
import '../controller/bottom_navigation_controller.dart';
import 'menu.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
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
      extendBody: true,
      body: Consumer<BottomNavigationController>(
        builder: (context, provider, child) {
          return IndexedStack(
            index: provider.selectedIndex,
            children: const [
              LeadScreen(),
              FollowUpScreen(),
              LeadScreenCopy(),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<BottomNavigationController>(
        builder: (context, controller, _) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 23.w, horizontal: 19.h),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF001524),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildNavItem(
                    context,
                    index: 0,
                    icon: Iconsax.convertshape_2,
                    label: 'Leads',
                    controller: controller,
                  ),
                  buildNavItem(
                    context,
                    index: 1,
                    icon: Icons.menu,
                    label: 'Follow-Ups',
                    controller: controller,
                  ),
                  buildNavItem(
                    context,
                    index: 2,
                    icon: Icons.insert_chart_outlined,
                    label: 'Reports',
                    controller: controller,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required BottomNavigationController controller,
  }) {
    final isSelected = controller.selectedIndex == index;

    return GestureDetector(
      onTap: () {
        controller.selectedIndex = index;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3AA076) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
              size: isSelected ? 19.sp : 18.sp,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GLTextStyles.manropeStyle(
                size: isSelected ? 15.sp : 14.sp,
                weight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
