import 'package:blackout_launcher/constants/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserSettingsDB {
  static final _box = Hive.box(HiveBoxNames.userSettings.name);

  static dynamic getUserSetting(String key) {
    return _box.get(key);
  }

  static void setUserSetting(String key, dynamic value) {
    _box.put(key, value);
  }
}
