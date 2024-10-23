import 'package:blackout_launcher/screens/home_screen/home_screen.dart';
import 'package:blackout_launcher/screens/settings_screen/settings_screen.dart';
import 'package:blackout_launcher/screens/settings_screen/sub_screens/favourites_screen.dart';
import 'package:blackout_launcher/screens/settings_screen/sub_screens/gesture_settings.dart';
import 'package:blackout_launcher/screens/settings_screen/sub_screens/hidden_apps_screen.dart';
import 'package:blackout_launcher/screens/settings_screen/sub_screens/home_screen_settings/HomeScreenSettings.dart';
import 'package:blackout_launcher/screens/settings_screen/sub_screens/user_prefs_settings.dart';
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
      return MaterialApp(
        theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        routes: {
          '/home_screen': (context) => const HomeScreen(),
          '/settings_screen': (context) => const SettingsScreen(),
          '/favourites_screen': (context) => const FavouritesScreen(),
          '/hidden_apps_screen': (context) => const HiddenAppsScreen(),
          '/user_pref_settings': (context) => const UserPreferencesScreen(),
          '/gesture_settings': (context) => const GestureSettings(),
          '/home_screen_settings': (context) => const HomeScreenSettings()
        },
      );
    });
  }
}
