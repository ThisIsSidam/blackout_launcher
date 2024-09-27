import 'package:blackout_launcher/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';

extension AppInfoPlus on AppInfo {
  Image get iconImage {
    if (icon != null) return Image.memory(icon!);
    return Image.asset(Images.defaultIcon.path);
  } 
}