import 'dart:convert';
import 'dart:developer';
import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/view/bottom_navigation_screen.dart';
import 'package:desaihomes_crm_application/repository/api/login_screen/service/login_service.dart';
import 'package:flutter/material.dart';
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
      } else {
        log("Else Condition >> Api failed");
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
      sharedPreferences.setString(
          'name', loginReceivedData["user"]['name']);
    }
  }

  void storeUserToken(resData) async {
    log("storeUserToken");
    sharedPreferences = await SharedPreferences.getInstance();
    String dataUser = json.encode(resData);
    sharedPreferences.setString(AppConfig.token, dataUser);
  }
}
