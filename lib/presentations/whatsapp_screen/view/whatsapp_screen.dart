import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/whatsapp_screen/view/widgets/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../lead_screen/view/widgets/create_lead_modal.dart';

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

class WhatsappScreen extends StatefulWidget {
  const WhatsappScreen({super.key});

  @override
  State<WhatsappScreen> createState() => _WhatsappScreenState();
}

class _WhatsappScreenState extends State<WhatsappScreen> {
  bool showRead = true;
  bool showIcon = true;

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Add listener to search controller
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
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
      // Search in name
      final nameMatch = message.name.toLowerCase().contains(searchQuery);

      // Search in message content if it exists
      final messageMatch =
          message.message?.toLowerCase().contains(searchQuery) ?? false;

      // Search in document name if it's a document
      final isDocument = message.photo == "Document";
      final documentMatch = isDocument &&
          (message.message?.toLowerCase().contains(searchQuery) ?? false);

      // Return true if any of the conditions match
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
          toolbarHeight: 20.0, // Adjust the height as needed
        ),
        
        body: Column(
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
                  // Search bar
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
            // Messages list
            Expanded(
              child: ListView.separated(
                itemCount: getFilteredMessages().length,
                itemBuilder: (context, index) {
                  final message = getFilteredMessages()[index];
                  return _buildMessageTile(message);
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
        ),
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

  Widget _buildMessageTile(Message message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: ListTile(
        visualDensity: VisualDensity(vertical: -1),
        //  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 22.r,
              child: message.profilePicture == null
                  ? Text(
                      message.name[0],
                      style: GLTextStyles.manropeStyle(
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    )
                  : ClipOval(
                      child: Image.network(
                        message.profilePicture!,
                        width: 44.r,
                        height: 44.r,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Text(
                          message.name[0],
                          style: GLTextStyles.manropeStyle(
                            color: Colors.black,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
            ),
            if (message.hasUnread)
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
          message.name,
          style: GLTextStyles.manropeStyle(
              size: 14.sp,
              weight: FontWeight.w600,
              color: const Color(0xff170e2b)),
        ),
        subtitle: Row(
          children: [
            if (message.hasVoice)
              Icon(
                Iconsax.microphone_25,
                size: 16.sp,
                color:
                    message.hasUnread ? const Color(0xFF3E9E7C) : Colors.grey,
              )
            else if (message.photo == "Photo")
              Icon(
                Iconsax.gallery5,
                size: 14.sp,
                color:
                    message.hasUnread ? const Color(0xFF3E9E7C) : Colors.grey,
              )
            else if (message.photo == "Document")
              Icon(
                Iconsax.document_text5,
                size: 14.sp,
                color:
                    message.hasUnread ? const Color(0xFF3E9E7C) : Colors.grey,
              ),
            if (message.hasVoice || message.photo != null) SizedBox(width: 4.w),
            Expanded(
              child: Text(
                overflow: TextOverflow.ellipsis,
                message.hasVoice
                    ? message.voiceDuration!
                    : message.photo == "Document"
                        ? message.message ?? ""
                        : message.photo ?? message.message ?? "",
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
              message.time,
              style: GLTextStyles.manropeStyle(
                size: 10.sp,
                color: const Color(0xffA4A4A4),
                weight: FontWeight.w400,
              ),
            ),
            if (message.isRead || message.isDelivered || message.isSent)
              SizedBox(height: 8.h),
            if (message.isRead)
              Icon(
                Icons.done_all,
                size: 16.sp,
                color: Color(0xFF30C0E0),
              )
            else if (message.isDelivered)
              Icon(
                Icons.done_all,
                size: 16.sp,
                color: Color(0xffA4A4A4),
              )
            else if (message.isSent)
              Icon(
                Icons.done,
                size: 16.sp,
                color: Color(0xffA4A4A4),
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(name: message.name,),
              ));
          // print("Message tapped: ${message.name}");
        },
      ),
    );
  }
}
