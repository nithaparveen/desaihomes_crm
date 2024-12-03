import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/login_screen/view/login_screen_copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreenCopy(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: 15.w,
          right: 15.w,
          bottom: 30.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 0.58.sh, 
              width: 0.7.sw, 
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Group 427320606.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 12.h,
              ),
              child: Text(
                "Desai Lead Management",
                style: GLTextStyles.manropeStyle(
                    size: 32.sp), 
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              child: Text(
                "Empowering Customer Relationships – Streamline interactions, track leads, and deliver excellence ",
                style: GLTextStyles.manropeStyle(
                  size: 16.sp,
                  weight: FontWeight.w300,
                  color: const Color(0xff909090),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 0.05.sw, 
            ),
            SizedBox(
              height: (56 / ScreenUtil().screenHeight).sh, 
              width: 0.81.sw, 
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    ColorTheme.desaiGreen,
                  ),
                ),
                onPressed: _navigateToNextScreen, 
                child: Text(
                  "Get Started",
                  style: GLTextStyles.manropeStyle(
                    size: 15.sp,
                    weight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
