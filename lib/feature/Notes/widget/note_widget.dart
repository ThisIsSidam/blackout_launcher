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
    return ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tilePadding: EdgeInsets.symmetric(horizontal: 4),
        showTrailingIcon: false,
        title: Container(
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
        children: [_buildEditPanel(context, focusNode)]);
  }

  Widget _buildEditPanel(BuildContext context, FocusNode focusNode) {
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {},
            child: Text('[ ]'),
          ),
          TextButton(onPressed: () {}, child: Text('Break')),
          Spacer(),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              ref.read(notesProvider).removeNote(widget.note);
            },
          )
        ],
      ),
    );
  }
}
