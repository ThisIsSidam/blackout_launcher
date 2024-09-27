import 'package:blackout_launcher/pages/settings_screen/favourites_provider.dart';
import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:blackout_launcher/shared/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class FavouritesScreen extends HookConsumerWidget {
  const FavouritesScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    List<String> favouritePackageNames = ref.watch(favouritesProvider).favourites;

    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        title: const Text('Favourite apps'),
      ),
      body: FutureBuilder(
        future: InstalledApps.getInstalledApps(true, true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final List<AppInfo> apps = snapshot.data!;

            return ListView.separated(
              itemCount: apps.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: apps[index].getIconImage(),
                  title: Text(apps[index].name),
                  trailing: favouritePackageNames.contains(apps[index].packageName)
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_border),
                  onTap: () {
                    if (favouritePackageNames.contains(apps[index].packageName)) {
                      ref.read(favouritesProvider).removeApp(apps[index].packageName);
                    } else {

                      if (favouritePackageNames.length > 4) {
                        Fluttertoast.showToast(msg: 'Not more than 5 favourites');
                        return;
                      }

                      ref.read(favouritesProvider).addApp(apps[index].packageName);
                    }
                  },
                );
              },
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        }
      ),
    );
  }
}
