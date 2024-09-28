import 'package:blackout_launcher/feature/Notes/modal/notes_modal.dart';
import 'package:blackout_launcher/feature/Notes/provider/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesSection extends ConsumerWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final List<NoteModal> notes = ref.watch(notesProvider).notes;
    notes.sort((a, b) => a.compareTo(b));

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Notes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: StatefulBuilder(
               builder: (context, setState) {
                return ReorderableListView(
                  shrinkWrap: true,
                  children: [
                    for (NoteModal note in notes)
                      _buildNoteWidget(note, ref),
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final NoteModal item = notes.removeAt(oldIndex);
                    notes.insert(newIndex, item);
                    ref.read(notesProvider).updateNotes(notes);
                    setState(() {});
                  },
                );
              }
            ),
          ),
          _buildNewNoteButton(ref)
        ],
      ),
    );
  }

  Widget _buildNoteWidget(NoteModal note, WidgetRef ref) {

    final TextEditingController controller = TextEditingController(
      text: note.text
    );

    return Container(
      key: ValueKey(note.id),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        decoration: null,
        // expands: true,
        // minLines: null,
        maxLines: null,
        onChanged: (_) {
          note.text = controller.text;
          ref.read(notesProvider).updateNote(note);
        } ,
      ),
    );
  }

  Widget _buildNewNoteButton(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(8)
          )
        ),
        onPressed: () { 
          ref.read(notesProvider).addNewNote();
        }, 
        child: const Icon(Icons.add)
      ),
    );
  }
}