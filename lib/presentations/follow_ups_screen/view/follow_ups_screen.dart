import 'dart:convert';

import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowUpScreen extends StatelessWidget {
  const FollowUpScreen({super.key});

  Future<String?> getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? storedData = sharedPreferences.getString(AppConfig.loginData);

    if (storedData != null) {
      var loginData = jsonDecode(storedData);
      if (loginData["user"] != null && loginData["user"]['name'] != null) {
        return loginData["user"]['name'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.h),
        child: AppBar(
          backgroundColor: ColorTheme.desaiGreen,
          foregroundColor: ColorTheme.desaiGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          title: FutureBuilder<String?>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text("Unknown User");
              }
              String userName = snapshot.data ?? "Unknown User";
              return Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 202, 158, 208),
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.5, color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        userName.substring(0, 2).toUpperCase(),
                        style: GLTextStyles.robotoStyle(
                          color: ColorTheme.blue,
                          size: 13.sp,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    userName,
                    style: GLTextStyles.manropeStyle(
                      color: ColorTheme.white,
                      size: 14.sp,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
          actions: const [LogoutButton()],
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
