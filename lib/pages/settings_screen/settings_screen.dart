import 'package:blackout_launcher/router/app_router.dart';
import 'package:blackout_launcher/shared/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackArrow(),
          title: const Text('Settings'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
                child: Column(
              children: [
                _buildSectionTitle('User', context),
                ListTile(
                    title: const Text('Edit favourite apps'),
                    onTap: () {
                      context.go(AppRoute.favourites.path);
                    }),
              ],
            )),
            _buildVersionWidget(),
          ],
        ));
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          )),
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
