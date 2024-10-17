import 'package:blackout_launcher/shared/app_picker.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';

import '../../../constants/enums/swipe_gestures.dart';

class ShortcutsSection extends StatelessWidget {
  const ShortcutsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Text(
            "Shortcuts",
            style:
                Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
          ),
        ),
        _buildRightSwipeTile(context),
        _buildLeftSwipeTile(context),
      ],
    );
  }

  Widget _buildRightSwipeTile(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userSettings = ref.watch(userSettingProvider);

      String subtitle = userSettings.rightSwipeGestureAction.toString();
      if (userSettings.rightSwipeGestureAction == SwipeGesture.openApp) {
        subtitle += ': ${userSettings.rightSwipeOpenApp}';
      }
      return MenuAnchor(
        builder: (context, controller, child) {
          return ListTile(
            title: Text('On right swipe',
                style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(
              subtitle,
            ),
            onTap: () {
              controller.open();
            },
          );
        },
        menuChildren: [
          MenuItemButton(
            child: Text('Open Drawer'),
            onPressed: () {
              userSettings.rightSwipeGestureAction = SwipeGesture.openDrawer;
            },
          ),
          MenuItemButton(
            child: Text('Open app'),
            onPressed: () async {
              final AppInfo? selectedApp = await showDialog<AppInfo>(
                context: context,
                builder: (context) {
                  return const AppPickerDialog();
                },
              );
              if (selectedApp != null) {
                userSettings.rightSwipeGestureAction = SwipeGesture.openApp;
                userSettings.rightSwipeOpenApp = selectedApp.packageName;
              }
            },
          ),
          MenuItemButton(
            child: Text('None'),
            onPressed: () {
              userSettings.rightSwipeGestureAction = SwipeGesture.none;
            },
          )
        ],
      );
    });
  }

  Widget _buildLeftSwipeTile(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userSettings = ref.watch(userSettingProvider);

      String subtitle = userSettings.leftSwipeGestureAction.toString();
      if (userSettings.leftSwipeGestureAction == SwipeGesture.openApp) {
        subtitle += ': ${userSettings.leftSwipeOpenApp}';
      }
      return MenuAnchor(
        builder: (context, controller, child) {
          return ListTile(
            title: Text('On left swipe',
                style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(
              subtitle,
            ),
            onTap: () {
              controller.open();
            },
          );
        },
        menuChildren: [
          MenuItemButton(
            child: Text('Open Drawer'),
            onPressed: () {
              userSettings.leftSwipeGestureAction = SwipeGesture.openDrawer;
            },
          ),
          MenuItemButton(
            child: Text('Open app'),
            onPressed: () async {
              final AppInfo? selectedApp = await showDialog<AppInfo>(
                context: context,
                builder: (context) {
                  return const AppPickerDialog();
                },
              );
              if (selectedApp != null) {
                userSettings.leftSwipeGestureAction = SwipeGesture.openApp;
                userSettings.leftSwipeOpenApp = selectedApp.packageName;
              }
            },
          ),
          MenuItemButton(
            child: Text('None'),
            onPressed: () {
              userSettings.leftSwipeGestureAction = SwipeGesture.none;
            },
          )
        ],
      );
    });
  }
}