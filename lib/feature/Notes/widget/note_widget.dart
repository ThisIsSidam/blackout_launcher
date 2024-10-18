// NoteWidget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/notes_modal.dart';
import '../provider/notes_provider.dart';
import 'edit_panel.dart';

class NoteWidget extends ConsumerStatefulWidget {
  const NoteWidget({
    required Key key,
    required this.note,
    this.focusNode,
  }) : super(key: key);

  final NoteModal note;
  final FocusNode? focusNode;

  @override
  ConsumerState<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends ConsumerState<NoteWidget> {
  late final TextEditingController controller;
  late final FocusNode focusNode;
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.note.text);
    focusNode = widget.focusNode ?? FocusNode();
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
    if (widget.focusNode == null) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            maxLines: null,
            onChanged: (val) {
              widget.note.text = val;
              ref.read(notesProvider).updateNote(widget.note);
            },
          ),
        ),
        if (hasFocus) const EditPanel(),
      ],
    );
  }
}
