import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_button.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_datepicker.dart';
import 'package:desaihomes_crm_application/global_widgets/custom_textfield.dart';
import 'package:desaihomes_crm_application/global_widgets/form_textfield.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotesSectionCopy extends StatefulWidget {
  final Function fetchNotes;
  final String leadId;

  const NotesSectionCopy({
    super.key,
    required this.fetchNotes,
    required this.leadId,
    required bool noteValidate,
  });

  @override
  State<NotesSectionCopy> createState() => _NotesSectionCopyState();
}

class _NotesSectionCopyState extends State<NotesSectionCopy> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  DateTime? toDate;
  bool noteValidate = false;

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> fetchNotes() async {
    await Provider.of<LeadDetailController>(context, listen: false)
        .fetchNotes(widget.leadId, context);
  }

  @override
  void initState() {
    fetchNotes();
    super.initState();
  }

  @override
  void dispose() {
    notesController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leadDetailController = Provider.of<LeadDetailController>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Notes",
              style: GLTextStyles.manropeStyle(
                size: 18,
                weight: FontWeight.w600,
                color: const Color(0xff170e2b),
              ),
            ),
            SizedBox(height: 22.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: GLTextStyles.manropeStyle(
                    color: ColorTheme.blue,
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: CustomDatePicker(
                    onDateSelected: (DateTime date) {
                      setState(() {
                        toDate = date;
                        dateController.text = formatDate(date);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            CustomTextField(
              hintText: "Notes",
              maxlines: 6,
              border: 3,
              controller: notesController,
              // errorText: remarkValidate ? "Value can't be empty" : null,
            ),
            SizedBox(height: 18.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 137.w,
                height: 45.h,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      noteValidate = notesController.text.isEmpty;
                    });
                    if (!noteValidate) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(toDate!);
                      leadDetailController.postNotes(widget.leadId,
                          formattedDate, notesController.text, context);
                      notesController.clear();
                      dateController.clear();
                    }
                    widget.fetchNotes();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF3E9E7C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: GLTextStyles.manropeStyle(
                      color: ColorTheme.white,
                      size: 17.sp,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Flexible(
              fit: FlexFit.loose,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: leadDetailController.notesModel.data?.length ?? 0,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final note = leadDetailController.notesModel.data?[index];
                  if (note == null) return const SizedBox.shrink();

                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: const Color(0xffD5D7DA))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 6, bottom: 12, left: 6, right: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Iconsax.layer, size: 16),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    DateFormat('dd-MM-yyyy').format(
                                      note.createdAt ?? DateTime.now(),
                                    ),
                                    style: GLTextStyles.interStyle(
                                        size: 14,
                                        weight: FontWeight.w400,
                                        color: const Color(0xff57595B)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          final editNoteController =
                                              TextEditingController(
                                            text: note.notes,
                                          );
                                          final editDateController =
                                              TextEditingController(
                                            text:
                                                DateFormat('yyyy-MM-dd').format(
                                              note.createdAt ?? DateTime.now(),
                                            ),
                                          );
                                          return AlertDialog(
                                            surfaceTintColor: Colors.white,
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 196, 229, 217),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 4.5,
                                                        color: const Color
                                                            .fromARGB(255, 231,
                                                            251, 244)),
                                                  ),
                                                  child: Center(
                                                      child: Icon(
                                                    Iconsax.edit,
                                                    color:
                                                        ColorTheme.desaiGreen,
                                                    size: 18.sp,
                                                  )),
                                                ),
                                                SizedBox(height: 8.h),
                                                Text(
                                                  'Edit Note',
                                                  style:
                                                      GLTextStyles.manropeStyle(
                                                    color: ColorTheme.black,
                                                    size: 18.sp,
                                                    weight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CustomDatePicker(
                                                    controller:
                                                        editDateController,
                                                    onDateSelected:
                                                        (DateTime date) {
                                                      setState(() {
                                                        toDate = date;
                                                        editDateController
                                                                .text =
                                                            formatDate(date);
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(height: 15),
                                                  FormTextField(
                                                    controller:
                                                        editNoteController,
                                                    maxLines: 4,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              CustomButton(
                                                borderColor:
                                                    ColorTheme.desaiGreen,
                                                backgroundColor:
                                                    ColorTheme.white,
                                                text: "Cancel",
                                                textColor:
                                                    ColorTheme.desaiGreen,
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                width: 120.w,
                                              ),
                                              CustomButton(
                                                borderColor: ColorTheme.white,
                                                backgroundColor:
                                                    ColorTheme.desaiGreen,
                                                text: "Save",
                                                textColor: Colors.white,
                                                width: 120.w,
                                                onPressed: () async {
                                                  final updatedNote =
                                                      editNoteController.text;
                                                  final updatedDate =
                                                      editDateController.text;
                                                  if (updatedNote.isNotEmpty &&
                                                      updatedDate.isNotEmpty) {
                                                    leadDetailController
                                                        .editNotes(
                                                      note.id,
                                                      updatedNote,
                                                      updatedDate,
                                                      context,
                                                    );
                                                    widget.fetchNotes();
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Iconsax.edit_2,
                                      size: 18,
                                      color: ColorTheme.lightBlue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          surfaceTintColor: Colors.white,
                                          title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 50.w,
                                                height: 50.h,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffFEE4E2),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 4.5,
                                                      color: const Color(
                                                          0xffFEF3F2)),
                                                ),
                                                child: Center(
                                                    child: Icon(
                                                  Iconsax.trash,
                                                  color:
                                                      const Color(0xffF9A7A4),
                                                  size: 18.sp,
                                                )),
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                'Confirm Delete',
                                                style:
                                                    GLTextStyles.manropeStyle(
                                                  color: ColorTheme.black,
                                                  size: 18.sp,
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Text(
                                            'Are you sure you want to delete?',
                                            style: GLTextStyles.manropeStyle(
                                              color: ColorTheme.blue,
                                              size: 15.sp,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                          actions: [
                                            CustomButton(
                                              borderColor: ColorTheme.logoutRed,
                                              backgroundColor: ColorTheme.white,
                                              text: "Cancel",
                                              textColor: ColorTheme.logoutRed,
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              width: 120.w,
                                            ),
                                            CustomButton(
                                              borderColor: ColorTheme.white,
                                              backgroundColor:
                                                  ColorTheme.logoutRed,
                                              text: "Confirm",
                                              textColor: Colors.white,
                                              width: 120.w,
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                await leadDetailController
                                                    .deleteNotes(
                                                  note.id,
                                                  context,
                                                );
                                                widget.fetchNotes();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Iconsax.trash,
                                      size: 18,
                                      color: ColorTheme.red,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 26.w),
                              Expanded(
                                child: Text(
                                  note.notes ?? '',
                                  style: GLTextStyles.interStyle(
                                      size: 14,
                                      weight: FontWeight.w400,
                                      color: const Color(0xff170e2b)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
