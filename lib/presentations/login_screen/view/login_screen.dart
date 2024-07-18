import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/title_and_textformfield.dart';
import 'package:desaihomes_crm_application/presentations/login_screen/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign In",
          style: GLTextStyles.robotoStyle(
              color: ColorTheme.black, size: 20, weight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .45,
                width: size.width * 0.9,
                child: Column(
                  children: [
                    Text(
                      "Desai Lead Management",
                      style: GLTextStyles.cabinStyle(
                          size: 24, weight: FontWeight.bold),
                    ),
                    Text(
                      "As you enter your username and password, you're one step closer to unlocking the full potential of our website. Enter your credentials confidently, knowing that our robust security measures safeguard your information.",
                      style: GLTextStyles.robotoStyle(
                          weight: FontWeight.w300,
                          size: 13,
                          color: ColorTheme.blue),
                      maxLines: 6,
                      textAlign: TextAlign.center,
                    ),
                    Image.asset(
                      "assets/images/login_image.png",
                      height: size.height * .25,
                    )
                  ],
                ),
              ),
              TitleAndTextFormField(
                text: "Email address",
                textFontWeight: FontWeight.w500,
                textEditingController: emailController,
              ),
              Padding(
                padding: EdgeInsets.only(right: size.width * .72),
                child: const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Consumer<LoginController>(builder: (context, controller, _) {
                return SizedBox(
                  width: size.width * 0.9,
                  child: TextFormField(
                    obscureText: controller.visibility,
                    obscuringCharacter: '*',
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {
                          controller.onPressed();
                        },
                        icon: Icon(controller.visibility == true
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xff1A3447)),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(
                height: size.width * .035,
              ),
              SizedBox(
                height: size.height * 0.085,
                width: size.width * 0.9,
                child: MaterialButton(
                  color: ColorTheme.blue,
                  onPressed: () {
                    Provider.of<LoginController>(context, listen: false)
                        .onLogin(emailController.text.trim(),
                            passwordController.text.trim(), context);
                  },
                  child: Text(
                    "Login",
                    style: GLTextStyles.robotoStyle(
                        color: ColorTheme.white,
                        size: 18,
                        weight: FontWeight.w400),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
