import 'package:blackout_launcher/constants/enums/swipe_gestures.dart';
import 'package:blackout_launcher/pages/favourite_screen/providers/favourites_provider.dart';
import 'package:blackout_launcher/pages/home_screen/widgets/app_launcher/app_launcher.dart';
import 'package:blackout_launcher/pages/home_screen/widgets/clock.dart';
import 'package:blackout_launcher/pages/home_screen/widgets/home_drawer.dart';
import 'package:blackout_launcher/pages/home_screen/widgets/swipe_detector.dart';
import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

import '../../router/app_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void _performSwipeAction(SwipeGesture swipeGesture, {bool isRight = true}) {
    if (swipeGesture == SwipeGesture.openDrawer) {
      _scaffoldKey.currentState!.openDrawer();
    } else if (swipeGesture == SwipeGesture.openApp) {
      final appPackageName = isRight
          ? ref.read(userSettingProvider).rightSwipeOpenApp
          : ref.read(userSettingProvider).leftSwipeOpenApp;
      if (appPackageName != 'none') {
        InstalledApps.startApp(appPackageName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = ref.watch(userSettingProvider);
    return SwipeDetector(
      onSwipeRight: () {
        _performSwipeAction(userSettings.rightSwipeGestureAction,
            isRight: true);
      },
      onSwipeLeft: () {
        _performSwipeAction(userSettings.leftSwipeGestureAction,
            isRight: false);
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
                    const Flexible(child: ClockWidget()),
                    const Spacer(),
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

  Widget _buildBottomSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchBar(
        onTap: () {
          context.go(AppRoute.search.path);
        },
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
