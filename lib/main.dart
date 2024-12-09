import 'dart:developer';
import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/controller/bottom_navigation_controller.dart';
import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/view/bottom_navigation_screen.dart';
import 'package:desaihomes_crm_application/presentations/follow_ups_screen/controller/follow_up_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/view/lead_detail_screen_copy.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:desaihomes_crm_application/presentations/login_screen/controller/login_controller.dart';
import 'package:desaihomes_crm_application/presentations/reports_screen/controller/reports_controller.dart';
import 'package:desaihomes_crm_application/presentations/splash_screen/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? loggedIn = prefs.getBool(AppConfig.loggedIn);
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => LeadController()),
        ChangeNotifierProvider(create: (context) => LeadDetailController()),
        ChangeNotifierProvider(
            create: (context) => BottomNavigationController()),
        ChangeNotifierProvider(create: (context) => ReportsController()),
        ChangeNotifierProvider(create: (context) => FollowUpController()),
      ],
      child: MyApp(
        isLoggedIn: loggedIn ?? false,
      )));
  initOneSignal();
}

Future<void> initOneSignal() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("d3a21692-8d73-4542-94f9-bd2759c30d96");
  await OneSignal.Notifications.requestPermission(true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    onClickOneSignal();
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (_, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            theme:
                ThemeData(appBarTheme: const AppBarTheme(color: Colors.white)),
            debugShowCheckedModeBanner: false,
            home: isLoggedIn ? const BottomNavBar() : const SplashScreen(),
          );
        });
  }

  void onClickOneSignal() {
    int? leadId;
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      leadId = data?['lead_id'];
      if (leadId != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => LeadDetailScreenCopy(
              leadId: leadId,
            ),
          ),
        );
      }
      log("DATA =====> $leadId");
      final id = OneSignal.User.pushSubscription.id;
      log("############### $id");
    });
  }
}
