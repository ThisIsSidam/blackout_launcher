import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kTextTabBarHeight),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Settings',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
        )),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text("User Preferences",
                  style: Theme.of(context).textTheme.titleSmall),
              onTap: () {
                Navigator.pushNamed(context, '/user_pref_settings');
              },
              subtitle: Text('App Sort',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home Screen",
                  style: Theme.of(context).textTheme.titleSmall!),
              onTap: () {
                Navigator.pushNamed(context, '/home_screen_settings');
              },
              subtitle: Text('Dock, Searchbar...',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
                leading: const Icon(Icons.favorite),
                title: Text(
                  'Favourite apps',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/favourites_screen');
                },
                subtitle: Text('Manage your favourite apps',
                    style: Theme.of(context).textTheme.bodySmall)),
            ListTile(
                leading: const Icon(Icons.block),
                title: Text(
                  'Hidden Apps',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/hidden_apps_screen');
                },
                subtitle: Text('Manage hidden apps',
                    style: Theme.of(context).textTheme.bodySmall)),
            ListTile(
              leading: Icon(Icons.gesture),
              title: Text("Gestures",
                  style: Theme.of(context).textTheme.titleSmall),
              onTap: () {
                Navigator.pushNamed(context, '/gesture_settings');
              },
              subtitle: Text('Left Swipe Gesture, Right Swipe Gesture...',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        )));
  }
}
