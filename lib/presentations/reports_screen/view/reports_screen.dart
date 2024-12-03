import 'dart:convert';

import 'package:desaihomes_crm_application/app_config/app_config.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/logout_button.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/controller/lead_controller.dart';
import 'package:desaihomes_crm_application/presentations/lead_screen/view/widgets/filter_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorTheme.desaiGreen,
        foregroundColor: ColorTheme.desaiGreen,
        title: FutureBuilder<String?>(
          future: getUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Text("Unknown User");
            }
            String userName = snapshot.data ?? "Unknown User";
            return Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 202, 158, 208),
                    shape: BoxShape.circle,
                    border: Border.all(width: 2.5, color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      userName.substring(0, 2).toUpperCase(),
                      style: GLTextStyles.robotoStyle(
                        color: ColorTheme.blue,
                        size: 13.sp,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  userName,
                  style: GLTextStyles.manropeStyle(
                    color: ColorTheme.white,
                    size: 14.sp,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
        actions: const [LogoutButton()],
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 0.14.sh,
                width: 1.sw,
                decoration: BoxDecoration(
                  color: ColorTheme.desaiGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 15.w),
                    Flexible(
                      child: SizedBox(
                        height: 44.h,
                        child: SearchBar(
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.only(left: 15.w)),
                          hintText: "Search ...",
                          hintStyle: MaterialStatePropertyAll(
                            GLTextStyles.manropeStyle(
                              size: 13.sp,
                              weight: FontWeight.w400,
                              color: const Color.fromARGB(255, 132, 132, 132),
                            ),
                          ),
                          elevation: const MaterialStatePropertyAll(0),
                          surfaceTintColor:
                              const MaterialStatePropertyAll(Colors.white),
                          leading: Icon(
                            Iconsax.search_normal_1,
                            size: 18.sp,
                            color: const Color.fromARGB(255, 132, 132, 132),
                          ),
                          textStyle: MaterialStatePropertyAll(
                            GLTextStyles.manropeStyle(
                              weight: FontWeight.w400,
                              size: 15.sp,
                              color: const Color.fromARGB(255, 87, 87, 87),
                            ),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.38),
                            ),
                          ),
                          controller: Provider.of<LeadController>(context,
                                  listen: false)
                              .searchController,
                          onChanged: (value) {
                            Provider.of<LeadController>(context, listen: false)
                                .searchLeads(context);
                          },
                          onSubmitted: (value) {
                            Provider.of<LeadController>(context, listen: false)
                                .searchLeads(context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      height: 44.h,
                      child: Container(
                        width: 44.w,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(7.38.r),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const FilterModal();
                                },
                              );
                            },
                            icon: Icon(
                              Iconsax.setting_5,
                              size: 18.sp,
                              color: const Color.fromARGB(255, 132, 132, 132),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lead Reports",
                  style: GLTextStyles.manropeStyle(
                    size: 18.sp,
                    weight: FontWeight.w600,
                    color: const Color(0xff120e2b),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(5.5.r),
                  ),
                  child: Row(children: [
                    Icon(
                      Iconsax.calendar,
                      size: 18.sp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "May 24 - 31",
                      style: GLTextStyles.manropeStyle(
                        color: ColorTheme.grey,
                        size: 13.sp,
                        weight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16.sp,
                      color: Color(0xFFB5BEC6),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
