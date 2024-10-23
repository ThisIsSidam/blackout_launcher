import 'package:blackout_launcher/constants/assets.dart';
import 'package:blackout_launcher/database/app_launch_db.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';

extension AppInfoPlus on AppInfo {
  /// Returns the icon of the app in the form of image.
  /// The method adds a default icon when the app.icon is null
  Image getIconImage({double h = 32, double w = 32}) {
    if (icon != null) {
      return Image.memory(
        icon!,
        height: h,
        width: w,
      );
    }
    return Image.asset(
      Images.defaultIcon.path,
      height: h,
      width: w,
    );
  }

  List<String> get launchData {
    return AppLaunchDB.getLaunchData(packageName);
  }

  Future<void> addLaunchData() async {
    AppLaunchDB.addLaunchData(packageName);
  }

  int compareTo(AppInfo other) {
    return other.launchData.length.compareTo(launchData.length);
  }
}
