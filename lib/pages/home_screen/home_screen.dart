import 'package:blackout_launcher/pages/home_screen/widgets/app_launcher/app_launcher.dart';
import 'package:blackout_launcher/pages/home_screen/widgets/clock.dart';
import 'package:blackout_launcher/pages/home_screen/widgets/home_drawer.dart';
import 'package:blackout_launcher/pages/settings_screen/favourites_provider.dart';
import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:installed_apps/app_info.dart';

import '../../router/app_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = ref.watch(userSettingProvider);
    return GestureDetector(
      // For opening the drawer on slide
      onPanEnd: (details) {
        // Threshold to determine if the gesture is primarily horizontal
        const double threshold = 1; // Increase to make it stricter

        // Calculate the absolute values of vertical and horizontal velocities
        double vx = details.velocity.pixelsPerSecond.dx.abs();
        double vy = details.velocity.pixelsPerSecond.dy.abs();

        // Check if the horizontal velocity is significantly larger than the vertical velocity
        if (vx > threshold * vy) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _scaffoldKey.currentState!.openDrawer();
          } else {}
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          drawer: const HomeDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AsyncValueWidget<List<AppInfo>>(
              value: ref.watch(appListProvider),
              data: (data) {
                List<AppInfo> apps = data;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_controller.text.isEmpty) ...<Widget>[
                      const Flexible(child: ClockWidget()),
                      const Spacer(),
                    ] else
                      Flexible(
                        child: _buildListOfApps(apps, userSettings),
                      ),
                    _buildFavouritesRow(apps, userSettings),
                    _buildBottomSearchBar(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListOfApps(List<AppInfo> apps, SettingsNotifier settings) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var app in apps
              .where((app) => app.name
                  .toLowerCase()
                  .contains(_controller.text.toLowerCase()))
              .take(5))
            AppLauncher(
              app: app,
              launcherType: LauncherType.tile,
              iconSize: settings.iconScale,
            ),
        ],
      ),
    );
  }

  Widget _buildBottomSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchBar(
        controller: _controller,
        trailing: [
          IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                context.go(AppRoute.settings.path);
              }),
        ],
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 0, horizontal: 12)),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildFavouritesRow(List<AppInfo> apps, SettingsNotifier settings) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer(builder: (context, ref, child) {
        List<String> favourites = ref.watch(favouritesProvider).favourites;
        List<AppInfo> favouriteApps =
            apps.where((app) => favourites.contains(app.packageName)).toList();
        return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          for (final app in favouriteApps)
            AppLauncher(
              app: app,
              launcherType: LauncherType.iconOnly,
              iconSize: settings.iconScale,
            ),
        ]);
      }),
    );
  }
}
