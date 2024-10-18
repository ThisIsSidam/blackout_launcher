import 'package:blackout_launcher/feature/Notes/modal/notes_modal.dart';
import 'package:blackout_launcher/feature/Notes/provider/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesSection extends ConsumerWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesProviderObj = ref.watch(notesProvider);
    final List<NoteModal> notes = notesProviderObj.notes;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Notes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Flexible(
              child: ReorderableListView(
            shrinkWrap: true,
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final NoteModal item = notes.removeAt(oldIndex);
              notes.insert(newIndex, item);
              notesProviderObj.updateNotes(notes);
            },
            footer: _buildNewNoteButton(context, ref),
            children: [
              for (NoteModal note in notes) _buildNoteWidget(note, ref),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildNoteWidget(NoteModal note, WidgetRef ref) {
    final TextEditingController controller =
        TextEditingController(text: note.text);

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
        maxLines: null,
        onChanged: (_) {
          note.text = controller.text;
          ref.read(notesProvider).updateNote(note);
        },
      ),
    );
  }

  Widget _buildNewNoteButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              ref.read(notesProvider).addNewNote();
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            label: Text('Add Note',
                style: Theme.of(context).textTheme.titleSmall)));
  }
}
