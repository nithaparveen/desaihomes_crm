import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_button.dart';
import 'package:desaihomes_crm_application/presentations/bottom_navigation_screen/view/bottom_navigation_screen.dart';
import 'package:desaihomes_crm_application/repository/api/login_screen/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app_config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

class LoginController extends ChangeNotifier {
  bool visibility = true;
  late SharedPreferences sharedPreferences;

  Future onLogin(String email, String password, BuildContext context) async {
    log("loginController -> onLogin() started");

    if (email.isEmpty || password.isEmpty) {
      Flushbar(
        maxWidth: .55.sw,
        backgroundColor: Colors.grey.shade100,
        messageColor: ColorTheme.black,
        icon: Icon(
          Iconsax.info_circle,
          color: ColorTheme.red,
          size: 20.sp,
        ),
        message: 'Please fill in all fields',
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
      return;
    }

    LoginService.postLoginData(email, password).then((value) {
      if (value["status"] == true) {
        log("token -> ${value["token"]}");
        storeLoginData(value);
        storeUserToken(value["token"]);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false,
        );
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

  Future<void> checkForAppUpdates(BuildContext context) async {
    log("Checking for app updates...");
    var versionData = await LoginService.checkAppVersion();

    if (versionData != null && versionData["version_name"] != null) {
      String latestVersion = versionData["version_name"];
      String token = versionData["token"];

      String currentVersion = AppConfig.currentVersion;
      log("Current version: $currentVersion, Latest version: $latestVersion");
      if (currentVersion != latestVersion) {
        log("New version available: $latestVersion");
        showUpdatePopup(context, latestVersion, token);
      } else {
        log("App is up to date");
      }
    } else {
      log("Failed to fetch version information.");
    }
  }

  void showUpdatePopup(
      BuildContext context, String latestVersion, String token) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: (50 / ScreenUtil().screenWidth).sw,
                height: (50 / ScreenUtil().screenHeight).sh,
                decoration: BoxDecoration(
                  color: const Color(0xffA8E9D2),
                  shape: BoxShape.circle,
                  border:
                      Border.all(width: 4.5, color: const Color(0xffE2FFF5)),
                ),
                child: Center(
                    child: Icon(
                  Iconsax.frame,
                  color: const Color(0xff3D9073),
                  size: 20.sp,
                )),
              ),
              SizedBox(height: 8.h),
              Text(
                'Update Available',
                style: GLTextStyles.manropeStyle(
                  color: ColorTheme.black,
                  size: 18.sp,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            "A new version ($latestVersion) is available. Please update to continue.",
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.blue,
              size: 13.sp,
              weight: FontWeight.w400,
            ),
          ),
          actions: [
            CustomButton(
              borderColor: ColorTheme.white,
              backgroundColor: ColorTheme.desaiGreen,
              text: "UPDATE",
              textColor: Colors.white,
              width: (110 / ScreenUtil().screenWidth).sw,
              onPressed: () async {
                Navigator.of(context).pop();
                await downloadAndInstallApk(latestVersion, token, context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> downloadAndInstallApk(
      String versionName, String token, BuildContext context) async {
    String downloadUrl =
        "https://www.desaihomes.com/api/app/version/view/$token?version_name=$versionName";

    String timestamp =
        DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    Directory? baseDirectory = await getExternalStorageDirectory();
    if (baseDirectory == null) {
      log("Unable to access storage directory");
      return;
    }
    String downloadsPath = "/storage/emulated/0/Download";
    String savePath = "$downloadsPath/app-release-$timestamp.apk";
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    var snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        "Downloading update...",
        style: GLTextStyles.manropeStyle(
          color: ColorTheme.desaiGreen,
          size: 12.sp,
          weight: FontWeight.w500,
        ),
      ),
      duration: const Duration(days: 1),
    );
    scaffoldMessenger.showSnackBar(snackBar);
    final response = await http.get(Uri.parse(downloadUrl));
    if (response.statusCode == 200) {
      var downloadData = jsonDecode(response.body);
      String filePath = downloadData["file_path"];
      bool success = await LoginService.downloadApk(filePath, savePath);
      scaffoldMessenger.hideCurrentSnackBar();

      if (success) {
        log("APK downloaded successfully.");
        scaffoldMessenger.showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              "The new APK has been successfully downloaded to the Downloads folder",
              style: GLTextStyles.manropeStyle(
                color: ColorTheme.desaiGreen,
                size: 12.sp,
                weight: FontWeight.w500,
              ),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
        Future.delayed(const Duration(seconds: 3), () async {
          SystemNavigator.pop();
          OpenFile.open(downloadsPath);
        });
      } else {
        log("Failed to download APK.");
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text("Failed to download the update.",
                style: GLTextStyles.manropeStyle(
                  color: ColorTheme.white,
                  size: 12.sp,
                  weight: FontWeight.w400,
                )),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
