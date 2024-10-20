import 'package:blackout_launcher/database/app_categories_db.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HiddenAppsNotifier extends ChangeNotifier {
  List<String> hiddenApps = AppCategoriesDB.getApps('favourites');

  void hideApp(String packageName) {
    if (hiddenApps.contains(packageName)) return;

    AppCategoriesDB.hideApp(packageName);
    hiddenApps = AppCategoriesDB.getHiddenApps();
    notifyListeners();
  }

  void removeApp(String packageName) {
    if (!hiddenApps.contains(packageName)) return;

    AppCategoriesDB.removeHiddenApp(packageName);
    hiddenApps = AppCategoriesDB.getHiddenApps();
    notifyListeners();
  }
}

final hiddenAppsProvider = ChangeNotifierProvider<HiddenAppsNotifier>((ref) {
  return HiddenAppsNotifier();
});
