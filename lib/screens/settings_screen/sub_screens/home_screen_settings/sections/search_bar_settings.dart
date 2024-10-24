import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/providers/user_settings_provider.dart';

class SearchBarSettings extends StatelessWidget {
  const SearchBarSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.dark_mode, color: Colors.transparent),
          title: Text(
            "Search Bar",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.favorite, color: Colors.transparent),
          title: Text(
            'Focused search bar opacity',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Consumer(builder: (context, ref, child) {
            final settings = ref.watch(userSettingProvider);
            return Row(
              children: [
                Expanded(
                  child: Slider(
                    value: settings.focusedSearchBarOpacity,
                    min: 0.0,
                    max: 1,
                    onChanged: (value) {
                      settings.focusedSearchBarOpacity = value;
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  '${(settings.focusedSearchBarOpacity * 100).round()}%',
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ],
            );
          }),
        ),
        ListTile(
          leading: const Icon(Icons.favorite, color: Colors.transparent),
          title: Text(
            'Unfocused search bar opacity',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Consumer(builder: (context, ref, child) {
            final settings = ref.watch(userSettingProvider);
            return Row(
              children: [
                Expanded(
                  child: Slider(
                    value: settings.unfocusedSearchBarOpacity,
                    min: 0.0,
                    max: 1,
                    onChanged: (value) {
                      settings.unfocusedSearchBarOpacity = value;
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  '${(settings.unfocusedSearchBarOpacity * 100).round()}%',
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ],
            );
          }),
        ),
        ListTile(
          leading: const Icon(Icons.favorite, color: Colors.transparent),
          title: Text(
            'Hide icons from unfocused search bar',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: Consumer(builder: (context, ref, child) {
            final settings = ref.watch(userSettingProvider);
            return Switch(
              value: settings.hideIconsFromUnfocusedSearchBar,
              onChanged: (value) {
                settings.hideIconsFromUnfocusedSearchBar = value;
              },
            );
          }),
        ),
      ],
    );
  }
}
