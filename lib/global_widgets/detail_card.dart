import 'package:flutter/material.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailCard extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? age;
  final List<DetailText> detailTexts;

  const DetailCard({
    super.key,
    this.name,
    this.email,
    this.phone,
    this.age,
    required this.detailTexts,
  });

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> makeEmail(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffF5F3FF),
              borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name != null ||
                    email != null ||
                    phone != null ||
                    age != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (name != null)
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 41,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff93FAB4),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Center(
                                      child: Icon(
                                    Iconsax.user,
                                    size: 18,
                                    color: Color(0xff0B0D23),
                                  )),
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(name!,
                                    style: GLTextStyles.interStyle(
                                        size: 16,
                                        weight: FontWeight.w500,
                                        color: ColorTheme.black)),
                              ],
                            ),
                          if (age != null)
                            Row(
                              children: [
                                Text(
                                  "Age",
                                  style: GLTextStyles.interStyle(
                                      size: 12,
                                      weight: FontWeight.w400,
                                      color: ColorTheme.lightgrey),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(age!,
                                    style: GLTextStyles.interStyle(
                                        size: 14,
                                        weight: FontWeight.w600,
                                        color: ColorTheme.black)),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      if (phone != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                makePhoneCall(phone!);
                              },
                              child: const Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Iconsax.call,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number",
                                  style: GLTextStyles.interStyle(
                                      size: 12,
                                      weight: FontWeight.w400,
                                      color: ColorTheme.lightgrey),
                                ),
                                Text(
                                  phone!,
                                  style: GLTextStyles.interStyle(
                                      size: 14,
                                      weight: FontWeight.w400,
                                      color: ColorTheme.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 16.0),
                      if (email != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                makeEmail(email!);
                              },
                              child: const Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                elevation: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Iconsax.sms,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: GLTextStyles.interStyle(
                                      size: 12,
                                      weight: FontWeight.w400,
                                      color: ColorTheme.lightgrey),
                                ),
                                Text(
                                  email!,
                                  style: GLTextStyles.interStyle(
                                      size: 14,
                                      weight: FontWeight.w400,
                                      color: ColorTheme.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      SizedBox(height: 22.h),
                      const Divider(
                        thickness: 0.5,
                        color: Color(0xffc4b9ff),
                      ),
                    ],
                  ),
                ...detailTexts,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailText extends StatelessWidget {
  const DetailText({
    super.key,
    required this.text,
    required this.value,
    this.textSize,
    this.textFontWeight,
    this.textColor,
  });

  final String text;
  final String value;
  final double? textSize;
  final FontWeight? textFontWeight;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 18.h),
        Text(
          text,
          style: GLTextStyles.interStyle(
              size: 12, weight: FontWeight.w400, color: ColorTheme.lightgrey),
        ),
        Text(
          value,
          style: GLTextStyles.interStyle(
              size: 14,
              weight: FontWeight.w400,
              color: const Color(0xff170e2b)),
        ),
        SizedBox(height: 12.h),
        const Divider(
          thickness: 0.5,
          color: Color(0xffc4b9ff),
        ),
      ],
    );
  }
}
