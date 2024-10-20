import 'package:blackout_launcher/router/app_router.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSetting = ref.watch(userSettingProvider);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      if (!userSetting.hideStatusBar) SystemUiOverlay.top,
      if (!userSetting.hideNavigationBar) SystemUiOverlay.bottom
    ]);

    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      // Check if dynamic colors are available
      if (lightDynamic != null && darkDynamic != null) {
        lightColorScheme = lightDynamic.harmonized();
        darkColorScheme = darkDynamic.harmonized();
      } else {
        // Fallback colors if dynamic colors are not available
        lightColorScheme = ColorScheme.fromSwatch(
          primarySwatch: Colors.brown,
        );
        darkColorScheme = ColorScheme.fromSwatch(
          brightness: Brightness.dark,
        );
      }
      return MaterialApp.router(
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            bottomSheetTheme: BottomSheetThemeData(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25))),
                backgroundColor: lightColorScheme.surface)),
        darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
            bottomSheetTheme: BottomSheetThemeData(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25))),
                backgroundColor: darkColorScheme.surface)),
        themeMode: ThemeMode.system,
        routerConfig: router,
      );
    });
  }
}
