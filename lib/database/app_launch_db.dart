import 'package:blackout_launcher/constants/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppLaunchDB {
  static final _box = Hive.box(HiveBoxNames.appLaunchData.name);

  static Map<String, List<String>> getAllLaunchData() {
    return _box.toMap().cast<String, List<String>>();
  }

  static List<String> getLaunchData(String packageName) {
    return _box.get(packageName)?.cast<String>() ?? <String>[];
  }

  static List<String> addLaunchData(String packageName) {
    final launchData = getLaunchData(packageName);
    launchData.add(DateTime.now().toString());
    _box.put(packageName, launchData);
    return launchData;
  }
}
