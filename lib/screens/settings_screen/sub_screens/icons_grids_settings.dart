import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconsAndGridSettings extends StatelessWidget {
  const IconsAndGridSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight + 50),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('Icons & Grid',
                style: Theme.of(context).textTheme.headlineLarge),
          ),
        ),
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          _buildIconLabelTile(context),
          _buildIconScaleTile(context),
          _buildColumnNumberTile(context),
        ],
      ),
    );
  }

  Widget _buildIconLabelTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.favorite, color: Colors.transparent),
      title: Text(
        'Show labels',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Consumer(builder: (context, ref, child) {
        final settings = ref.watch(userSettingProvider);
        return Switch(
          value: settings.showAppLabels,
          onChanged: (value) {
            settings.showAppLabels = value;
          },
        );
      }),
    );
  }

  Widget _buildIconScaleTile(BuildContext context) {
    return ListTile(
      leading: const SizedBox.shrink(),
      title: Text('Icon Size', style: Theme.of(context).textTheme.titleMedium),
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
          style: Theme.of(context).textTheme.titleMedium),
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
}
