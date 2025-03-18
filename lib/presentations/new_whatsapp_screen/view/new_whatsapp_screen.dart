import 'dart:developer';

import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/whatsapp_screen/view/whatsapp_screen.dart';
import 'package:desaihomes_crm_application/repository/api/whatsapp_screen/model/template_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../repository/api/whatsapp_screen/model/conversation_model.dart';
import '../controller/new_whatsapp_controller.dart';
import 'widgets/new_chat_screen.dart';
import 'widgets/template_widget.dart';

class WhatsappScreenCopy extends StatefulWidget {
  const WhatsappScreenCopy({super.key});

  @override
  State<WhatsappScreenCopy> createState() => _WhatsappScreenCopyState();
}

class _WhatsappScreenCopyState extends State<WhatsappScreenCopy> {
  bool showRead = true;
  bool showIcon = true;
  bool isSelectionMode = false;
  Set<int> selectedIndices = {};
  List<int> selectedLeadIds = [];

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  fetchData() async {
    await Provider.of<WhatsappControllerCopy>(context, listen: false)
        .fetchConversations(context);
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void clearSelection() {
    setState(() {
      selectedIndices.clear();
      selectedLeadIds.clear();
      isSelectionMode = false;
    });
  }

  void toggleSelection(int index, ConversationModel message) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
        if (message.leadId != null) {
          selectedLeadIds.remove(message.leadId);
        }
        if (selectedIndices.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        selectedIndices.add(index);
        if (message.leadId != null) {
          selectedLeadIds.add(message.leadId!);
        }
        isSelectionMode = true;
      }
    });
  }

  void selectAll(List<ConversationModel> messages) {
    setState(() {
      if (selectedIndices.length == messages.length) {
        selectedIndices.clear();
        selectedLeadIds.clear();
        isSelectionMode = false;
      } else {
        selectedIndices =
            Set.from(List.generate(messages.length, (index) => index));
        selectedLeadIds = messages
            .where((msg) => msg.leadId != null)
            .map((msg) => msg.leadId!)
            .toList();
        isSelectionMode = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        searchFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          toolbarHeight: 20.0,
        ),
        body:
            Consumer<WhatsappControllerCopy>(builder: (context, controller, _) {
          if (controller.isLoading) {
            return Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: const Color(0xffF0F6FF),
                  size: 32,
                ),
              ),
            );
          }
          final List<ConversationModel> messages = controller.conversationModel;

          final filteredMessages = messages.where((message) {
            final nameMatch = message.leadName
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false;
            final messageMatch = message.message
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false;
            return nameMatch || messageMatch;
          }).toList();

          void showConfirmation(BuildContext context, String templateName,
              String templateContent, List<int> leadIds) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  title: const Column(
                    children: [
                      Icon(Iconsax.warning_2, color: Color(0xffFF9C8E))
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Are you sure you want to send this template?',
                        style: GLTextStyles.manropeStyle(
                          color: ColorTheme.blue,
                          size: 15.sp,
                          weight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Template Preview:',
                        style: GLTextStyles.manropeStyle(
                          color: ColorTheme.blue,
                          size: 14.sp,
                          weight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          templateContent,
                          style: GLTextStyles.manropeStyle(
                            color: Colors.black87,
                            size: 13.sp,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    CustomButton(
                      borderColor: Colors.transparent,
                      backgroundColor: const Color(0xffFFF2F0),
                      text: "Cancel",
                      textColor: const Color(0xffFF9C8E),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      width: (110 / ScreenUtil().screenWidth).sw,
                    ),
                    CustomButton(
                      borderColor: Colors.transparent,
                      backgroundColor: const Color(0xffECF5FF),
                      text: "Send",
                      textColor: const Color(0xff3893FF),
                      width: (110 / ScreenUtil().screenWidth).sw,
                      onPressed: () async {
                        Navigator.of(context).pop();
                        clearSelection();
                        Provider.of<WhatsappControllerCopy>(context,
                                listen: false)
                            .sendMultiMessages(
                                leadIds, templateName, "en_US", context);
                      },
                    ),
                  ],
                );
              },
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isSelectionMode
                            ? Row(
                                children: [
                                  GestureDetector(
                                    onTap: clearSelection,
                                    child: Icon(
                                      Icons.close,
                                      color: const Color(0xff120e2b),
                                      size: 20.sp,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "${selectedIndices.length} selected",
                                    style: GLTextStyles.manropeStyle(
                                      size: 18.sp,
                                      weight: FontWeight.w600,
                                      color: const Color(0xff120e2b),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Messages",
                                style: GLTextStyles.manropeStyle(
                                  size: 18.sp,
                                  weight: FontWeight.w600,
                                  color: const Color(0xff120e2b),
                                ),
                              ),
                        PopupMenuButton<String>(
                          color: Colors.white,
                          elevation: 1,
                          position: PopupMenuPosition.over,
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            size: 20.sp,
                          ),
                          onSelected: (value) {
                            if (value == "Select all") {
                              selectAll(filteredMessages);
                            } else if (value == "Select template") {
                              final BuildContext parentContext = context;

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => TemplateSelectionModal(
                                  onTemplateSelected: (template) {
                                    final templateContent =
                                        getTemplateBodyText(template);

                                    Navigator.of(context).pop();
                                    Future.delayed(
                                        const Duration(milliseconds: 300), () {
                                      showConfirmation(
                                        parentContext,
                                        template.name ?? "",
                                        templateContent,
                                        selectedLeadIds,
                                      );
                                    });
                                  },
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => isSelectionMode
                              ? [
                                  PopupMenuItem(
                                    value: "Select all",
                                    child: Text(
                                      "Select all",
                                      style: GLTextStyles.manropeStyle(
                                        size: 14.sp,
                                        weight: FontWeight.w500,
                                        color: const Color(0xff3E9E7C),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "Select template",
                                    child: Text(
                                      "Select template",
                                      style: GLTextStyles.manropeStyle(
                                        size: 14.sp,
                                        weight: FontWeight.w500,
                                        color: const Color(0xff3E9E7C),
                                      ),
                                    ),
                                  ),
                                ]
                              : [
                                  PopupMenuItem(
                                    value: "Select all",
                                    child: Text(
                                      "Select all",
                                      style: GLTextStyles.manropeStyle(
                                        size: 14.sp,
                                        weight: FontWeight.w500,
                                        color: const Color(0xff3E9E7C),
                                      ),
                                    ),
                                  ),
                                ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    if (!isSelectionMode)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7FC),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: TextField(
                          cursorColor: const Color(0xFF3E9E7C),
                          controller: searchController,
                          focusNode: searchFocusNode,
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: GLTextStyles.manropeStyle(
                                size: 14.sp,
                                color: const Color(0xffADB5BD),
                                weight: FontWeight.w600),
                            border: InputBorder.none,
                            icon: Icon(
                              Iconsax.search_normal_1,
                              color: const Color(0xffADB5BD),
                              size: 20.sp,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: filteredMessages.isEmpty
                    ? Center(
                        child: Text("No messages found",
                            style: GLTextStyles.manropeStyle(
                              size: 14.sp,
                              weight: FontWeight.w400,
                              color: const Color.fromARGB(255, 89, 88, 94),
                            )))
                    : ListView.separated(
                        itemCount: filteredMessages.isEmpty
                            ? 0
                            : filteredMessages.length,
                        itemBuilder: (context, index) {
                          final message = filteredMessages[index];
                          final isSelected = selectedIndices.contains(index);

                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -1),
                                leading: Stack(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        radius: 22.r,
                                        child:
                                            // message.profilePicture == null ?
                                            Text(
                                          message.leadName?[0] ?? "",
                                          style: GLTextStyles.manropeStyle(
                                            color: Colors.black,
                                            size: 16.sp,
                                          ),
                                        )
                                        // : ClipOval(
                                        //     child: Image.network(
                                        //       message.profilePicture!,
                                        //       width: 44.r,
                                        //       height: 44.r,
                                        //       fit: BoxFit.cover,
                                        //       errorBuilder: (context, error, stackTrace) => Text(
                                        //         message.contactUser?.name?[0] ?? "",
                                        //         style: GLTextStyles.manropeStyle(
                                        //           color: Colors.black,
                                        //           size: 16.sp,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        ),
                                    // if (message.lastMessage?.isRead == false)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: 17.r,
                                        height: 17.r,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF3E9E7C),
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "",
                                          style: GLTextStyles.manropeStyle(
                                            size: 10.sp,
                                            color: Colors.white,
                                            weight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  message.leadName ?? "",
                                  style: GLTextStyles.manropeStyle(
                                      size: 14.sp,
                                      weight: FontWeight.w600,
                                      color: const Color(0xff170e2b)),
                                ),
                                subtitle: Row(
                                  children: [
                                    if (message.msgType == "Audio")
                                      Icon(Iconsax.microphone_25, size: 16.sp)
                                    else if (message.msgType == "Image")
                                      Icon(Iconsax.gallery5, size: 14.sp)
                                    else if (message.msgType == "Video")
                                      Icon(Iconsax.video5, size: 14.sp)
                                    else if (message.msgType == "Contact")
                                      Icon(Icons.person_rounded, size: 14.sp)
                                    else if (message.msgType == "location")
                                      Icon(Icons.location_on, size: 14.sp)
                                    else if (message.msgType == "Document")
                                      Icon(Iconsax.document_text5, size: 14.sp),
                                    if (message.msgType != null)
                                      SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        _getMessageText(
                                          message.msgType.toString(),
                                          message.message.toString(),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        style: GLTextStyles.manropeStyle(
                                          size: 12.sp,
                                          weight: FontWeight.w400,
                                          color: const Color(0xffA0A0A0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      message.createdAt != null
                                          ? getSmartTimestamp(message.createdAt)
                                          : '',
                                      style: GLTextStyles.manropeStyle(
                                        size: 10.sp,
                                        color: const Color(0xffA4A4A4),
                                        weight: FontWeight.w400,
                                      ),
                                    ),
                                    // if (message.lastMessage?.isRead == true ||
                                    //     message.lastMessage?.isRead == false ||
                                    //     message.lastMessage?.status == "sent")
                                    //   SizedBox(height: 8.h),
                                    // if (message.lastMessage?.isRead == true)
                                    //   Icon(
                                    //     Icons.done_all,
                                    //     size: 16.sp,
                                    //     color: Color(0xFF30C0E0),
                                    //   )
                                    // else if (message.lastMessage?.isRead ==
                                    //     false)
                                    //   Icon(
                                    //     Icons.done_all,
                                    //     size: 16.sp,
                                    //     color: Color(0xffA4A4A4),
                                    //   )
                                    // else if (message.lastMessage?.status ==
                                    //     "sent")
                                    //   Icon(
                                    //     Icons.done,
                                    //     size: 16.sp,
                                    //     color: Color(0xffA4A4A4),
                                    //   ),
                                    if (isSelectionMode) SizedBox(height: 10.w),
                                    if (isSelectionMode)
                                      Container(
                                        width: 18.w,
                                        height: 18.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF3E9E7C)
                                                : const Color(0xFFDDDDDD),
                                            width: 1.5,
                                          ),
                                          color: isSelected
                                              ? const Color(0xFF3E9E7C)
                                              : Colors.transparent,
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 14,
                                              )
                                            : null,
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  if (isSelectionMode) {
                                    toggleSelection(index, message);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreenCopy(
                                          contactedNumber: "919567485652",
                                          name: message.leadName ?? "",
                                          leadId: message.leadId ?? 0,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                onLongPress: () {
                                  if (!isSelectionMode) {
                                    setState(() {
                                      isSelectionMode = true;
                                      toggleSelection(index, message);
                                    });
                                  }
                                },
                              ));
                        },
                        separatorBuilder: (context, index) => Divider(
                          color: const Color(0xffEDEDED),
                          thickness: 0.5,
                          endIndent: 24.w,
                          indent: 24.w,
                        ),
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F7FA) : Colors.transparent,
          borderRadius: BorderRadius.circular(4.8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: const Color(0xffA4A4A4), // Icon always visible
            ),
            SizedBox(width: 6.w), // Spacing between icon and text
            Text(
              text,
              style: GLTextStyles.manropeStyle(
                size: 12.sp,
                color: Colors.black,
                weight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 6.w),
          ],
        ),
      ),
    );
  }

  String _getMessageText(String msgType, String message) {
    switch (msgType) {
      case "Image":
        return "Photo";
      case "Document":
        return "Document";
      case "Location":
        return "Location";
      case "Audio":
        return "Voice message";
      case "Contact":
        return "Contact message";
      case "Video":
        return "Video";
      default:
        return message;
    }
  }

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

  String getSmartTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final localTimestamp = timestamp.isUtc ? timestamp.toLocal() : timestamp;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate =
        DateTime(localTimestamp.year, localTimestamp.month, localTimestamp.day);

    if (messageDate == today) {
      return DateFormat('hh:mm a').format(localTimestamp);
    } else if (messageDate == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat('MMM d').format(localTimestamp);
    }
  }
}
