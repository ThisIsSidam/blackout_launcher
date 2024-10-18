import 'package:blackout_launcher/feature/Notes/modal/notes_modal.dart';
import 'package:blackout_launcher/feature/Notes/provider/notes_provider.dart';
import 'package:blackout_launcher/feature/Notes/widget/edit_panel.dart';
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
            shrinkWrap: true,
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final NoteModal item = notes.removeAt(oldIndex);
              notes.insert(newIndex, item);
              notesProviderObj.updateNotes(notes);
            },
            footer: _NewNoteField(),
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
}

class _NewNoteField extends ConsumerStatefulWidget {
  const _NewNoteField();

  @override
  ConsumerState<_NewNoteField> createState() => _NewNoteFieldState();
}

class _NewNoteFieldState extends ConsumerState<_NewNoteField> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      hasFocus = focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _saveNote() {
    final text = controller.text;
    if (text.isNotEmpty) {
      ref.read(notesProvider).addNewNote(text);
      controller.clear();
      focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Write a new note',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            maxLines: null,
          ),
        ),
        if (hasFocus)
          Row(
            children: [
              const EditPanel(),
              const Spacer(),
              TextButton(
                onPressed: _saveNote,
                child: const Text('Save'),
              ),
            ],
          ),
      ],
    );
  }
}
