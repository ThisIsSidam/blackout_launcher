import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/back_arrow.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:blackout_launcher/shared/providers/hidden_apps_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:installed_apps/app_info.dart';

class HiddenAppsScreen extends ConsumerWidget {
  const HiddenAppsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    HiddenAppsNotifier hiddenNotifier = ref.watch(hiddenAppsProvider);
    List<String> hiddenAppsPackageNames = hiddenNotifier.hiddenApps;

    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        title: const Text('Hidden apps'),
      ),
      body: AsyncValueWidget<List<AppInfo>>(
          value: ref.watch(appListProvider),
          data: (apps) {
            return ListView.separated(
              itemCount: apps.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final String packageName = apps[index].packageName;
                return ListTile(
                  leading: apps[index].getIconImage(),
                  title: Text(apps[index].name),
                  trailing: hiddenAppsPackageNames.contains(packageName)
                      ? const Icon(Icons.remove_circle, color: Colors.red)
                      : const Icon(Icons.remove_circle_outline),
                  onTap: () {
                    if (hiddenAppsPackageNames.contains(packageName)) {
                      hiddenNotifier.removeApp(packageName);
                    } else {
                      hiddenNotifier.hideApp(packageName);
                    }
                  },
                );
              },
            );
          }),
    );
  }
}
