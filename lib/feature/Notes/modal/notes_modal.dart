import 'package:hive/hive.dart';

part 'notes_modal.g.dart';

@HiveType(typeId: 0)
class NoteModal {

  @HiveField(0)
  final int id;

  @HiveField(1)
  String text;

  NoteModal({
    required this.id,
    required this.text, 
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoteModal && id == other.id;
  } 

  int compareTo(NoteModal other) {
    return id - other.id;
  }

  @override
  int get hashCode => id.hashCode ^ text.hashCode;
}
