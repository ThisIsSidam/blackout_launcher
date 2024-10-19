import 'package:blackout_launcher/pages/home_screen/providers/search_query_provider.dart';
import 'package:blackout_launcher/pages/home_screen/widgets/clock.dart';
import 'package:blackout_launcher/pages/home_screen/widgets/home_drawer.dart';
import 'package:blackout_launcher/pages/home_screen/widgets/swipe_detector.dart';
import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

import '../../constants/enums/swipe_gestures.dart';
import '../../router/app_router.dart';
import '../../shared/providers/user_settings_provider.dart';
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

    // Refresh when gains focus
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
        onSwipeUpwards: () {
          ref.read(searchQueryProvider).clearQuery();
          context.go(AppRoute.search.path);
        },
        child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
            drawer: const HomeDrawer(),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                    toolbarHeight: 65,
                    automaticallyImplyLeading: false,
                    title: _buildSearchBar(
                      context,
                    )),
                queryProvider.isEmpty
                    ? const SliverToBoxAdapter(child: ClockWidget())
                    : SliverFillRemaining(
                        child: AsyncValueWidget(
                            value: ref.watch(appListProvider),
                            data: (apps) {
                              return _buildListOfApps(
                                apps,
                                settings,
                              );
                            })),
              ],
            )),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final queryProvider = ref.read(searchQueryProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isFocused ? Colors.white10 : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          textCapitalization: TextCapitalization.sentences,
          focusNode: focusNode,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8, // Adjust this value to fine-tune vertical alignment
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {
                context.go(AppRoute.settings.path);
              },
              icon: const Icon(Icons.menu),
            ),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            queryProvider.setQuery(value);
          },
        ),
      ),
    );
  }

  Widget _buildListOfApps(List<AppInfo> apps, SettingsNotifier settings) {
    final queryProvider = ref.watch(searchQueryProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        children: [
          for (var app in apps.where((app) => app.name
              .toLowerCase()
              .contains(queryProvider.query.toLowerCase())))
            AppLauncher(
              app: app,
              launcherType: LauncherType.iconAndText,
              iconSize: settings.iconScale,
            ),
        ],
      ),
    );
  }
}
