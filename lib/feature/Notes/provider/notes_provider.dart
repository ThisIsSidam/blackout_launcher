import 'package:blackout_launcher/database/notes_db.dart';
import 'package:blackout_launcher/feature/Notes/modal/notes_modal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesNotifier extends ChangeNotifier {
  List<NoteModal> notes = NotesDB.getNotes();

  // Add a map to store FocusNodes
  final Map<int, FocusNode> focusNodes = {};

  FocusNode getFocusNode(int noteId) {
    if (!focusNodes.containsKey(noteId)) {
      focusNodes[noteId] = FocusNode();
    }
    return focusNodes[noteId]!;
  }

  @override
  void dispose() {
    for (final focusNode in focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  /// Adds a new note in the list of notes (not in the database).
  /// Returns a [FocusNode] for the note which the user can use to request focus.
  /// Notes are added in the Database where text is entered in the note. This
  /// happens using the [updateNote] method.
  FocusNode addNewNote(String text) {
    final NoteModal note =
        NoteModal(id: DateTime.now().microsecondsSinceEpoch, text: text);
    notes.add(note);

    notifyListeners();
    return getFocusNode(note.id);
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

  FocusNode? getEmptyNoteFocusNode() {
    for (final note in notes) {
      if (note.isEmpty) {
        return getFocusNode(note.id);
      }
    }
    return null;
  }
}

final notesProvider =
    ChangeNotifierProvider<NotesNotifier>((ref) => NotesNotifier());
