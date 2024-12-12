import 'dart:convert';
import 'dart:developer';
import 'package:another_flushbar/flushbar.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/view/bottom_navigation_screen.dart';
import 'package:desaihomes_crm_application/repository/api/login_screen/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app_config/app_config.dart';

class LoginController extends ChangeNotifier {
  bool visibility = true;
  late SharedPreferences sharedPreferences;

  Future onLogin(String email, String password, BuildContext context) async {
    log("loginController -> onLogin() started");
    LoginService.postLoginData(email, password).then((value) {
      if (value["status"] == true) {
        log("token -> ${value["token"]} ");
        storeLoginData(value);
        storeUserToken(value["token"]);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false);
        Flushbar(
          maxWidth: .45.sw,
          backgroundColor: Colors.grey.shade100,
          messageColor: ColorTheme.black,
          icon: Icon(
            Iconsax.tick_circle,
            color: ColorTheme.green,
            size: 20.sp,
          ),
          message: 'Login successful',
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      } else {
        Flushbar(
          maxWidth: .55.sw,
          backgroundColor: Colors.grey.shade100,
          messageColor: ColorTheme.black,
          icon: Icon(
            Iconsax.close_circle,
            color: ColorTheme.red,
            size: 20.sp,
          ),
          message: 'Invalid credentials',
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      }
    });
  }

  void onPressed() {
    visibility = !visibility;
    notifyListeners();
  }

  void storeLoginData(loginReceivedData) async {
    log("storeLoginData");
    sharedPreferences = await SharedPreferences.getInstance();
    String storeData = jsonEncode(loginReceivedData);
    sharedPreferences.setString(AppConfig.loginData, storeData);
    sharedPreferences.setBool(AppConfig.loggedIn, true);
    if (loginReceivedData["user"] != null &&
        loginReceivedData["user"]['name'] != null) {
      sharedPreferences.setString('name', loginReceivedData["user"]['name']);
    }
  }

  void storeUserToken(resData) async {
    log("storeUserToken");
    sharedPreferences = await SharedPreferences.getInstance();
    String dataUser = json.encode(resData);
    sharedPreferences.setString(AppConfig.token, dataUser);
  }
}
