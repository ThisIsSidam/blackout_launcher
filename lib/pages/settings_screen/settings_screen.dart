import 'package:blackout_launcher/router/app_router.dart';
import 'package:blackout_launcher/shared/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrow(),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionTitle('User', context),
            ListTile(
              title: const Text('Edit favourite apps'),
              onTap: () {
                context.go(AppRoute.favourites.path);
              }
            )
          ],
        )
      )
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        )
      ),
    );
  }
}