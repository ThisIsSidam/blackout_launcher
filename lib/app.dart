import 'package:blackout_launcher/router/app_router.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {

        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        // Check if dynamic colors are available
        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Fallback colors if dynamic colors are not available
          lightColorScheme = ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          );
          darkColorScheme = ColorScheme.fromSwatch(
            brightness: Brightness.dark,
          );
        }
        return MaterialApp.router(
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true
          ),
          themeMode: ThemeMode.system,
          routerConfig: router,
        );
      }
    );
  }
}