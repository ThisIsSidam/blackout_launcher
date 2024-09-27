import 'package:blackout_launcher/shared/app_info_plus.dart';
import 'package:blackout_launcher/shared/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<AppInfo> apps = [];
  List<AppInfo> favouriteApps = [];

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  _loadApps() async {
    apps = await InstalledApps.getInstalledApps(true, true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        title: const Text('Favourite apps'),
      ),
      body: ListView.builder(
        itemCount: apps.length + favouriteApps.length,
        itemBuilder: (context, index) {
          if (index < favouriteApps.length) {
            return ListTile(
              leading: favouriteApps[index].iconImage,
              title: Text(favouriteApps[index].name),
              trailing: const Icon(Icons.favorite, color: Colors.red),
              onTap: () {
                setState(() {
                  favouriteApps.removeAt(index);
                  apps.add(favouriteApps[index]);
                });
              },
            );
          }
          return ListTile(
            leading: Image.memory(apps[index - favouriteApps.length].icon!),
            title: Text(apps[index - favouriteApps.length].name),
            trailing: const Icon(Icons.favorite_border),
            onTap: () {
              setState(() {
                favouriteApps.add(apps[index - favouriteApps.length]);
                apps.removeAt(index - favouriteApps.length);
              });
            },
          );
        },
      ),
    );
  }
}
