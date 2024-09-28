import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.app,
    this.size = 50,
    super.key
  });

  final AppInfo app;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: GestureDetector(
        onTap: () => InstalledApps.startApp(app.packageName),
        child: Column(
          children: [
            app.getIconImage(h: size, w: size),
          ],
        ),
      ),
    );
  }
}