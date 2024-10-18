import 'package:blackout_launcher/database/notes_db.dart';
import 'package:blackout_launcher/feature/Notes/modal/notes_modal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesNotifier extends ChangeNotifier {
  List<NoteModal> notes = NotesDB.getNotes();

  // Add a map to store FocusNodes
  final Map<int, FocusNode> focusNodes = {};

  // Add method to get or create FocusNode
  FocusNode getFocusNode(int noteId) {
    if (!focusNodes.containsKey(noteId)) {
      focusNodes[noteId] = FocusNode();
    }
    return focusNodes[noteId]!;
  }

  @override
  void dispose() {
    // Clean up FocusNodes
    for (final focusNode in focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void addNewNote(String text) {
    final NoteModal note =
        NoteModal(id: DateTime.now().microsecondsSinceEpoch, text: text);
    notes.insert(0, note);
    notifyListeners();

    // NotesDB.addData(note); is not called because it is removed if
    // the note is empty. Adding text calls updateNote which then adds the
    // note to the DB.
  }

  void removeNote(NoteModal note) {
    NotesDB.removeData(note);
    notes = NotesDB.getNotes();
    notifyListeners();
  }

  void updateNote(NoteModal note) {
    NotesDB.removeData(note);
    NotesDB.addData(note);
  }

  void updateNotes(List<NoteModal> notesArgument) {
    // Clearing entire db list and then putting back in the order we want.
    NotesDB.clearNotes();
    for (final note in notesArgument) {
      NotesDB.addData(note);
    }
    notes = [...notesArgument];
    notifyListeners();
  }
}

final notesProvider =
    ChangeNotifierProvider<NotesNotifier>((ref) => NotesNotifier());
