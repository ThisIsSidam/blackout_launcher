import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
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
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kTextTabBarHeight + 50),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Hidden Apps',
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
            ),
          ),
        ),
        AsyncValueWidget<List<AppInfo>>(
            value: ref.watch(appListProvider),
            data: (apps) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
                  childCount: apps.length,
                ),
              );
            }),
      ]),
    );
  }
}
