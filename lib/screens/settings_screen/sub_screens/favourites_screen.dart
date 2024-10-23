import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';

import '../../../shared/async_widget/async_widget.dart';
import '../../../shared/providers/apps_provider.dart';
import '../../../shared/providers/favourites_provider.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> favouritePackageNames =
        ref.watch(favouritesProvider).favourites;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kTextTabBarHeight + 50),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('Favourite Apps',
                      style: Theme.of(context).textTheme.headlineLarge),
                ),
              ),
            ),
          ),
          // Replace SliverFillRemaining with SliverToBoxAdapter + SliverList
          AsyncValueWidget<List<AppInfo>>(
            value: ref.watch(appListProvider),
            data: (apps) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final String packageName = apps[index].packageName;
                    final app = apps[index];
                    return ListTile(
                      leading: app.getIconImage(),
                      title: Text(app.name),
                      trailing: favouritePackageNames.contains(packageName)
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                      onTap: () {
                        if (favouritePackageNames.contains(packageName)) {
                          ref.read(favouritesProvider).removeApp(packageName);
                        } else {
                          ref.read(favouritesProvider).addApp(packageName);
                        }
                      },
                    );
                  },
                  childCount: apps.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
