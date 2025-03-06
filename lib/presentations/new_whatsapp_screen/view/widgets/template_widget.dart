import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/textstyles.dart';

class MessageTemplate {
  final String title;
  final String content;
  final Color color;

  MessageTemplate({
    required this.title,
    required this.content,
    required this.color,
  });
}

class TemplateSelectionModal extends StatefulWidget {
  final Function(MessageTemplate) onTemplateSelected;

  const TemplateSelectionModal({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  State<TemplateSelectionModal> createState() => _TemplateSelectionModalState();
}

class _TemplateSelectionModalState extends State<TemplateSelectionModal> {
  bool _showAllTemplates = false;

  final List<MessageTemplate> _templates = [
    MessageTemplate(
      title: 'Project Launched',
      content:
          'We just launched a new premium villa project in Kochi. Click here to download our brochure.',
      color: const Color(0xFF4B7BEC),
    ),
    MessageTemplate(
      title: '20th Year Celebration',
      content:
          'We are celebrating 20 years of service in the apartments and construction business. Visit our demo centre today.',
      color: const Color(0xFF26DE81),
    ),
    MessageTemplate(
      title: 'Rain Precaution',
      content:
          'Did you take precautions to protect your home from rain damage? Here are some tips.',
      color: const Color(0xFFFC5C65),
    ),
    MessageTemplate(
      title: 'Visit Our Stall',
      content:
          'Visit our stall at the property expo happening this weekend. Exclusive launch offers available.',
      color: const Color(0xFFFD9644),
    ),
    MessageTemplate(
      title: 'Maintenance Tips',
      content:
          'Regular maintenance can extend the life of your property. Check out these essential tips.',
      color: const Color(0xFF26DE81),
    ),
    MessageTemplate(
      title: 'Special Offer',
      content:
          'Limited time offer: Book now and get 10% discount on our premium apartments.',
      color: const Color(0xFF4B7BEC),
    ),
    MessageTemplate(
      title: 'Home Loan',
      content:
          'Get pre-approved home loans at attractive interest rates through our banking partners.',
      color: const Color(0xFFFC5C65),
    ),
    MessageTemplate(
      title: 'Site Visit',
      content:
          'Schedule a site visit this weekend. Our executives are available from 9 AM to 6 PM.',
      color: const Color(0xFFFD9644),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.r),
            topRight: Radius.circular(28.r),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GestureDetector(
              //   onTap: () {
              //   },
              //   child: Icon(
              //     Icons.close,
              //     size: 22.sp,
              //     color: const Color(0xFF170E2B),
              //   ),
              // ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Send',
                    style: GLTextStyles.manropeStyle(
                      color: const Color(0xFF1B1B1B),
                      size: 16.sp,
                      weight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showAllTemplates = !_showAllTemplates;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
                            color: const Color(0xffFAFAFA),
                          ),
                          padding: EdgeInsets.all(9.w),
                          child: Row(
                            children: [
                              Text(
                                'View All Templates',
                                style: GLTextStyles.manropeStyle(
                                  color: const Color(0xff1B1B1B),
                                  size: 12.sp,
                                  weight: FontWeight.w400,
                                ),
                              ),
                              Icon(
                                _showAllTemplates
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 16.sp,
                                color: const Color(0xFF000000),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // if (!_showAllTemplates)
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _templates.take(4).map((template) {
                  return _buildTemplateChip(template);
                }).toList(),
              ),
              SizedBox(height: 18.h),
              if (_showAllTemplates) ...[
                for (MessageTemplate template in _templates)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _buildTemplateCard(template),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateChip(MessageTemplate template) {
    return GestureDetector(
      onTap: () => widget.onTemplateSelected(template),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: template.color,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              template.title,
              style: GLTextStyles.manropeStyle(
                color: const Color(0xFF170E2B),
                size: 12.sp,
                weight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.arrow_outward,
              size: 16.sp,
              color: const Color(0xff776F69),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(MessageTemplate template) {
    return GestureDetector(
      onTap: () => widget.onTemplateSelected(template),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: template.color,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(36.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  template.title,
                  style: GLTextStyles.manropeStyle(
                    color: const Color(0xFF0B0D23),
                    size: 14.sp,
                    weight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_outward,
                  size: 16.sp,
                  color: const Color(0xff776F69),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              template.content,
              style: GLTextStyles.manropeStyle(
                color: const Color(0xFF2B2B2BB),
                size: 12.sp,
                weight: FontWeight.w400,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
