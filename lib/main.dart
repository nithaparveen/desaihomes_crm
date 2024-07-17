import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/controller/bottom_navigation_controller.dart';
import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/view/bottom_navigation_screen.dart';
import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/view/menu.dart';
import 'package:desaihomes_crm_application/presentations/dashboard_screen/controller/dashboard_controller.dart';
import 'package:desaihomes_crm_application/presentations/dashboard_screen/view/dashboard_screen.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:desaihomes_crm_application/presentations/login_screen/controller/login_controller.dart';
import 'package:desaihomes_crm_application/presentations/login_screen/view/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDVzFaruG8edoDFPEkqx790SGMrcfpcLVg",
          appId: "1:107202462728:android:613b4f0c9853d3e38a3dbd",
          messagingSenderId: "107202462728",
          projectId: "desainotifications"));
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("d3a21692-8d73-4542-94f9-bd2759c30d96");
  OneSignal.Notifications.requestPermission(true);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LoginController()),
    ChangeNotifierProvider(create: (context) => DashboardController()),
    ChangeNotifierProvider(create: (context) => LeadDetailController()),
    ChangeNotifierProvider(create: (context) => BottomNavigationController()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    String? screen;
    OneSignal.Notifications.addClickListener((event) {
      final data =  event.notification.additionalData;
      screen = data?['screen'];
      if(screen != null){
        navigatorKey.currentState?.pushNamed(screen!);
      }
    });
    return MaterialApp(
      theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.white)),
      debugShowCheckedModeBanner: false,
      routes: {
        '/homeScreen' : (context) => const BottomNavBar(),
        '/menuScreen' : (context) => const menuScreen(),
      },
      home: LoginScreen(),
    );
  }
}
