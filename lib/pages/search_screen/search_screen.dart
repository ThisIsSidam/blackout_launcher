import 'package:blackout_launcher/pages/home_screen/widgets/swipe_detector.dart';
import 'package:blackout_launcher/pages/search_screen/providers/search_query_provider.dart';
import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';

import '../../shared/providers/user_settings_provider.dart';
import '../home_screen/widgets/app_launcher/app_launcher.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingProvider);
    final focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    return SwipeDetector(
      onSwipeDownwards: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
              automaticallyImplyLeading: false,
              title: _buildSearchBar(context, ref, focusNode)),
          SliverFillRemaining(
              child: AsyncValueWidget(
                  value: ref.watch(appListProvider),
                  data: (apps) {
                    return _buildListOfApps(apps, settings, ref);
                  })),
        ],
      )),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, WidgetRef ref, FocusNode focusNode) {
    final queryProvider = ref.read(searchQueryProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: TextField(
              focusNode: focusNode,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(
                isDense: true, // This helps reduce the overall height
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical:
                      8, // Adjust this value to fine-tune vertical alignment
                ),
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                queryProvider.setQuery(value);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListOfApps(
      List<AppInfo> apps, SettingsNotifier settings, WidgetRef ref) {
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
