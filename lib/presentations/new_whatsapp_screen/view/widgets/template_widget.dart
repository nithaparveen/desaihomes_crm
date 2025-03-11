import 'package:desaihomes_crm_application/presentations/new_whatsapp_screen/controller/new_whatsapp_controller.dart';
import 'package:desaihomes_crm_application/repository/api/whatsapp_screen/model/template_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/textstyles.dart';

class TemplateSelectionModal extends StatefulWidget {
  final Function(Datum) onTemplateSelected;

  const TemplateSelectionModal({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  State<TemplateSelectionModal> createState() => _TemplateSelectionModalState();
}

class _TemplateSelectionModalState extends State<TemplateSelectionModal> {
  bool _showAllTemplates = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WhatsappControllerCopy>(context, listen: false)
          .fetchWhatsAppTemplates(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WhatsappControllerCopy>(
      builder: (context, controller, _) {
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
            child: controller.isTemplateLoading
                ? Center(child: LoadingAnimationWidget.fourRotatingDots(
                  color: const Color(0xFF3E9E7C),
                  size: 30,
                ),)
                : controller.templateModel.data?.data == null ||
                        controller.templateModel.data!.data!.isEmpty
                    ? Center(child: Text("No templates available",style: GLTextStyles.manropeStyle(
                              size: 14.sp,
                              weight: FontWeight.w400,
                              color: const Color.fromARGB(255, 89, 88, 94),
                            )))
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select a Template',
                                  style: GLTextStyles.manropeStyle(
                                    color: const Color(0xFF1B1B1B),
                                    size: 16.sp,
                                    weight: FontWeight.w400,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showAllTemplates = !_showAllTemplates;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r)),
                                      color: const Color(0xffFAFAFA),
                                    ),
                                    padding: EdgeInsets.all(9.w),
                                    child: Row(
                                      children: [
                                        Text(
                                          !_showAllTemplates
                                              ? 'View All Templates'
                                              : 'View Less Templates',
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
                            SizedBox(height: 16.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: controller.templateModel.data!.data!
                                  .map((template) =>
                                      _buildTemplateChip(template))
                                  .toList(),
                            ),
                            SizedBox(height: 18.h),
                            if (_showAllTemplates)
                              Column(
                                children: controller.templateModel.data!.data!
                                    .map((template) => Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.h),
                                          child: _buildTemplateCard(template),
                                        ))
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }

  Widget _buildTemplateChip(Datum template) {
    return GestureDetector(
      onTap: () => widget.onTemplateSelected(template),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: _getRandomColor(template),
            width: .8,
          ),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              template.name ?? "", 
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

  final List<Color> _templateColors = [
    const Color(0xFF1D4ED8),
    const Color(0xFF64C685),
    const Color(0xFFE62E7B),
    const Color(0xFFFFCA63),
  ];

  Color _getRandomColor(Datum template) {
    final int index = template.id.hashCode.abs() % _templateColors.length;
    return _templateColors[index];
  }

  Widget _buildTemplateCard(Datum template) {
    String getTemplateBodyText(Datum template) {
      if (template.components == null || template.components!.isEmpty) {
        return "No content available";
      }

      final bodyComponent = template.components!.firstWhere(
        (component) => component.type == "BODY",
        orElse: () => Component(),
      );

      return bodyComponent.text ?? "No body text available";
    }

    return GestureDetector(
      onTap: () => widget.onTemplateSelected(template),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: _getRandomColor(template),
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
                  template.name ?? "",
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
              getTemplateBodyText(template),
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
