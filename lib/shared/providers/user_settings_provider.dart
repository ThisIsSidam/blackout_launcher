import 'package:blackout_launcher/constants/enums/app_sort_method.dart';
import 'package:blackout_launcher/database/user_settings_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/enums/dock_styles.dart';
import '../../constants/enums/swipe_gestures.dart';

class SettingsNotifier extends ChangeNotifier {
  double get iconSize {
    final dynamic value = UserSettingsDB.getUserSetting('iconScale');
    if (value == null || value is! double) {
      return 48.0; // Default Value
      // Should always be one of scaleValues from the settings
    }
    return value;
  }

  set iconSize(double value) {
    UserSettingsDB.setUserSetting('iconScale', value);
    notifyListeners();
  }

  double get numberOfColumns {
    final dynamic value = UserSettingsDB.getUserSetting('numberOfColumns');
    if (value == null || value is! double) {
      return 5;
    }
    return value;
  }

  set numberOfColumns(double value) {
    UserSettingsDB.setUserSetting('numberOfColumns', value);
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

  SwipeGesture get rightSwipeGestureAction {
    final dynamic value =
        UserSettingsDB.getUserSetting('rightSwipeGestureAction');
    if (value == null || value is! String) {
      return SwipeGesture.openDrawer;
    }
    return SwipeGesture.fromString(value);
  }

  set rightSwipeGestureAction(SwipeGesture value) {
    UserSettingsDB.setUserSetting('rightSwipeGestureAction', value.toString());
    notifyListeners();
  }

  SwipeGesture get leftSwipeGestureAction {
    final dynamic value =
        UserSettingsDB.getUserSetting('leftSwipeGestureAction');
    if (value == null || value is! String) {
      return SwipeGesture.none;
    }
    return SwipeGesture.fromString(value);
  }

  set leftSwipeGestureAction(SwipeGesture value) {
    UserSettingsDB.setUserSetting('leftSwipeGestureAction', value.toString());
    notifyListeners();
  }

  String get rightSwipeOpenApp {
    final dynamic value = UserSettingsDB.getUserSetting('rightSwipeOpenApp');
    if (value == null || value is! String) {
      return 'none';
    }
    return value;
  }

  set rightSwipeOpenApp(String packageName) {
    UserSettingsDB.setUserSetting('rightSwipeOpenApp', packageName);
    notifyListeners();
  }

  String get leftSwipeOpenApp {
    final dynamic value = UserSettingsDB.getUserSetting('leftSwipeOpenApp');
    if (value == null || value is! String) {
      return 'none';
    }
    return value;
  }

  set leftSwipeOpenApp(String packageName) {
    UserSettingsDB.setUserSetting('leftSwipeOpenApp', packageName);
    notifyListeners();
  }

  double get dockOpacity {
    final dynamic value = UserSettingsDB.getUserSetting('dockOpacity');
    if (value == null || value is! double) {
      return 1.0;
    }
    if (value >= 0.0 && value <= 1.0) {
      return value;
    }
    throw 'Dock opacity must be between 0.0 and 1.0';
  }

  set dockOpacity(double value) {
    UserSettingsDB.setUserSetting('dockOpacity', value);
    notifyListeners();
  }

  bool get enableDock {
    final dynamic value = UserSettingsDB.getUserSetting('enableDock');
    if (value == null || value is! bool) {
      return true;
    }
    return value;
  }

  set enableDock(bool value) {
    UserSettingsDB.setUserSetting('enableDock', value);
    notifyListeners();
  }

  DockStyle get dockStyle {
    final dynamic value = UserSettingsDB.getUserSetting('dockStyle');
    if (value == null || value is! String) {
      return DockStyle.floating;
    }
    return DockStyle.fromString(value);
  }

  set dockStyle(DockStyle value) {
    UserSettingsDB.setUserSetting('dockStyle', value.toString());
    notifyListeners();
  }

  AppSortMethod get appSortMethod {
    final dynamic value = UserSettingsDB.getUserSetting('appSortMethod');
    if (value == null || value is! String) {
      return AppSortMethod.alphabetical;
    }
    return AppSortMethod.fromString(value);
  }

  set appSortMethod(AppSortMethod value) {
    UserSettingsDB.setUserSetting('appSortMethod', value.toString());
    notifyListeners();
  }
}

final userSettingProvider = ChangeNotifierProvider<SettingsNotifier>(
  (ref) => SettingsNotifier(),
);
