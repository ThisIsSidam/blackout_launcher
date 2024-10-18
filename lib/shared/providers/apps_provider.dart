import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppListAsyncNotifier extends AsyncNotifier<List<AppInfo>> {
  // ignore: unused_field
  static const MethodChannel _methodChannel =
      MethodChannel('com.blackout.launcher/app_changes');
  static const EventChannel _eventChannel =
      EventChannel('com.blackout.launcher/app_change_events');

  @override
  Future<List<AppInfo>> build() async {
    _eventChannel.receiveBroadcastStream().listen(
          _onAppChanged,
          onError: _onAppChangeError,
        );

    return _fetchApps();
  }

  Future<List<AppInfo>> _fetchApps() async {
    //TODO: Check if installed_apps new release is out or not and move to it
    // Currently using direct github link from the person who sent the PR.
    return await InstalledApps.getInstalledApps(false, true, "", true);
  }

  Future<void> reloadApps() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchApps());
  }

  void _onAppChanged(dynamic event) {
    if (event == 'installed' || event == 'uninstalled') {
      reloadApps();
    }
  }

  void _onAppChangeError(Object error) {
    debugPrint('Error: $error');
  }
}

final appListProvider =
    AsyncNotifierProvider<AppListAsyncNotifier, List<AppInfo>>(() {
  return AppListAsyncNotifier();
});
