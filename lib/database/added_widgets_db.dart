import 'package:blackout_launcher/constants/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddedWidgetsDB {
  final _box = Hive.box(HiveBoxNames.addedWidgets.name);
}
