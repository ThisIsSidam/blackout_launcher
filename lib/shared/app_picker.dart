import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';

import 'async_widget/async_widget.dart';

class AppPickerDialog extends ConsumerWidget {
  const AppPickerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettings = ref.watch(userSettingProvider);

    return AlertDialog(
        title: const Text('Select app'),
        content: AsyncValueWidget<List<AppInfo>>(
          value: ref.watch(appListProvider),
          data: (apps) {
            return SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: apps.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: apps[index].getIconImage(),
                    title: Text(apps[index].name),
                    onTap: () {
                      Navigator.of(context).pop(apps[index]);
                    },
                  );
                },
              ),
            );
          },
        ));
  }
}
