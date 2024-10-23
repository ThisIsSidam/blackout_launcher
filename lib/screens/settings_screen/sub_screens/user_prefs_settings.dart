import 'package:blackout_launcher/constants/enums/app_sort_method.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPreferencesScreen extends StatelessWidget {
  const UserPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('User Preferences',
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconScaleTile(context),
          _buildColumnNumberTile(context),
          _buildAppSortTile(context)
        ],
      ),
    );
  }

  Widget _buildIconScaleTile(BuildContext context) {
    return ListTile(
      leading: const SizedBox.shrink(),
      title: Text('Icon Size', style: Theme.of(context).textTheme.titleSmall),
      subtitle: Consumer(builder: (context, ref, child) {
        final settings = ref.watch(userSettingProvider);
        final List<double> scaleValues = [32, 40, 48, 56, 64];
        return Row(
          children: [
            Expanded(
              child: Slider(
                value: settings.iconSize,
                min: scaleValues.first,
                max: scaleValues.last,
                divisions: scaleValues.length - 1,
                onChanged: (value) {
                  settings.iconSize = value;
                },
                activeColor: Theme.of(context).colorScheme.primary,
                inactiveColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              '${settings.iconSize.toInt()}',
              style: Theme.of(context).textTheme.titleSmall,
            )
          ],
        );
      }),
    );
  }

  Widget _buildColumnNumberTile(BuildContext context) {
    return ListTile(
      leading: const SizedBox.shrink(),
      title: Text('Number of Columns',
          style: Theme.of(context).textTheme.titleSmall),
      subtitle: Consumer(builder: (context, ref, child) {
        final userSettingsProvider = ref.watch(userSettingProvider);
        final List<double> values = [3, 4, 5, 6, 7, 8];
        return Row(
          children: [
            Expanded(
              child: Slider(
                value: userSettingsProvider.numberOfColumns,
                min: values.first,
                max: values.last,
                divisions: values.length - 1,
                onChanged: (value) {
                  userSettingsProvider.numberOfColumns = value;
                },
                activeColor: Theme.of(context).colorScheme.primary,
                inactiveColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              '${userSettingsProvider.numberOfColumns.toInt()}',
              style: Theme.of(context).textTheme.titleSmall,
            )
          ],
        );
      }),
    );
  }

  Widget _buildAppSortTile(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userSettings = ref.watch(userSettingProvider);
      return MenuAnchor(
        builder: (context, controller, child) {
          return ListTile(
            leading: const Icon(
              Icons.swipe_left,
              color: Colors.transparent,
            ),
            title: Text('Order of search results',
                style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(
              userSettings.appSortMethod.toString(),
            ),
            onTap: () {
              controller.open();
            },
          );
        },
        menuChildren: [
          for (AppSortMethod method in AppSortMethod.values)
            MenuItemButton(
              child: Text(method.toString()),
              onPressed: () {
                userSettings.appSortMethod = method;
              },
            )
        ],
      );
    });
  }
}
