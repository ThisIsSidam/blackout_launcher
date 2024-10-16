import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:blackout_launcher/pages/settings_screen/favourites_provider.dart';
import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

enum LauncherType {
  iconOnly,
  iconAndText,
  tile,
}

class AppLauncher extends ConsumerWidget {
  const AppLauncher({
    super.key,
    required this.app,
    this.launcherType = LauncherType.iconAndText,
    this.iconSize = 48,
  });

  final AppInfo app;
  final LauncherType launcherType;

  /// The size of the icon.
  /// Only for LauncherType.iconAndText and LauncherType.iconOnly
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouritesProvider).favourites;
    final isFavourite = favourites.contains(app.packageName);

    return MenuAnchor(
        menuChildren: [
          _buildFavouriteButton(ref, isFavourite),
          MenuItemButton(
            leadingIcon: const Icon(Icons.info_outline),
            child: const Text('App Info'),
            onPressed: () async {
              if (Platform.isAndroid) {
                final intent = AndroidIntent(
                  action: 'action_application_details_settings',
                  data: 'package:${app.packageName}',
                );
                await intent.launch();
              }
            },
          )
        ],
        builder: (context, controller, child) {
          late Widget child;
          if (launcherType == LauncherType.iconOnly) {
            child = _buildIconButton();
          } else if (launcherType == LauncherType.iconAndText) {
            child = _buildIconTextButton();
          } else if (launcherType == LauncherType.tile) {
            child = _buildTileButton(context);
          } else {
            throw '[AppLauncher] Unimplemented launcher widget type.';
          }

          return GestureDetector(
            onTap: () => InstalledApps.startApp(app.packageName),
            onLongPress: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: child,
          );
        });
  }

  Widget _buildIconTextButton() {
    return SizedBox(
      width: iconSize,
      child: Column(
        children: [
          app.getIconImage(h: iconSize, w: iconSize),
          Text(
            app.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget _buildIconButton() {
    return app.getIconImage(h: iconSize, w: iconSize);
  }

  Widget _buildTileButton(BuildContext context) {
    return ListTile(
        tileColor: Colors.black12,
        leading: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 24, minWidth: 24),
            child: app.getIconImage()),
        title: Text(
          app.name,
          style: Theme.of(context).textTheme.bodySmall,
        ));
  }

  Widget _buildFavouriteButton(WidgetRef ref, bool isFavourite) {
    return isFavourite
        ? MenuItemButton(
            leadingIcon: Icon(Icons.heart_broken),
            onPressed: () {
              ref.read(favouritesProvider).removeApp(app.packageName);
            },
            child: Text('Unfavourite'),
          )
        : MenuItemButton(
            leadingIcon: Icon(Icons.favorite_outline),
            onPressed: () {
              ref.read(favouritesProvider).addApp(app.packageName);
            },
            child: Text('Favourite'),
          );
  }
}