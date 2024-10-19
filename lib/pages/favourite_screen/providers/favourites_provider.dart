import 'package:blackout_launcher/database/app_categories_db.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavouritesNotifier extends ChangeNotifier {
  List<String> favourites = AppCategoriesDB.getApps('favourites');

  void addApp(String packageName) {
    if (favourites.contains(packageName)) return;

    AppCategoriesDB.addData('favourites', packageName);
    favourites = AppCategoriesDB.getApps('favourites');
    debugPrint('addApp: $packageName');
    notifyListeners();
  }

  void removeApp(String packageName) {
    if (!favourites.contains(packageName)) return;

    AppCategoriesDB.removeData('favourites', packageName);
    favourites = AppCategoriesDB.getApps('favourites');
    notifyListeners();
  }
}

final favouritesProvider = ChangeNotifierProvider<FavouritesNotifier>((ref) {
  return FavouritesNotifier();
});
