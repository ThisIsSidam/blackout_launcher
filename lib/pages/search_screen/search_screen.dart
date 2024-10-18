import 'dart:ui';

import 'package:blackout_launcher/pages/search_screen/providers/search_query_provider.dart';
import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:installed_apps/app_info.dart';

import '../../router/app_router.dart';
import '../../shared/providers/user_settings_provider.dart';
import '../home_screen/widgets/app_launcher/app_launcher.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingProvider);
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
            backgroundColor: Colors.black87,
            automaticallyImplyLeading: false,
            title: _buildSearchBar(context, ref)),
        body: AsyncValueWidget(
            value: ref.watch(appListProvider),
            data: (apps) {
              return _buildListOfApps(apps, settings, ref);
            }));
  }

  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    final queryProvider = ref.read(searchQueryProvider);
    return SizedBox(
      height: 30,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextField(
              selectionHeightStyle: BoxHeightStyle.tight,
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                suffixIcon: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      context.go(AppRoute.settings.path);
                    }),
              ),
              onChanged: (value) {
                queryProvider.setQuery(value);
              }),
        ),
      ),
    );
  }

  Widget _buildListOfApps(
      List<AppInfo> apps, SettingsNotifier settings, WidgetRef ref) {
    final queryProvider = ref.watch(searchQueryProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var app in apps
              .where((app) => app.name
                  .toLowerCase()
                  .contains(queryProvider.query.toLowerCase()))
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
}
