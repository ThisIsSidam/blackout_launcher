import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    required this.app,
    super.key
  });

  final AppInfo app;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.black12,
      leading: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 24, 
          minWidth: 24
        ),
        child: app.getIconImage()
      ),
      title: Text(
        app.name,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () => InstalledApps.startApp(app.packageName),
    );
  }}