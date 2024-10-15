import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppListAsyncNotifier extends AsyncNotifier<List<AppInfo>> {
  @override
  Future<List<AppInfo>> build() async {
    return _fetchApps();
  }

  Future<List<AppInfo>> _fetchApps() async {
    return await InstalledApps.getInstalledApps(true, true);
  }

  Future<void> reloadApps() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchApps());
  }
}

final appListProvider =
    AsyncNotifierProvider<AppListAsyncNotifier, List<AppInfo>>(() {
  return AppListAsyncNotifier();
});
