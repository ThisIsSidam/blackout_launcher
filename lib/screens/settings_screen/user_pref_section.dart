import 'package:blackout_launcher/constants/enums/app_sort_method.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPreferencesSection extends StatelessWidget {
  const UserPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const SizedBox.shrink(),
          title: Text(
            "User Preferences",
            style:
                Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
          ),
        ),
        ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(
              'Edit favourite apps',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/favourites_screen');
            }),
        ListTile(
            leading: const Icon(Icons.block),
            title: Text(
              'Edit Hidden Apps',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/hidden_apps_screen');
            }),
        _buildIconScaleTile(context),
        _buildColumnNumberTile(context),
        _buildStatusBarTile(context),
        _buildNavigationBarTile(context),
        _buildAppSortTile(context)
      ],
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

  Widget _buildStatusBarTile(BuildContext context) {
    return ListTile(
        leading:
            const Icon(Icons.assistant_navigation, color: Colors.transparent),
        title: Text('Hide status bar',
            style: Theme.of(context).textTheme.titleSmall),
        trailing: Consumer(builder: (context, ref, child) {
          final userSetting = ref.watch(userSettingProvider);

          return Switch(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: userSetting.hideStatusBar,
            onChanged: (val) {
              userSetting.hideStatusBar = val;
            },
          );
        }));
  }

  Widget _buildNavigationBarTile(BuildContext context) {
    return ListTile(
        leading:
            const Icon(Icons.assistant_navigation, color: Colors.transparent),
        title: Text('Hide navigation bar',
            style: Theme.of(context).textTheme.titleSmall),
        trailing: Consumer(builder: (context, ref, child) {
          final userSetting = ref.watch(userSettingProvider);

          return Switch(
              activeColor: Theme.of(context).colorScheme.secondary,
              value: userSetting.hideNavigationBar,
              onChanged: (val) {
                userSetting.hideNavigationBar = val;
              });
        }));
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
