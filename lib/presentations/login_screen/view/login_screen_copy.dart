import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_textfield.dart';
import 'package:desaihomes_crm_application/presentations/login_screen/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';

class LoginScreenCopy extends StatefulWidget {
  const LoginScreenCopy({super.key});

  @override
  State<LoginScreenCopy> createState() => _LoginScreenCopyState();
}

class _LoginScreenCopyState extends State<LoginScreenCopy> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoginPressed = false;

  String? validateEmail(String? value) {
    if (isLoginPressed) {
      if (value == null || value.isEmpty) {
        return 'Please enter your email';
      }
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (isLoginPressed) {
      if (value == null || value.isEmpty) {
        return 'Password is required';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            const Color(0xFF24116B),
            ColorTheme.desaiGreen,
          ],
          stops: const [0.00008, 2.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 12.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Container(
                      height: 0.2.sh,
                      width: 0.38.sw,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/rafiki.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 40.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign In",
                          style: GLTextStyles.manropeStyle(
                              size: 30.sp,
                              weight: FontWeight.w600,
                              color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Log in to unlock smarter lead management track, and convert prospects efficiently",
                          style: GLTextStyles.manropeStyle(
                              size: 14.sp,
                              weight: FontWeight.w400,
                              color: const Color(0xffF0F0F0)),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 0.48.sh,
                      width: 1.sw,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white),
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 12.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            prefixIcon: const Icon(
                              Iconsax.sms,
                              size: 15,
                            ),
                            hintText: "Enter email",
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Consumer<LoginController>(
                            builder: (context, controller, _) {
                              return CustomTextField(
                                prefixIcon:  Icon(
                                  Iconsax.lock,
                                  size: 15.sp,
                                ),
                                isPasswordField: true,
                                obscureText: controller
                                    .visibility, 
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller
                                        .onPressed();
                                  },
                                  icon: Icon(
                                    controller.visibility
                                        ? Iconsax.eye_slash
                                        : Iconsax
                                            .eye, 
                                    size: 15.sp,
                                  ),
                                ),
                                hintText: "Enter password",
                                controller: passwordController,
                                validator: validatePassword,
                              );
                            },
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          SizedBox(
                            height: 0.15.sw,
                            width: 1.sw,
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
                              onPressed: () {
                                setState(() {
                                  isLoginPressed = true;
                                });
                                Provider.of<LoginController>(context,
                                        listen: false)
                                    .onLogin(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                        context);
                              },
                              child: Text(
                                "Sign In",
                                style: GLTextStyles.manropeStyle(
                                  size: 16.sp,
                                  weight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
