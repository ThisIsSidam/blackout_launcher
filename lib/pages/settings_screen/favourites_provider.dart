import 'package:blackout_launcher/database/user_pref_db.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavouritesNotifier extends ChangeNotifier {
  final favourites = AppCategoriesDB.getApps('favourites');

  void addApp(String packageName) {
    debugPrint('addApp: $packageName');
    AppCategoriesDB.addData('favourites', packageName);
    notifyListeners();
  }

  void removeApp(String packageName) {
    AppCategoriesDB.removeData('favourites', packageName);
    notifyListeners();
  }
}

final favouritesProvider = ChangeNotifierProvider<FavouritesNotifier>((ref) {
  return FavouritesNotifier();
});
