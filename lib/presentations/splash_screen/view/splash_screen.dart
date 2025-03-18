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
          bottom: 42.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 282.h,
              width: 347.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Buildings.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 59.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 10.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 37.h,
                      width: 34.w,
                      child: Image.asset("assets/icons/image 9.png")),
                  SizedBox(width: 12.w),
                  Text(
                    "Desai Homes",
                    style: GLTextStyles.manropeStyle(size: 32.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Text(
              "Lead Management",
              style: GLTextStyles.manropeStyle(
                size: 18.sp,
                weight: FontWeight.w500,
                color: const Color(0xff909090),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 33.h),
            Text(
              "Empowering Customer Relationships – Streamline interactions, track leads, and deliver excellence ",
              style: GLTextStyles.manropeStyle(
                size: 14.sp,
                weight: FontWeight.w300,
                color: const Color(0xff909090),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 93.h),
            SizedBox(
              height: 56.h,
              width: 331.w,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
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
