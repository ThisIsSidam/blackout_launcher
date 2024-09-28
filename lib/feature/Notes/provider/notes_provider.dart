import 'package:blackout_launcher/database/notes_db.dart';
import 'package:blackout_launcher/feature/Notes/modal/notes_modal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesNotifier extends ChangeNotifier {

  List<NoteModal> notes = NotesDB.getNotes();

  void addNewNote() {
    final NoteModal note = NoteModal(
      id: DateTime.now().microsecondsSinceEpoch,
      text: ''
    );
    notes.insert(0, note);
    notifyListeners();
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

  void updateNotes(List<NoteModal> notes) {
    // notes = notes;
  }
}

final notesProvider = ChangeNotifierProvider<NotesNotifier>((ref) => NotesNotifier());