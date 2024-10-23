import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:blackout_launcher/shared/providers/hidden_apps_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

import '../../../favourite_screen/providers/favourites_provider.dart';

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
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouritesProvider).favourites;
    final isFavourite = favourites.contains(app.packageName);

    return MenuAnchor(
        menuChildren: [
          _buildFavouriteButton(ref, isFavourite),
          MenuItemButton(
              leadingIcon: const Icon(Icons.remove_circle_outline),
              child: const Text('Hide App'),
              onPressed: () async {
                ref.read(hiddenAppsProvider).hideApp(app.packageName);
              }),
          MenuItemButton(
            leadingIcon: const Icon(Icons.info_outline),
            child: const Text('App Info'),
            onPressed: () async {
              await InstalledApps.openSettings(app.packageName);
            },
          ),
        ],
        builder: (context, controller, child) {
          late Widget child;
          if (launcherType == LauncherType.iconOnly) {
            child = _buildIconButton();
          } else if (launcherType == LauncherType.iconAndText) {
            child = _buildIconTextButton(context);
          } else if (launcherType == LauncherType.tile) {
            child = _buildTileButton(context);
          } else {
            throw '[AppLauncher] Unimplemented launcher widget type.';
          }

          return GestureDetector(
            onTap: () async {
              final bool? launchSuccess =
                  await InstalledApps.startApp(app.packageName);
              if (launchSuccess != null && launchSuccess) {
                print('app launched');
                app.addLaunchData();
              }
            },
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

  Widget _buildIconTextButton(BuildContext context) {
    return Column(
      children: [
        Flexible(child: app.getIconImage(h: iconSize, w: iconSize)),
        Text(
          app.name,
          style: Theme.of(context).textTheme.labelSmall,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  Widget _buildIconButton() {
    return app.getIconImage(h: iconSize, w: iconSize);
  }

  Widget _buildTileButton(BuildContext context) {
    return ListTile(
        minTileHeight: iconSize,
        tileColor: Colors.black12,
        leading: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: iconSize - 4, minWidth: iconSize - 4),
            child: app.getIconImage()),
        title: Text(
          app.name,
          style: Theme.of(context).textTheme.bodySmall,
        ));
  }

  Widget _buildFavouriteButton(WidgetRef ref, bool isFavourite) {
    return isFavourite
        ? MenuItemButton(
            leadingIcon: const Icon(Icons.heart_broken),
            onPressed: () {
              ref.read(favouritesProvider).removeApp(app.packageName);
            },
            child: const Text('Unfavourite'),
          )
        : MenuItemButton(
            leadingIcon: const Icon(Icons.favorite_outline),
            onPressed: () {
              ref.read(favouritesProvider).addApp(app.packageName);
            },
            child: const Text('Favourite'),
          );
  }
}
