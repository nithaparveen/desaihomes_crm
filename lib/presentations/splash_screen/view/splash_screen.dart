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
  // @override
  // void initState() {
  //   super.initState();
  //   // Set up the 10-second timer
  //   Future.delayed(const Duration(seconds: 10), () {
  //     // Navigate only if still on the SplashScreen
  //     if (mounted) {
  //       _navigateToNextScreen();
  //     }
  //   });
  // }

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
              height: 0.58.sh, // 55% of screen height
              width: 0.7.sw, // 65% of screen width
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
                    size: 32.sp), // Scalable font size
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 17.w,
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
              height: 0.05.sw, // 5% of screen width
            ),
            SizedBox(
              height: 0.15.sw, // 15% of screen width
              width: 0.8.sw, // 80% of screen width
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
                onPressed: _navigateToNextScreen, // Button triggers navigation
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
