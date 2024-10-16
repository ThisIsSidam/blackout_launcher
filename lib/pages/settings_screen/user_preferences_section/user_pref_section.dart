import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_router.dart';

class UserPreferencesSection extends StatelessWidget {
  const UserPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "User Preferences",
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.white),
        ),
        ListTile(
            title: const Text('Edit favourite apps'),
            onTap: () {
              context.go(AppRoute.favourites.path);
            }),
        _buildIconScaleTile(context)
      ],
    );
  }

  Widget _buildIconScaleTile(BuildContext context) {
    return ListTile(
      title: Text('Text Scale', style: Theme.of(context).textTheme.titleSmall),
      subtitle: Row(
        children: [
          const Text('A', style: TextStyle(color: Colors.white)),
          const SizedBox(width: 8),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final userSettingsProvider = ref.watch(userSettingProvider);
              return StatefulBuilder(builder: (context, setState) {
                final List<double> scaleValues = [34, 40, 46, 52, 58, 64];
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        scaleValues.length,
                        (index) => Flexible(
                              child: TextButton(
                                onPressed: () {
                                  userSettingsProvider.iconScale =
                                      scaleValues[index];
                                },
                                child: SizedBox(
                                  width: scaleValues[index] / 3,
                                  height: scaleValues[index] / 3,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: userSettingsProvider.iconScale ==
                                              scaleValues[index]
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )));
              });
            }),
          ),
          const SizedBox(width: 10),
          const Text('A', style: TextStyle(color: Colors.white, fontSize: 24)),
        ],
      ),
    );
  }
}
