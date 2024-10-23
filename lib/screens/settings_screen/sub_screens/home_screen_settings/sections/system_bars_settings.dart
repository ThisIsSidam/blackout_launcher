import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/providers/user_settings_provider.dart';

class SystemBarsSettings extends StatelessWidget {
  const SystemBarsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.dark_mode, color: Colors.transparent),
          title: Text(
            "System Bars",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        _buildNavigationBarTile(context),
        _buildStatusBarTile(context)
      ],
    );
  }

  Widget _buildStatusBarTile(BuildContext context) {
    return ListTile(
        leading:
            const Icon(Icons.assistant_navigation, color: Colors.transparent),
        title: Text('Hide status bar',
            style: Theme.of(context).textTheme.titleMedium),
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
            style: Theme.of(context).textTheme.titleMedium),
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
