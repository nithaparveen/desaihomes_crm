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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoginPressed = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void _onLoginPressed(BuildContext context) {
    setState(() {
      isLoginPressed = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      Provider.of<LoginController>(context, listen: false).onLogin(
        emailController.text.trim(),
        passwordController.text.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Welcome back!",
                    style: GLTextStyles.manropeStyle(
                      size: 30.sp,
                      weight: FontWeight.w700,
                      color: const Color(0xff1E232C),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Sign in to access your account",
                    style: GLTextStyles.manropeStyle(
                      size: 14.sp,
                      weight: FontWeight.w300,
                      color: const Color(0xff9B9A9D),
                    ),
                  ),
                  SizedBox(height: 34.h),
                  Center(
                    child: Container(
                      height: 280.h,
                      width: 291.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/LoginImage.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 340.h,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
                      child: Column(
                        children: [
                          CustomTextField(
                            hintSize: 15,
                            verticalPadding: 17,
                            borderSide: const BorderSide(color: Color(0xffE8ECF4)),
                            fillColor: const Color(0xffF7F8F9),
                            prefixIcon: Icon(
                              Iconsax.sms,
                              size: 20.sp,
                              color: const Color(0xff4E4E4E),
                            ),
                            hintText: "Enter your email",
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                          ),
                          SizedBox(height: 22.h),
                          Consumer<LoginController>(
                            builder: (context, controller, _) {
                              return CustomTextField(
                                hintSize: 15,
                                verticalPadding: 17,
                                borderSide: const BorderSide(color: Color(0xffE8ECF4)),
                                prefixIcon: Icon(
                                  Iconsax.lock,
                                  size: 20.sp,
                                  color: const Color(0xff4E4E4E),
                                ),
                                fillColor: const Color(0xffF7F8F9),
                                isPasswordField: true,
                                obscureText: controller.visibility,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.onPressed();
                                  },
                                  icon: Icon(
                                    controller.visibility
                                        ? Iconsax.eye_slash
                                        : Iconsax.eye,
                                    size: 20.sp,
                                    color: const Color(0xff4E4E4E),
                                  ),
                                ),
                                hintText: "Enter your password",
                                controller: passwordController,
                                validator: validatePassword,
                              );
                            },
                          ),
                          SizedBox(height: 34.h),
                          SizedBox(
                            height: 0.15.sw,
                            width: 1.sw,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all(
                                  ColorTheme.desaiGreen,
                                ),
                              ),
                              onPressed: () => _onLoginPressed(context),
                              child: Text(
                                "Log In",
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


