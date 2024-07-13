
import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/controller/bottom_navigation_controller.dart';
import 'package:desaihomes_crm_application/presentations/dashboard_screen/controller/dashboard_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:desaihomes_crm_application/presentations/login_screen/controller/login_controller.dart';
import 'package:desaihomes_crm_application/presentations/login_screen/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LoginController()),
    ChangeNotifierProvider(create: (context) => DashboardController()),
    ChangeNotifierProvider(create: (context) => LeadDetailController()),
    ChangeNotifierProvider(create: (context) => BottomNavigationController()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.white)
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
