import 'package:flutter/material.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../presentations/new_whatsapp_screen/view/widgets/new_chat_screen.dart';

class DetailCard extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? age;
  final int? leadId;
  final List<DetailText> detailTexts;

  const DetailCard({
    super.key,
    this.name,
    this.email,
    this.phone,
    this.age,
    required this.detailTexts,
    this.leadId,
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
        padding:
            EdgeInsets.only(left: 15.w, right: 15.w, top: 5.h, bottom: 15.h),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: EdgeInsets.all(16.w),
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
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff93FAB4),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Center(
                                        child: Icon(
                                      Iconsax.user,
                                      size: 18.sp,
                                      color: const Color(0xff0B0D23),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 16.w,
                                  ),
                                  Expanded(
                                    child: Text(name!,
                                        overflow: TextOverflow.ellipsis,
                                        style: GLTextStyles.interStyle(
                                            size: 16.sp,
                                            weight: FontWeight.w500,
                                            color: ColorTheme.black)),
                                  ),
                                ],
                              ),
                            ),
                          if (age != null)
                            Row(
                              children: [
                                Text(
                                  "Age",
                                  style: GLTextStyles.interStyle(
                                      size: 12.sp,
                                      weight: FontWeight.w400,
                                      color: ColorTheme.lightgrey),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(age!,
                                    style: GLTextStyles.interStyle(
                                        size: 14.sp,
                                        weight: FontWeight.w600,
                                        color: ColorTheme.black)),
                              ],
                            ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreenCopy(
                                    contactedNumber: phone ?? "",
                                    name: name ?? "",
                                    leadId: leadId ?? 0,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF25d366),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.r)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    offset: Offset(0, 4),
                                    blurRadius: 6,
                                    spreadRadius: -2,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(6.w),
                                child: Icon(
                                  FontAwesomeIcons.whatsapp,
                                  size: 20.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      if (phone != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                makePhoneCall(phone!);
                              },
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.r)),
                                  border: Border.all(
                                    color: const Color(0xFFECECEE),
                                    width: 0.91,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      offset: Offset(0, 4),
                                      blurRadius: 6,
                                      spreadRadius: -2,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(6.w),
                                  child: Icon(
                                    Iconsax.call,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 9.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone Number",
                                    style: GLTextStyles.interStyle(
                                        size: 12.sp,
                                        weight: FontWeight.w400,
                                        color: ColorTheme.lightgrey),
                                  ),
                                  Text(
                                    phone!,
                                    style: GLTextStyles.interStyle(
                                        size: 14.sp,
                                        weight: FontWeight.w400,
                                        color: ColorTheme.black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 16.h),
                      if (email != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                makeEmail(email!);
                              },
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.r)),
                                  border: Border.all(
                                    color: const Color(0xFFECECEE),
                                    width: 0.91,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      offset: Offset(0, 4),
                                      blurRadius: 8,
                                      spreadRadius: -4,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(6.w),
                                  child: Icon(
                                    Iconsax.sms,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 9.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: GLTextStyles.interStyle(
                                      size: 12.sp,
                                      weight: FontWeight.w400,
                                      color: ColorTheme.lightgrey),
                                ),
                                Text(
                                  email!,
                                  style: GLTextStyles.interStyle(
                                      size: 14.sp,
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
              size: 12.sp,
              weight: FontWeight.w400,
              color: ColorTheme.lightgrey),
        ),
        Text(
          value,
          style: GLTextStyles.interStyle(
              size: 14.sp,
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
