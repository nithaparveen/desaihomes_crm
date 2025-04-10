import 'dart:developer';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/new_whatsapp_screen/view/widgets/whatsapp_lead_convertor.dart';
import 'package:desaihomes_crm_application/repository/api/login_screen/pusher_service.dart';
import 'package:desaihomes_crm_application/repository/api/whatsapp_screen/model/template_model.dart';
import 'package:desaihomes_crm_application/repository/api/whatsapp_screen/model/whatsapp_lead_list_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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
  Set<int> newMessageLeadIds = {};
  List<int> selectedLeadIds = [];
  final PusherService _pusherService = PusherService();

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  FocusNode searchFocusNode = FocusNode();

  // To track the currently active lead ID for Pusher
  String? currentActiveLeadId;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });

    // Initialize Pusher without subscribing to a specific lead yet
    _pusherService.initializePusher();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  fetchData() async {
    await Provider.of<WhatsappControllerCopy>(context, listen: false)
        .fetchConversations(context);
    await Provider.of<WhatsappControllerCopy>(context, listen: false)
        .fetchWhatsappLeads(context);

    // Subscribe to the general channel to listen for any new messages
    _subscribeToGeneralPusherChannel();
  }

  void _subscribeToGeneralPusherChannel() {
    _pusherService.subscribeToChannelWithId(
        // Pass an empty string or "all" to listen for all messages
        "all",
        _handleNewMessage,
        context);
  }

  void _handleNewMessage(dynamic data) {
    try {
      final Map<String, dynamic> messageData = data;

      final leadId = messageData['lead_id']?.toString();
      if (leadId == null) {
        log("Received message without lead_id");
        return;
      }

      final parsedLeadId = int.tryParse(leadId);
      if (parsedLeadId == null) return;

      final newMessage = ConversationModel(
        message: messageData['message'] ?? '',
        createdAt: DateTime.tryParse(messageData['created_at'] ?? '') ??
            DateTime.now(),
        msgType: messageData['msg_type'] ?? 'Text',
        leadId: parsedLeadId,
      );

      final whatsappController =
          Provider.of<WhatsappControllerCopy>(context, listen: false);

      whatsappController.addMessageToListt(newMessage);

      setState(() {
        newMessageLeadIds.add(parsedLeadId);
      });

      // // Remove the green dot after 3 seconds
      // Future.delayed(const Duration(seconds: 8), () {
      //   if (mounted) {
      //     setState(() {
      //       newMessageLeadIds.remove(parsedLeadId);
      //     });
      //   }
      // });

      whatsappController.fetchConversations(context);

      if (currentActiveLeadId == leadId) {
        whatsappController.fetchChats(leadId, context);
      }
    } catch (e) {
      log("Error handling new message: $e");
    }
  }

  // Method to call when a lead/conversation is selected
  void onLeadSelected(String leadId) {
    currentActiveLeadId = leadId;

    // Fetch the chats for this specific lead
    Provider.of<WhatsappControllerCopy>(context, listen: false)
        .fetchChats(leadId, context);
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
            .toSet()
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
        // WHATSAPP TO LEAD CONVERTION - Ui completed, conversion is pending
        // floatingActionButton: FloatingActionButton(
        //   shape: const CircleBorder(),
        //   onPressed: () {
        //     final whatsappController =
        //         Provider.of<WhatsappControllerCopy>(context, listen: false);

        //     final List<WhatsappToLeadListModel> modelList =
        //         whatsappController.whatsappToLeadList;

        //     final List<String> leadsList = modelList
        //         .where((lead) => lead.name != null)
        //         .map((lead) => lead.name!)
        //         .toList();
        //     final List<int> leadsListId = modelList
        //         .where((lead) => lead.id != null)
        //         .map((lead) => lead.id!)
        //         .toList();

        //     print('Final leadsList: $leadsList');

        //     showDialog(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return WhatsappLeadConvertor(
        //           leadIds: leadsListId,
        //           leads: leadsList,
        //           onConvert: (selectedLeads) {
        //             Provider.of<WhatsappControllerCopy>(context, listen: false)
        //                 .onConvert(selectedLeads, context);
        //             print('Converting leads: $selectedLeads');
        //           },
        //         );
        //       },
        //     );
        //   },
        //   backgroundColor: const Color(0xff170E2B),
        //   child: Icon(Icons.arrow_outward, color: Colors.white, size: 26.sp),
        // ),
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          color: ColorTheme.desaiGreen,
          elevation: 0.5,
          onRefresh: () => fetchData(),
          child: Consumer<WhatsappControllerCopy>(
              builder: (context, controller, _) {
            // if (controller.isLoading) {
            //   return Padding(
            //     padding: EdgeInsets.only(right: 16.w),
            //     child: Center(
            //       child: LoadingAnimationWidget.fourRotatingDots(
            //         color: const Color(0xffF0F6FF),
            //         size: 32,
            //       ),
            //     ),
            //   );
            // }
            final List<ConversationModel> messages =
                controller.conversationModel;

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
                String templateContent, List<int> leadIds, Datum templateData) {
              String headerType = "";
              List<String> headers = [];
              List<String> filePaths = [];

              /// Extract Header Type & Headers from Template Components
              for (var component in templateData.components ?? []) {
                if (component.type == "HEADER") {
                  headerType = component.format.toLowerCase();

                  if (headerType == "text") {
                    headers = [component.text ?? ""];
                  } else {
                    final example = component.example?.toJson();
                    headers =
                        List<String>.from(example?["header_handle"] ?? []);

                    // Get file_path if available
                    if (example?["file_path"] != null) {
                      if (example["file_path"] is String) {
                        filePaths = [example["file_path"]];
                      } else if (example["file_path"] is List) {
                        filePaths = List<String>.from(example["file_path"]);
                      }
                    }
                  }
                  break;
                }
              }

              // Use file_path if available, otherwise fall back to header_handle
              final mediaUrls = filePaths.isNotEmpty ? filePaths : headers;
              final mediaUrl = mediaUrls.isNotEmpty ? mediaUrls.first : null;

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    surfaceTintColor: Colors.white,
                    backgroundColor: Colors.white,
                    insetPadding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                    title: const SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Icon(Iconsax.warning_2, color: Color(0xffFF9C8E))
                        ],
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    content: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
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

                            /// Header Preview Section
                            if (headerType == "image" && mediaUrl != null)
                              _buildImagePreview(context, mediaUrl),
                            if (headerType == "document" && mediaUrl != null)
                              _buildDocumentPreview(context, mediaUrl),
                            if (headerType == "text" && headers.isNotEmpty)
                              _buildTextPreview(headers.first),

                            /// Template Text Preview
                            _buildTemplatePreview(templateContent),
                          ],
                        ),
                      ),
                    ),
                    actionsPadding:
                        const EdgeInsets.only(right: 16, bottom: 16, left: 16),
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
                          String parameterFormat =
                              templateData.parameterFormat ?? "POSITIONAL";

                          List<String> headers = [];
                          String headerType = "";

                          for (var component in templateData.components ?? []) {
                            if (component.type == "HEADER") {
                              headerType = component.format.toLowerCase();

                              log("Example Object: ${component.example?.toJson()}");

                              if (component.example != null) {
                                var exampleJson = component.example!.toJson();
                                if (exampleJson.containsKey("header_handle")) {
                                  headers = List<String>.from(
                                      exampleJson["header_handle"] ?? []);
                                }
                              }
                              break;
                            }
                          }
                          Navigator.of(context).pop();
                          List<int> tempLeadIds = List.from(selectedLeadIds);
                          clearSelection();
                          Provider.of<WhatsappControllerCopy>(context,
                                  listen: false)
                              .sendMultiMessages(
                                  tempLeadIds,
                                  templateName,
                                  "en_US",
                                  templateContent,
                                  parameterFormat,
                                  headers,
                                  headerType,
                                  context);
                          fetchData();
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
                                          const Duration(milliseconds: 300),
                                          () {
                                        log("Selected Lead IDs: $selectedLeadIds");
                                        if (selectedLeadIds.isNotEmpty) {
                                          showConfirmation(
                                              parentContext,
                                              template.name ?? "",
                                              templateContent,
                                              selectedLeadIds,
                                              template);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text("No leads selected")),
                                          );
                                        }
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
                        ),
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
                                          child: Text(
                                            message.leadName?[0] ?? "",
                                            style: GLTextStyles.manropeStyle(
                                              color: Colors.black,
                                              size: 16.sp,
                                            ),
                                          )),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: newMessageLeadIds
                                                .contains(message.leadId)
                                            ? Container(
                                                width: 15.r,
                                                height: 15.r,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF3E9E7C),
                                                  shape: BoxShape.circle,
                                                ),
                                              )
                                            : const SizedBox.shrink(),
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
                                        Icon(Iconsax.document_text5,
                                            size: 14.sp),
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
                                            ? getSmartTimestamp(
                                                message.createdAt)
                                            : '',
                                        style: GLTextStyles.manropeStyle(
                                          size: 10.sp,
                                          color: const Color(0xffA4A4A4),
                                          weight: FontWeight.w400,
                                        ),
                                      ),
                                      if (isSelectionMode)
                                        SizedBox(height: 10.w),
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
                                      setState(() {
                                        newMessageLeadIds
                                            .remove(message.leadId);
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreenCopy(
                                            contactedNumber: _formatPhoneNumber(
                                                message.phoneNumber ?? ""),
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
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, String imageUrl) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Image:',
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.blue,
              size: 14.sp,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            height: 200.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context, imageUrl),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Failed to load image'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentPreview(BuildContext context, String documentUrl) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document:',
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.blue,
              size: 14.sp,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FutureBuilder<String>(
              future: _downloadPdf(documentUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(height: 8),
                        Text('Failed to load document'),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: PDFView(
                      filePath: snapshot.data!,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: true,
                      pageFling: true,
                      onError: (error) {
                        print('PDF Error: $error');
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextPreview(String text) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Header Text:',
            style: GLTextStyles.manropeStyle(
              color: ColorTheme.blue,
              size: 14.sp,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            text,
            style: GLTextStyles.manropeStyle(
              color: Colors.black87,
              size: 13.sp,
              weight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatePreview(String templateContent) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            width: double.infinity,
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
    );
  }

  Future<String> _downloadPdf(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/temp_preview_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await Dio().download(url, filePath);
      return filePath;
    } catch (e) {
      print('Error downloading PDF: $e');
      throw e;
    }
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Failed to load image'),
                    ],
                  ),
                );
              },
            ),
          ),
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

  String _formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // If the number doesn't start with '91', prepend it
    if (!digitsOnly.startsWith('91') && digitsOnly.isNotEmpty) {
      return '91$digitsOnly';
    }

    return digitsOnly; // Return as-is if '91' already exists or if empty
  }
}
