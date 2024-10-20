import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:installed_apps/app_info.dart';

import '../../../../shared/providers/hidden_apps_provider.dart';
import '../../providers/search_query_provider.dart';
import '../app_launcher/app_launcher.dart';

class SearchResults extends ConsumerWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('searchResult built');
    final hiddenApps = ref.watch(hiddenAppsProvider).hiddenApps;

    // Most providers are on read mode because this widget is a child of HomeScree
    // and [HomeScreen] has these on watch mode.
    final settings = ref.read(userSettingProvider);
    final queryProvider = ref.watch(searchQueryProvider);
    return AsyncValueWidget<List<AppInfo>>(
        value: ref.read(appListProvider),
        data: (allApps) {
          final apps =
              allApps.where((app) => !hiddenApps.contains(app.packageName));

          final List<AppInfo> filteredApps = apps
              .where((app) => app.name
                  .toLowerCase()
                  .contains(queryProvider.query.toLowerCase()))
              .toList();

          // Using a column because more types of results would be added.
          // Also the child normally took entire space which wasn't good.
          // With this it now takes only necessary space.
          return Column(
            children: [
              Flexible(
                  child: _buildResultApps(context, filteredApps, settings)),
            ],
          );
        });
  }

  Widget _buildResultApps(BuildContext context, List<AppInfo> filteredApps,
      SettingsNotifier settings) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: filteredApps.isEmpty
            ? SizedBox(
                height: 45,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("No apps found!"),
                    )),
              )
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
      ),
    );
  }
}
