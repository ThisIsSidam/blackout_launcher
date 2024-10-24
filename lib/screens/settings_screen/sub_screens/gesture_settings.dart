import 'package:blackout_launcher/shared/app_picker.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';

import '../../../constants/enums/swipe_gestures.dart';

class GestureSettings extends StatelessWidget {
  const GestureSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight + 50),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('Gestures',
                style: Theme.of(context).textTheme.headlineLarge),
          ),
        ),
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          _buildRightSwipeTile(context),
          _buildLeftSwipeTile(context),
        ],
      ),
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
            leading: Icon(
              Icons.swipe_right,
            ),
            title: Text('On right swipe',
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              controller.open();
            },
          );
        },
        menuChildren: [
          MenuItemButton(
            child: const Text('Open Drawer'),
            onPressed: () {
              userSettings.rightSwipeGestureAction = SwipeGesture.openDrawer;
            },
          ),
          MenuItemButton(
            child: const Text('Open app'),
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
            child: const Text('None'),
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
            leading: Icon(
              Icons.swipe_left,
            ),
            title: Text('On left swipe',
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              controller.open();
            },
          );
        },
        menuChildren: [
          MenuItemButton(
            child: const Text('Open app'),
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
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          MenuItemButton(
            child: const Text('None'),
            onPressed: () {
              userSettings.leftSwipeGestureAction = SwipeGesture.none;
            },
          )
        ],
      );
    });
  }
}
