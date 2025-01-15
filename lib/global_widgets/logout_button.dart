import 'dart:developer';
import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_button.dart';
import 'package:desaihomes_crm_application/presentations/login_screen/view/login_screen_copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => _showLogoutConfirmation(context),
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.logout,
              color: Colors.black,
              size: 16.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              "Logout",
              style: GLTextStyles.manropeStyle(
                color: ColorTheme.black,
                size: 13.sp,
                weight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    log("Logout");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(AppConfig.token);
    await sharedPreferences.setBool(AppConfig.loggedIn, false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreenCopy()),
      (route) => false,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
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
                  color: const Color(0xffFEE4E2),
                  shape: BoxShape.circle,
                  border:
                      Border.all(width: 4.5, color: const Color(0xffFEF3F2)),
                ),
                child: Center(
                    child: Icon(
                  Iconsax.user,
                  color: Color(0xffF9A7A4),
                  size: 20.sp,
                )),
              ),
              SizedBox(height: 8.h),
              Text(
                'Confirm Logout',
                style: GLTextStyles.manropeStyle(
                  color: ColorTheme.black,
                  size: 18.sp,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.blue,
              size: 15.sp,
              weight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            CustomButton(
              borderColor: ColorTheme.logoutRed,
              backgroundColor: ColorTheme.white,
              text: "Cancel",
              textColor: ColorTheme.logoutRed,
              onPressed: () => Navigator.of(context).pop(),
              width: (110 / ScreenUtil().screenWidth).sw,
            ),
            CustomButton(
              borderColor: ColorTheme.white,
              backgroundColor: ColorTheme.logoutRed,
              text: "Confirm",
              textColor: Colors.white,
              width: (110 / ScreenUtil().screenWidth).sw,
              onPressed: () async {
                Navigator.of(context).pop();
                await _logout(context);
              },
            ),
          ],
        );
      },
    );
  }
}
