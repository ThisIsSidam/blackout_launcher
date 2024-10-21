import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/enums/dock_styles.dart';
import '../../shared/providers/user_settings_provider.dart';

class DockSettings extends StatelessWidget {
  const DockSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.dark_mode, color: Colors.transparent),
          title: Text(
            "Dock",
            style:
                Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.favorite, color: Colors.transparent),
          title: Text(
            'Enable Dock',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          trailing: Consumer(builder: (context, ref, child) {
            final settings = ref.watch(userSettingProvider);
            return Switch(
              value: settings.enableDock,
              onChanged: (value) {
                settings.enableDock = value;
              },
            );
          }),
        ),
        ListTile(
          leading: const Icon(Icons.favorite, color: Colors.transparent),
          title: Text(
            'Opacity',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          subtitle: Consumer(builder: (context, ref, child) {
            final settings = ref.watch(userSettingProvider);
            return Row(
              children: [
                Expanded(
                  child: Slider(
                    value: settings.dockOpacity,
                    min: 0.0,
                    max: 1,
                    onChanged: (value) {
                      settings.dockOpacity = value;
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  '${(settings.dockOpacity * 100).round()}%',
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ],
            );
          }),
        ),
        _buildDockStyleTile(context)
      ],
    );
  }

  Widget _buildDockStyleTile(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userSettings = ref.watch(userSettingProvider);
      return MenuAnchor(
        builder: (context, controller, child) {
          return ListTile(
            leading: Icon(
              Icons.swipe_left,
              color: Colors.transparent,
            ),
            title: Text('DockStyle',
                style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(
              userSettings.dockStyle.toString(),
            ),
            onTap: () {
              controller.open();
            },
          );
        },
        menuChildren: [
          for (DockStyle style in DockStyle.values)
            MenuItemButton(
              child: Text(style.toString()),
              onPressed: () {
                userSettings.dockStyle = style;
              },
            )
        ],
      );
    });
  }
}
