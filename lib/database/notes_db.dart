import 'package:blackout_launcher/constants/hive_boxes.dart';
import 'package:blackout_launcher/feature/Notes/modal/notes_modal.dart';
import 'package:hive/hive.dart';

class NotesDB {
  static final Box<dynamic> _box = Hive.box(HiveBox.notes.name);
  static const String _noteKey = 'NOTES';

  /// Returns all the notes present in the database
  static List<NoteModal> getNotes() {
    return _box.get(_noteKey)?.cast<NoteModal>() ?? <NoteModal>[];
  }

  /// Adds a note.
  static Future<void> addData(NoteModal note) async {
    final List<NoteModal> notes = getNotes();
    notes.add(note);
    await _box.put(_noteKey, notes);
  }

  /// Match and remove a note 
  static Future<void> removeData(NoteModal note) async {
    final List<NoteModal> notes = getNotes();
    for (final NoteModal n in notes) {
      if (n == note) {
        notes.remove(n); 
        break;
      }
    }
    await _box.put(_noteKey, notes);
  }
}