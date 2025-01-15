import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:iconsax/iconsax.dart';

class DuplicateLeadCard extends StatelessWidget {
  const DuplicateLeadCard({
    super.key,
    required this.duplicateEmail,
    required this.originalProject,
    required this.createdDate,
    required this.assignedTo,
    required this.leadId,
  });

  final String duplicateEmail;
  final String originalProject;
  final String createdDate;
  final String assignedTo;
  final String leadId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Original Lead',
            style: GLTextStyles.manropeStyle(
              size: 14.sp,
              weight: FontWeight.w700,
              color: ColorTheme.blue,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  duplicateEmail,
                  style: GLTextStyles.manropeStyle(
                    size: 14.sp,
                    weight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                width: (75 / ScreenUtil().screenWidth).sw,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 222, 222),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Duplicate',
                    style: GLTextStyles.manropeStyle(
                      size: 10.sp,
                      weight: FontWeight.w500,
                      color: ColorTheme.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          if (originalProject.isNotEmpty) 
            Text(
              originalProject,
              style: GLTextStyles.manropeStyle(
                size: 13.sp,
                weight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          if (assignedTo.isNotEmpty) ...[ 
            SizedBox(height: 6.h),
            Row(
              children: [
                Text(
                  "Assigned to :",
                  style: GLTextStyles.manropeStyle(
                    size: 13.sp,
                    weight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    assignedTo,
                    style: GLTextStyles.manropeStyle(
                      size: 13.sp,
                      weight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (createdDate.isNotEmpty) ...[ // Show createdDate if not empty
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  Iconsax.calendar_1,
                  size: 16.sp,
                  color: Colors.black87,
                ),
                SizedBox(width: 4.w),
                Text(
                  createdDate,
                  style: GLTextStyles.manropeStyle(
                    size: 13.sp,
                    weight: FontWeight.w400,
                    color: ColorTheme.lightBlue,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}