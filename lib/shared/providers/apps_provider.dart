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
    return await InstalledApps.getInstalledApps(false, true, "", true);
  }

  Future<void> reloadApps() async {
    state = const AsyncValue<List<AppInfo>>.loading().copyWithPrevious(state);
    state = await AsyncValue.guard(() => _fetchApps());
  }

  void _onAppChanged(dynamic event) {
    if (event is Map) {
      final eventType = event['event'] as String;
      final packageName = event['package'] as String?;

      debugPrint('App $eventType: ${packageName ?? "unknown"}');

      if (eventType == 'installed' || eventType == 'uninstalled') {
        reloadApps();
      }
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
