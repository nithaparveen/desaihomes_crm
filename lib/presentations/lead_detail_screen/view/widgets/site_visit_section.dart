import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SiteVisitSection extends StatefulWidget {
  final Function fetchSiteVisits;
  final String leadId;

  const SiteVisitSection({
    super.key,
    required this.fetchSiteVisits,
    required this.leadId,
    required bool remarkValidate,
  });

  @override
  State<SiteVisitSection> createState() => _SiteVisitSectionState();
}

class _SiteVisitSectionState extends State<SiteVisitSection> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController siteVisitController = TextEditingController();
  bool remarkValidate = false;

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final leadDetailController = Provider.of<LeadDetailController>(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Site Visits", style: GLTextStyles.cabinStyle(size: 18)),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xff1A3447)),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  selectDate(context, dateController);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: siteVisitController,
                decoration: InputDecoration(
                  labelText: "Remarks",
                  errorText: remarkValidate ? "Value can't be empty" : null,
                  errorStyle: GLTextStyles.robotoStyle(
                    color: ColorTheme.red,
                    size: 14,
                    weight: FontWeight.w400,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xff1A3447),
                    ),
                  ),
                ),
                maxLines: 3,
              ),
            ),
            SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.3,
              child: MaterialButton(
                color: ColorTheme.blue,
                onPressed: () {
                  setState(() {
                    remarkValidate = siteVisitController.text.isEmpty;
                  });
                  if (!remarkValidate) {
                    leadDetailController.postSiteVisits(
                      widget.leadId,
                      dateController.text,
                      siteVisitController.text,
                      context,
                    );
                    siteVisitController.clear();
                    dateController.clear();
                  }
                  widget.fetchSiteVisits();
                },
                child: Text(
                  "Submit",
                  style: GLTextStyles.robotoStyle(
                    color: ColorTheme.white,
                    size: 16,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    leadDetailController.siteVisitModel.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final siteVisit =
                      leadDetailController.siteVisitModel.data?[index];
                  if (siteVisit == null) return const SizedBox.shrink();

                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(siteVisit.siteVisitRemarks ?? ''),
                        Text(
                          DateFormat('dd/MM/yyyy').format(
                            siteVisit.siteVisitDate ?? DateTime.now(),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      leadDetailController.deleteSiteVisits(
                                        siteVisit.id,
                                        context,
                                      );
                                      widget.fetchSiteVisits();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outline, size: 22),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final editSiteVisitController =
                                    TextEditingController(
                                  text: siteVisit.siteVisitRemarks,
                                );
                                final editDateController =
                                    TextEditingController(
                                  text: DateFormat('yyyy-MM-dd').format(
                                    siteVisit.siteVisitDate ?? DateTime.now(),
                                  ),
                                );
                                return AlertDialog(
                                  title: const Text('Edit Note'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: editDateController,
                                        decoration: const InputDecoration(
                                          labelText: 'Date',
                                          prefixIcon: Icon(
                                            Icons.calendar_today_outlined,
                                            size: 20,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xff1A3447),
                                            ),
                                          ),
                                        ),
                                        readOnly: true,
                                        onTap: () {
                                          selectDate(
                                              context, editDateController);
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      TextField(
                                        controller: editSiteVisitController,
                                        decoration: const InputDecoration(
                                          labelText: 'Note',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xff1A3447),
                                            ),
                                          ),
                                        ),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final updatedRemark =
                                            editSiteVisitController.text;
                                        final updatedDate =
                                            editDateController.text;
                                        if (updatedRemark.isNotEmpty &&
                                            updatedDate.isNotEmpty) {
                                          leadDetailController.editSiteVisits(
                                            siteVisit.id,
                                            updatedRemark,
                                            updatedDate,
                                            context,
                                          );
                                          widget.fetchSiteVisits();
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit, size: 22),
                        ),
                      ],
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
}
