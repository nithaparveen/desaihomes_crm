import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/textstyles.dart';
import '../../dashboard_screen/view/dashboard_screen.dart';
import '../controller/bottom_navigation_controller.dart';
import 'menu.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  void initState() {
    Provider.of<BottomNavigationController>(context, listen: false)
        .selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; // Corrected MediaQuery usage
    return Scaffold(
      extendBody: true,
      body: Consumer<BottomNavigationController>(
        builder: (context, provider, child) {
          return IndexedStack(
            index: provider.selectedIndex,
            children: const [DashboardScreen(), menuScreen(), menuScreen()],
          );
        },
      ),
      bottomNavigationBar: Consumer<BottomNavigationController>(
        builder: (context, controller, _) {
          return Theme(
            data: ThemeData(splashColor: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(42),
                child: SizedBox(
                  height: size.width * 0.18,
                  child: BottomNavigationBar(
                    selectedItemColor: ColorTheme.blue,
                    unselectedItemColor: Colors.grey,
                    selectedLabelStyle: GLTextStyles.cabinStyle(
                        color: ColorTheme.blue, size: 10),
                    unselectedLabelStyle:
                        GLTextStyles.cabinStyle(color: Colors.grey, size: 10),
                    backgroundColor: Colors.orange[50],
                    currentIndex: controller.selectedIndex,
                    onTap: (index) {
                      setState(() {
                        controller.selectedIndex = index;
                      });
                    },
                    elevation: 0,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard_outlined),
                        label: 'Leads',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.label_off_outlined),
                        label: 'menu',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.label_off_outlined),
                        label: 'menu',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
