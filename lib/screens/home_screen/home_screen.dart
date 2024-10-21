import 'package:blackout_launcher/screens/home_screen/providers/search_query_provider.dart';
import 'package:blackout_launcher/screens/home_screen/providers/show_result_provider.dart';
import 'package:blackout_launcher/screens/home_screen/widgets/clock.dart';
import 'package:blackout_launcher/screens/home_screen/widgets/home_drawer.dart';
import 'package:blackout_launcher/screens/home_screen/widgets/search_bar/search_bar.dart';
import 'package:blackout_launcher/screens/home_screen/widgets/search_results/search_results.dart';
import 'package:blackout_launcher/screens/home_screen/widgets/swipe_detector.dart';
import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

import '../../constants/enums/dock_styles.dart';
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

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
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
    final showResProvider = ref.watch(showResultsProvider.notifier);
    final showResults = ref.watch(showResultsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        focusNode.unfocus();
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          _scaffoldKey.currentState!.closeDrawer();
        }
        if (showResults) {
          showResProvider.state = false;
        }
      },
      child: SwipeDetector(
          onSwipeRight: () {
            _performSwipeAction(settings.rightSwipeGestureAction,
                isRight: true);
          },
          onSwipeLeft: () {
            _performSwipeAction(settings.leftSwipeGestureAction,
                isRight: false);
          },
          onSwipeDownwards: () {
            focusNode.requestFocus();
            showResProvider.state = true;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
            drawer: const HomeDrawer(),
            body: AsyncValueWidget(
                value: ref.watch(appListProvider),
                data: (apps) {
                  return Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        title: CustomSearchBar(focusNode: focusNode),
                      ),
                      Expanded(
                        child: showResults
                            ? const Padding(
                                padding: EdgeInsets.all(8),
                                child: SearchResults(),
                              )
                            : const ClockWidget(),
                      ),
                      if (settings.enableDock) _buildDock(apps, settings),
                    ],
                  );
                }),
          )),
    );
  }

  Widget _buildDock(List<AppInfo> apps, SettingsNotifier settings) {
    final dockStyle = settings.dockStyle;
    return Padding(
        padding: EdgeInsets.all(dockStyle == DockStyle.floating ? 8 : 0),
        child: Consumer(builder: (context, ref, child) {
          List<String> favourites = ref.watch(favouritesProvider).favourites;
          List<AppInfo> favouriteApps = apps
              .where((app) => favourites.contains(app.packageName))
              .toList();

          if (favouriteApps.isEmpty) return const SizedBox.shrink();

          return DecoratedBox(
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
          );
        }));
  }
}
