import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/enums/app_sort_method.dart';
import '../../../constants/enums/swipe_gestures.dart';

class SearchSettings extends StatelessWidget {
  const SearchSettings({super.key});

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
            child: Text('Search',
                style: Theme.of(context).textTheme.headlineLarge),
          ),
        ),
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          _buildSearchArrangementTile(context),
          _buildAppSortTile(context),
        ],
      ),
    );
  }

  Widget _buildSearchArrangementTile(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userSettings = ref.watch(userSettingProvider);

      String subtitle = userSettings.rightSwipeGestureAction.toString();
      if (userSettings.rightSwipeGestureAction == SwipeGesture.openApp) {
        subtitle += ': ${userSettings.rightSwipeOpenApp}';
      }
      return MenuAnchor(
        builder: (context, controller, child) {
          return ListTile(
            leading: const Icon(
              Icons.swipe_right,
            ),
            title: Text('Arrangement of search results',
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              userSettings.isTopDownSearchArrangement
                  ? 'Top-down'
                  : 'Bottom-up',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              controller.open();
            },
          );
        },
        menuChildren: [
          MenuItemButton(
            child: const Text('Top-down'),
            onPressed: () {
              userSettings.isTopDownSearchArrangement = true;
            },
          ),
          MenuItemButton(
            child: const Text('Bottom-up'),
            onPressed: () {
              userSettings.isTopDownSearchArrangement = false;
            },
          ),
        ],
      );
    });
  }

  Widget _buildAppSortTile(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userSettings = ref.watch(userSettingProvider);
      return MenuAnchor(
        builder: (context, controller, child) {
          return ListTile(
            leading: const Icon(
              Icons.swipe_left,
              color: Colors.transparent,
            ),
            title: Text('Order of search results',
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              userSettings.appSortMethod.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              controller.open();
            },
          );
        },
        menuChildren: [
          for (AppSortMethod method in AppSortMethod.values)
            MenuItemButton(
              child: Text(method.toString()),
              onPressed: () {
                userSettings.appSortMethod = method;
              },
            )
        ],
      );
    });
  }
}
