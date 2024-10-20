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
      height: MediaQuery.sizeOf(context).height * 0.95,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Notes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SliverReorderableList(
              // To hide the child margins when reordering
              proxyDecorator: (child, index, animation) {
                return Material(
                  type: MaterialType.transparency,
                  child: child,
                );
              },
              itemCount: notes.length + 1,
              onReorder: (int oldIndex, int newIndex) {
                if (newIndex > notes.length) return;
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final NoteModal item = notes.removeAt(oldIndex);
                notes.insert(newIndex, item);
                notesProviderObj.updateNotes(notes);
              },
              itemBuilder: (BuildContext context, int index) {
                if (index == notes.length) {
                  return _buildNewNoteButton(context, ref);
                }
                return Row(
                  key: ValueKey('note_row_${notes[index].id}'),
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_indicator),
                    ),
                    Flexible(
                        child:
                            _buildNoteWidget(notes[index], notesProviderObj)),
                  ],
                );
              },
            ),
          ],
        ),
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
        key: ValueKey('new-note'),
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
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary))));
  }
}
