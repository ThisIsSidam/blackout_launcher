import 'package:blackout_launcher/screens/settings_screen/sub_screens/home_screen_settings/sections/dock_settings.dart';
import 'package:blackout_launcher/screens/settings_screen/sub_screens/home_screen_settings/sections/system_bars_settings.dart';
import 'package:flutter/material.dart';

class HomeScreenSettings extends StatelessWidget {
  const HomeScreenSettings({super.key});

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
            child: Text('Home Screen',
                style: Theme.of(context).textTheme.headlineLarge),
          ),
        ),
      )),
      body: Column(
        children: [
          const SizedBox(height: 25),
          const DockSettings(),
          _buildDivider(context),
          const SystemBarsSettings()
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16), child: Divider());
  }
}
