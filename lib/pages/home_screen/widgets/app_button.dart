import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.app,
    this.width = 60,
    super.key
  });

  final AppInfo app;
  final double width;

  @override
  Widget build(BuildContext context) {
    final double hw = (width/3) * 2; // icon height and width
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () => InstalledApps.startApp(app.packageName),
        child: Column(
          children: [
            app.getIconImage(h: hw, w: hw),
            Text(
              app.name,
              style: Theme.of(context).textTheme.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}