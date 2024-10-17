import 'package:blackout_launcher/database/user_settings_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends ChangeNotifier {
  double get iconScale {
    final dynamic value = UserSettingsDB.getUserSetting('iconScale');
    if (value == null || value is! double) {
      return 38.0; // Default Value
      // Should always be one of scaleValues from the settings
    }
    return value;
  }

  set iconScale(double value) {
    UserSettingsDB.setUserSetting('iconScale', value);
    notifyListeners();
  }

  bool get hideStatusBar {
    final dynamic value = UserSettingsDB.getUserSetting('hideStatusBar');
    if (value == null || value is! bool) {
      return false;
    }
    return value;
  }

  set hideStatusBar(bool value) {
    UserSettingsDB.setUserSetting('hideStatusBar', value);
    notifyListeners();
  }

  bool get hideNavigationBar {
    final dynamic value = UserSettingsDB.getUserSetting('hideNavigationBar');
    if (value == null || value is! bool) {
      return false;
    }
    return value;
  }

  set hideNavigationBar(bool value) {
    UserSettingsDB.setUserSetting('hideNavigationBar', value);
    notifyListeners();
  }
}

final userSettingProvider = ChangeNotifierProvider<SettingsNotifier>(
  (ref) => SettingsNotifier(),
);
