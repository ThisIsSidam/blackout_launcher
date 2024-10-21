import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';

import '../../../../constants/enums/dock_styles.dart';
import '../../../../shared/providers/user_settings_provider.dart';
import '../../../favourite_screen/providers/favourites_provider.dart';
import '../app_launcher/app_launcher.dart';

class HomeScreenDock extends ConsumerWidget {
  const HomeScreenDock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> favourites = ref.watch(favouritesProvider).favourites;
    if (favourites.isEmpty) return const SizedBox.shrink();

    final settings = ref.watch(userSettingProvider);
    return AsyncValueWidget(
      value: ref.read(appListProvider),
      data: (apps) {
        List<AppInfo> favouriteApps =
            apps.where((app) => favourites.contains(app.packageName)).toList();

        final dockStyle = settings.dockStyle;

        return Padding(
          padding: EdgeInsets.all(dockStyle == DockStyle.floating ? 8 : 0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: dockStyle == DockStyle.floating
                  ? BorderRadius.circular(25)
                  : dockStyle == DockStyle.roundedEdgeSnap
                      ? BorderRadius.vertical(top: Radius.circular(25))
                      : BorderRadius.circular(0), // Last is DockStyle.edgeSnap
              color: Theme.of(context)
                  .colorScheme
                  .surface
                  .withOpacity(settings.dockOpacity),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final children = favouriteApps.reversed
                      .map((app) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: AppLauncher(
                              app: app,
                              launcherType: LauncherType.iconOnly,
                              iconSize: settings.iconSize,
                            ),
                          ))
                      .toList();

                  if (favouriteApps.length * (settings.iconSize + 8) <=
                      constraints.maxWidth) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: children,
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: children,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
