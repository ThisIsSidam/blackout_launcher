import 'package:blackout_launcher/constants/hive_boxes.dart';
import 'package:hive/hive.dart';

/// Hive Database for set of apps stored by user.
/// The categories are the favourites app and then apps
/// categorized through different tags/categories created
/// by the user.
///
/// Value would be [Map<String, Set<String>>]
class AppCategoriesDB {
  static final Box<dynamic> _box = Hive.box(HiveBoxNames.appCategories.name);

  /// Gets the list of packageNames in a certain category.
  static List<String> getApps(String category) {
    return _box.get(category)?.cast<String>() ?? <String>[];
  }

  /// Adds a packageName to the category list.
  static Future<void> addData(String category, String packageName) async {
    final List<String> apps = getApps(category);
    apps.add(packageName);
    await _box.put(category, apps);
  }

  /// Removes a packageName from a category list
  static Future<void> removeData(String category, String packageName) async {
    final List<String> apps = getApps(category);
    apps.remove(packageName);
    await _box.put(category, apps);
  }

  static List<String> getHiddenApps() {
    return _box.get('hidden_apps')?.cast<String>() ?? <String>[];
  }

  static Future<void> hideApp(String packageName) {
    final hiddenApps = getHiddenApps();
    hiddenApps.add(packageName);
    return _box.put('hidden_apps', hiddenApps);
  }
}
