import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LeadCard extends StatelessWidget {
  final String name;
  final String location;
  final String platform;
  final String timeAgo;
  final String initials;
  final String status;

  const LeadCard({
    super.key,
    required this.name,
    required this.location,
    required this.platform,
    required this.timeAgo,
    required this.initials,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFCBF4CB),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(initials,
                  style: GLTextStyles.robotoStyle(
                      color: ColorTheme.blue,
                      size: 20,
                      weight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GLTextStyles.manropeStyle(
                        color: Color(0xff120e2b),
                        size: 14,
                        weight: FontWeight.w700)),
                Text(location,
                    style: GLTextStyles.manropeStyle(
                        color: ColorTheme.grey,
                        size: 14,
                        weight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(platform,
                    style: GLTextStyles.manropeStyle(
                        color: ColorTheme.black,
                        size: 14,
                        weight: FontWeight.w500)),
                Text(timeAgo,
                    style: GLTextStyles.manropeStyle(
                        color: ColorTheme.lightBlue,
                        size: 12.5,
                        weight: FontWeight.w600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xffD8D8D8),
                        width: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Iconsax.profile_add,
                      size: 22,
                      color: Colors.black87,
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.black54,
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text('Option 1'),
                        value: 1,
                      ),
                      const PopupMenuItem(
                        child: Text('Option 2'),
                        value: 2,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(status,
                    style: GLTextStyles.manropeStyle(
                        color: ColorTheme.lightBlue,
                        size: 10,
                        weight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
