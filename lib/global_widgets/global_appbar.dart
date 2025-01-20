import 'dart:convert';
import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final bool hasRadius;

  const CustomAppBar({
    super.key,
    required this.backgroundColor,
    this.hasRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      shape: hasRadius
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            )
          : null,
      title: FutureBuilder<String?>(
        future: getUserName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return 
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: const Color(0xffF0F6FF),
                  size: 32,
                ),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return _buildUserIcon(context, "UU");
          }

          String userName = snapshot.data ?? "Unknown User";
          return _buildUserIcon(
              context, userName.substring(0, 2).toUpperCase(), userName);
        },
      ),
      automaticallyImplyLeading: false,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
    );
  }

  Widget _buildUserIcon(BuildContext context, String initials,
      [String? userName]) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: GestureDetector(
        onTap: () => _showUserMenu(context, initials, userName),
        child: Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: const Color(0xff170E2B),
            shape: BoxShape.circle,
            border: Border.all(width: 2.5, color: const Color.fromARGB(255, 255, 255, 255)),
          ),
          child: Center(
            child: Text(
              initials,
              style: GLTextStyles.robotoStyle(
                color: Colors.white,
                size: 14.sp,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context, String initials,
      [String? userName]) {
    showMenu(
      color: Colors.white,
      context: context,
      shadowColor: Colors.transparent,
      position: RelativeRect.fromLTRB(15.w, 70.h, 1000.w, 0),
      items: [
        PopupMenuItem(
          value: 'user_info',
          child: Row(
            children: [
              Container(
                width: 35.w,
                height: 35.w,
                decoration: BoxDecoration(
                  color: const Color(0xff170E2B),
                  shape: BoxShape.circle,
                  border: Border.all(width: 2.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: GLTextStyles.robotoStyle(
                      color: ColorTheme.white,
                      size: 13.sp,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  userName ?? "Unknown User",
                  style: GLTextStyles.manropeStyle(
                    color: ColorTheme.blue,
                    size: 14.sp,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: LogoutButton(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

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
