import 'package:blackout_launcher/screens/settings_screen/shortcuts_section/shortcuts_section.dart';
import 'package:blackout_launcher/screens/settings_screen/user_preferences_section/user_pref_section.dart';
import 'package:blackout_launcher/shared/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const BackArrow(),
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const UserPreferencesSection(),
            _buildDivider(context),
            const ShortcutsSection(),
            _buildVersionWidget(),
          ],
        )));
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildVersionWidget() {
    final packageInfo = PackageInfo.fromPlatform();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: packageInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    height: 24,
                    width: 24,
                    child: Center(child: CircularProgressIndicator()));
              }

              if (snapshot.hasData) {
                return Text("v${snapshot.data!.version}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey));
              }

              return const SizedBox.shrink();
            }),
      ),
    );
  }
}
