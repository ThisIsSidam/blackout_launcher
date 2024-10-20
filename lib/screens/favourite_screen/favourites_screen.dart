import 'package:blackout_launcher/screens/favourite_screen/providers/favourites_provider.dart';
import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/back_arrow.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:installed_apps/app_info.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> favouritePackageNames =
        ref.watch(favouritesProvider).favourites;
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        title: const Text('Favourite apps'),
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
                  trailing: favouritePackageNames.contains(packageName)
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(Icons.favorite_border),
                  onTap: () {
                    if (favouritePackageNames.contains(packageName)) {
                      ref.read(favouritesProvider).removeApp(packageName);
                    } else {
                      if (favouritePackageNames.length > 4) {
                        Fluttertoast.showToast(
                            msg: 'Not more than 5 favourites');
                        return;
                      }

                      ref.read(favouritesProvider).addApp(packageName);
                    }
                  },
                );
              },
            );
          }),
    );
  }
}
