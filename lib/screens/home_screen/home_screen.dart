import 'package:blackout_launcher/screens/home_screen/providers/search_query_provider.dart';
import 'package:blackout_launcher/screens/home_screen/widgets/clock.dart';
import 'package:blackout_launcher/screens/home_screen/widgets/home_drawer.dart';
import 'package:blackout_launcher/screens/home_screen/widgets/search_bar/search_bar.dart';
import 'package:blackout_launcher/screens/home_screen/widgets/swipe_detector.dart';
import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:blackout_launcher/shared/providers/hidden_apps_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

import '../../constants/enums/swipe_gestures.dart';
import '../../shared/providers/user_settings_provider.dart';
import '../favourite_screen/providers/favourites_provider.dart';
import 'widgets/app_launcher/app_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final FocusNode focusNode;
  bool isFocused = false;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
    focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
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
    final settings = ref.watch(userSettingProvider);
    final queryProvider = ref.watch(searchQueryProvider);

    return PopScope(
      canPop: false,
      child: SwipeDetector(
        onSwipeRight: () {
          _performSwipeAction(settings.rightSwipeGestureAction, isRight: true);
        },
        onSwipeLeft: () {
          _performSwipeAction(settings.leftSwipeGestureAction, isRight: false);
        },
        onSwipeDownwards: () {
          focusNode.requestFocus();
        },
        child: AsyncValueWidget(
            value: ref.watch(appListProvider),
            data: (apps) {
              return Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: true,
                drawer: const HomeDrawer(),
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      toolbarHeight: 65,
                      automaticallyImplyLeading: false,
                      title: CustomSearchBar(
                          focusNode: focusNode, isFocused: isFocused),
                    ),
                    SliverFillRemaining(
                        child: isFocused || queryProvider.query.isNotEmpty
                            ? _buildListOfApps(
                                apps,
                                settings,
                              )
                            : ClockWidget()),
                  ],
                ),
                bottomSheet: _buildFavouritesRow(apps, settings),
              );
            }),
      ),
    );
  }

  Widget _buildListOfApps(List<AppInfo> allApps, SettingsNotifier settings) {
    final queryProvider = ref.watch(searchQueryProvider);
    final hiddenApps = ref.watch(hiddenAppsProvider).hiddenApps;
    final apps = allApps.where((app) => !hiddenApps.contains(app.packageName));

    final List<AppInfo> filteredApps = apps
        .where((app) =>
            app.name.toLowerCase().contains(queryProvider.query.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: filteredApps.isEmpty
          ? Align(
              alignment: Alignment.topCenter,
              child: Text("No apps found for term '${queryProvider.query}'"))
          : GridView.count(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 16,
              children: [
                for (var app in filteredApps)
                  AppLauncher(
                    app: app,
                    launcherType: LauncherType.iconAndText,
                    iconSize: settings.iconScale,
                  ),
              ],
            ),
    );
  }

  Widget _buildFavouritesRow(List<AppInfo> apps, SettingsNotifier settings) {
    return BottomSheet(
        enableDrag: false,
        shadowColor: Colors.black,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
        ),
        onClosing: () {},
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Consumer(builder: (context, ref, child) {
                List<String> favourites =
                    ref.watch(favouritesProvider).favourites;
                List<AppInfo> favouriteApps = apps
                    .where((app) => favourites.contains(app.packageName))
                    .toList();

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final children = favouriteApps.reversed
                        .map((app) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: AppLauncher(
                                app: app,
                                launcherType: LauncherType.iconOnly,
                                iconSize: settings.iconScale,
                              ),
                            ))
                        .toList();

                    if (favouriteApps.length * (settings.iconScale + 8) <=
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
                );
              }));
        });
  }
}
