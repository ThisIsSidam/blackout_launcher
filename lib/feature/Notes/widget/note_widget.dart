// NoteWidget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/notes_modal.dart';
import '../provider/notes_provider.dart';

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
    if (mounted) {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
    }
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
    return Row(
      children: [
        Flexible(
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.only(left: 12),
            margin: const EdgeInsets.symmetric(vertical: 4),
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
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          iconSize: 20,
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.delete,
          ),
          onPressed: () {
            ref.read(notesProvider).removeNote(widget.note);
          },
        ),
      ],
    );
  }
}
