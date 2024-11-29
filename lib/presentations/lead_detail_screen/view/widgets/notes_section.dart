import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:desaihomes_crm_application/presentations/lead_detail_screen/controller/lead_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotesSection extends StatefulWidget {
  final Function fetchNotes;
  final String leadId;

  const NotesSection({
    super.key,
    required this.fetchNotes,
    required this.leadId,
    required bool noteValidate,
  });

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  final TextEditingController noteController = TextEditingController();
  bool noteValidate = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final leadDetailController = Provider.of<LeadDetailController>(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Notes", style: GLTextStyles.cabinStyle(size: 18)),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: "Notes",
                  errorStyle: GLTextStyles.robotoStyle(
                    color: ColorTheme.red,
                    size: 14,
                    weight: FontWeight.w400,
                  ),
                  errorText: noteValidate ? "Value can't be empty" : null,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xff1A3447)),
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
                  // if (noteController.text.isNotEmpty) {
                  //   leadDetailController.postNotes(
                  //     widget.leadId,
                  //     noteController.text,
                  //     context,
                  //   );
                  //   noteController.clear();
                  //   setState(() {
                  //     noteValidate = false;
                  //   });
                  //   widget.fetchNotes(widget.leadId);
                  // } else {
                  //   setState(() {
                  //     noteValidate = true;
                  //   });
                  // }
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
                itemCount: leadDetailController.notesModel.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final note = leadDetailController.notesModel.data![index];
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.notes ?? ''),
                        Text(note.createdUser?.name ?? ''),
                        Text(DateFormat('dd/MM/yyyy')
                            .format(note.createdAt ?? DateTime.now())),
                      ],
                    ),
                    trailing: _buildTrailingActions(
                        context, leadDetailController, note),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingActions(
      BuildContext context, LeadDetailController controller, note) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _confirmDelete(context, controller, note.id),
          icon: const Icon(Icons.delete_outline, size: 22),
        ),
        IconButton(
          onPressed: () => _editNoteDialog(context, controller, note),
          icon: const Icon(Icons.edit, size: 22),
        ),
      ],
    );
  }

  void _confirmDelete(
      BuildContext context, LeadDetailController controller, int? noteId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          actions: [
            TextButton(
              onPressed: () {
                controller.deleteNotes(noteId, context);
                widget.fetchNotes(widget.leadId);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editNoteDialog(
      BuildContext context, LeadDetailController controller, note) {
    final TextEditingController editNoteController =
        TextEditingController(text: note.notes);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: TextField(
            controller: editNoteController,
            decoration: const InputDecoration(
              labelText: 'Note',
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Color(0xff1A3447)),
              ),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // final updatedNote = editNoteController.text;
                // if (updatedNote.isNotEmpty) {
                //   controller.editNotes(note.id, updatedNote, context);
                //   widget.fetchNotes(widget.leadId);
                //   Navigator.of(context).pop();
                // }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
