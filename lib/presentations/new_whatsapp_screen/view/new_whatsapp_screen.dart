import 'dart:developer';

import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../repository/api/whatsapp_screen/model/conversation_model.dart';
import '../controller/new_whatsapp_controller.dart';
import 'widgets/new_chat_screen.dart';

class Message {
  final String name;
  final String? message;
  final String? photo;
  final String time;
  final bool isRead;
  final bool isSent;
  final bool isDelivered;
  final bool hasVoice;
  final String? voiceDuration;
  final bool hasUnread;
  final String? profilePicture;

  Message({
    required this.name,
    this.message,
    this.photo,
    required this.time,
    this.isRead = false,
    this.isSent = false,
    this.isDelivered = false,
    this.hasVoice = false,
    this.voiceDuration,
    this.hasUnread = false,
    this.profilePicture,
  });
}

class WhatsappScreenCopy extends StatefulWidget {
  const WhatsappScreenCopy({super.key});

  @override
  State<WhatsappScreenCopy> createState() => _WhatsappScreenCopyState();
}

class _WhatsappScreenCopyState extends State<WhatsappScreenCopy> {
  bool showRead = true;
  bool showIcon = true;

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

  final List<Message> messages = [
    Message(
      name: "Rakesh Nair",
      message: "I'm interested in the 2BHK apartment, is...",
      time: "6:01 pm",
      hasUnread: true,
    ),
    Message(
      name: "Erlan Sadewa",
      photo: "Photo",
      time: "5:43 pm",
      hasUnread: true,
      profilePicture:
          "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ),
    Message(
      name: "Rakesh Nair",
      message: "Please share your location",
      time: "6:01",
      isSent: true,
    ),
    Message(
        name: "Gloria",
        hasVoice: true,
        voiceDuration: "0:05",
        time: "6:01",
        hasUnread: true,
        profilePicture:
            "https://images.unsplash.com/photo-1586297135537-94bc9ba060aa?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHVzZXJzfGVufDB8fDB8fHww"),
    Message(
      name: "Tony John",
      message: "Please share your location",
      time: "6:01",
      isRead: true,
      profilePicture:
          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHVzZXJzfGVufDB8fDB8fHww",
    ),
    Message(
      name: "Abhishek PM",
      hasVoice: true,
      voiceDuration: "0:05",
      time: "6:01",
      isDelivered: true,
    ),
    Message(
      name: "Nitha Parveen",
      message: "Document: Aaditri Nivas.pdf",
      photo: "Document",
      time: "10/03/25",
      isRead: true,
    ),
  ];

  List<Message> getFilteredMessages() {
    if (searchQuery.isEmpty) {
      return messages;
    }
    // if (showRead) {
    //   return messages.where((message) => message.isRead).toList();
    // } else {
    //   return messages.where((message) => !message.isRead).toList();
    // }

    return messages.where((message) {
      final nameMatch = message.name.toLowerCase().contains(searchQuery);

      final messageMatch =
          message.message?.toLowerCase().contains(searchQuery) ?? false;

      final isDocument = message.photo == "Document";
      final documentMatch = isDocument &&
          (message.message?.toLowerCase().contains(searchQuery) ?? false);

      return nameMatch || messageMatch || documentMatch;
    }).toList();
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

          // Ensure it's a list
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

          if (filteredMessages.isEmpty) {
            return Center(
              child: Text(
                "No messages found",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
                        Text(
                          "Messages",
                          style: GLTextStyles.manropeStyle(
                            size: 18.sp,
                            weight: FontWeight.w600,
                            color: const Color(0xff120e2b),
                          ),
                        ),
                        // Container(
                        //   padding:
                        //       EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(9.6.r),
                        //     boxShadow: const [
                        //       BoxShadow(
                        //         color:  Color(
                        //             0x05000000), // #00000005 in ARGB format
                        //         blurRadius: 6.41, // Blur effect
                        //         spreadRadius: 6.41, // Spread effect
                        //         offset:  Offset(
                        //             0, 0), // No offset, shadow spread evenly
                        //       ),
                        //     ],
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       _buildToggleButton(
                        //         text: "Read",
                        //         isSelected: showRead,
                        //         icon: Icons.done_all, // Icon for "Read"
                        //         onTap: () => setState(() => showRead = true),
                        //       ),
                        //       SizedBox(width: 19.w),
                        //       _buildToggleButton(
                        //         text: "Unread",
                        //         isSelected: !showRead,
                        //         icon: Iconsax.note, // Icon for "Unread"
                        //         onTap: () => setState(() => showRead = false),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Icon(
                          Icons.more_vert_rounded,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          size: 20.sp,
                        )
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7FC),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: TextField(
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
              SizedBox(height: 20.h),
              Expanded(
                child: messages.isEmpty
                    ? const Center(child: Text("No messages found"))
                    : ListView.separated(
                        itemCount: filteredMessages.isEmpty
                            ? 0
                            : filteredMessages.length,
                        itemBuilder: (context, index) {
                          final message = filteredMessages[index];

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
                                          "1",
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
                                    // if (message.lastMessage?.messageType ==
                                    //     "audio")
                                    //   Icon(
                                    //     Iconsax.microphone_25,
                                    //     size: 16.sp,
                                    //     color:
                                    //         message.lastMessage?.isRead == false
                                    //             ? const Color(0xFF3E9E7C)
                                    //             : Colors.grey,
                                    //   )
                                    // else if (message.lastMessage?.messageType ==
                                    //     "image")
                                    //   Icon(
                                    //     Iconsax.gallery5,
                                    //     size: 14.sp,
                                    //     color:
                                    //         message.lastMessage?.isRead == false
                                    //             ? const Color(0xFF3E9E7C)
                                    //             : Colors.grey,
                                    //   )
                                    // else if (message.lastMessage?.messageType ==
                                    //     "contact")
                                    //   Icon(
                                    //     Icons.person_rounded,
                                    //     size: 14.sp,
                                    //     color:
                                    //         message.lastMessage?.isRead == false
                                    //             ? const Color(0xFF3E9E7C)
                                    //             : Colors.grey,
                                    //   )
                                    // else if (message.lastMessage?.messageType ==
                                    //     "location")
                                    //   Icon(
                                    //     Icons.location_on,
                                    //     size: 14.sp,
                                    //     color:
                                    //         message.lastMessage?.isRead == false
                                    //             ? const Color(0xFF3E9E7C)
                                    //             : Colors.grey,
                                    //   )
                                    // else if (message.lastMessage?.messageType ==
                                    //     "document")
                                    //   Icon(
                                    //     Iconsax.document_text5,
                                    //     size: 14.sp,
                                    //     color:
                                    //         message.lastMessage?.isRead == false
                                    //             ? const Color(0xFF3E9E7C)
                                    //             : Colors.grey,
                                    //   ),
                                    // if (message.lastMessage?.messageType !=
                                    //     null)
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        message.message.toString(),
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
                                          ? DateFormat('hh:mm a')
                                              .format(message.createdAt!)
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
                                  ],
                                ),
                                onTap: () {
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
            SizedBox(width: 6.w), // Spacing between text and checkmark
          ],
        ),
      ),
    );
  }

  // String _getMessageText(LastMessage? lastMessage) {
  //   if (lastMessage == null) return "";

  //   switch (lastMessage.messageType) {
  //     case "image":
  //       return "Photo";
  //     case "document":
  //       return "Document";
  //     case "location":
  //       return "Location";
  //     case "audio":
  //       return "Voice message";
  //     case "contact":
  //       return "Contact message";
  //     default:
  //       return lastMessage.message ?? "";
  //   }
  // }
}
