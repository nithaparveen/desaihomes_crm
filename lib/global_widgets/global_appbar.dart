import 'dart:convert';
import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final bool hasRadius;

  const CustomAppBar({
    super.key,
    required this.backgroundColor,
    this.hasRadius = true,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isVisible = false;

  void _toggleSlide() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor,
      shape: widget.hasRadius
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
            return Padding(
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
          return _buildUserIcon(context, userName.substring(0, 2).toUpperCase(), userName);
        },
      ),
      automaticallyImplyLeading: false,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
    );
  }

Widget _buildUserIcon(BuildContext context, String initials, [String? userName]) {
  return GestureDetector(
    onTap: _toggleSlide, 
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      width: _isVisible ? null : 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: _isVisible ? Colors.white : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(_isVisible ? 25.r: 25.r)), 
        border: Border.all(width: 2, color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 35.sp,
            height: 35.sp,
            decoration: BoxDecoration(
              color: const Color(0xff170E2B),
              shape: BoxShape.circle,
              border: Border.all(width: 2.5, color: Colors.white),
            ),
            child: Center(
              child: Text(
                initials,
                style: GLTextStyles.robotoStyle(
                  color: Colors.white,
                  size: 13.sp,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (_isVisible) ...[
             SizedBox(width: 8.sp),
            Flexible(
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  userName ?? "Unknown User",
                  style: GLTextStyles.manropeStyle(
                    color: ColorTheme.blue,
                    size: 14.sp,
                    weight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, 
                ),
              ),
            ),
            SizedBox(width: 8.sp), 
            const LogoutButton(),
            SizedBox(width: 4.sp),
          ],
        ],
      ),
    ),
  );
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
}}