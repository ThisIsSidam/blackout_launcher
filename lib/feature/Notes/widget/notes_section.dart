import 'package:blackout_launcher/feature/Notes/modal/notes_modal.dart';
import 'package:blackout_launcher/feature/Notes/provider/notes_provider.dart';
import 'package:blackout_launcher/feature/Notes/widget/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesSection extends HookConsumerWidget {
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
            // To hide the child margins when reordering
            proxyDecorator: (child, index, animation) {
              return Material(
                type: MaterialType.transparency,
                child: child,
              );
            },
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
              for (NoteModal note in notes)
                _buildNoteWidget(note, notesProviderObj)
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildNoteWidget(NoteModal note, NotesNotifier notesNotif) {
    return NoteWidget(
      key: ValueKey(note.id),
      note: note,
      focusNode: notesNotif.getFocusNode(note.id),
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
              ref.read(notesProvider).addNewNote('');
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            label: Text('Add Note',
                style: Theme.of(context).textTheme.titleSmall)));
  }
}
