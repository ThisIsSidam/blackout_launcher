import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_router.dart';

class UserPreferencesSection extends StatelessWidget {
  const UserPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Text(
            "User Preferences",
            style:
                Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
          ),
        ),
        ListTile(
            title: Text(
              'Edit favourite apps',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              context.go(AppRoute.favourites.path);
            }),
        _buildIconScaleTile(context),
        _buildStatusBarTile(context),
        _buildNavigationBarTile(context)
      ],
    );
  }

  Widget _buildIconScaleTile(BuildContext context) {
    return ListTile(
      title: Text('Text Scale', style: Theme.of(context).textTheme.titleSmall),
      subtitle: Row(
        children: [
          const Text('A', style: TextStyle(color: Colors.white)),
          const SizedBox(width: 8),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final userSettingsProvider = ref.watch(userSettingProvider);
              final List<double> scaleValues = [34, 40, 46, 52, 58, 64];
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      scaleValues.length,
                      (index) => Flexible(
                            child: TextButton(
                              onPressed: () {
                                userSettingsProvider.iconScale =
                                    scaleValues[index];
                              },
                              child: SizedBox(
                                width: scaleValues[index] / 3,
                                height: scaleValues[index] / 3,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: userSettingsProvider.iconScale ==
                                            scaleValues[index]
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )));
            }),
          ),
          const SizedBox(width: 10),
          const Text('A', style: TextStyle(color: Colors.white, fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildStatusBarTile(BuildContext context) {
    return ListTile(
        title: Text('Show status bar',
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
        title: Text('Show navigation bar',
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
}
