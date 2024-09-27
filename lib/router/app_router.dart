import 'package:blackout_launcher/pages/home_screen/home_screen.dart';
import 'package:blackout_launcher/pages/settings_screen/favourites_screen.dart';
import 'package:blackout_launcher/pages/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home('/', 'HOME'),
  settings('/settings', 'SETTINGS'),
  favourites('/settings/favourites', 'FAVOURITES'),
  ;

  /// AppRoute Constructor
  const AppRoute(this.path, this.name);
  
  // AppRoute Fields
  final String path;
  final String name;

  String get nameFromPath => path.split('/').last;
}

final GoRouter router = GoRouter(
  initialLocation: AppRoute.home.path,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoute.home.path,
      name: AppRoute.home.name,
      builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoute.settings.nameFromPath,
          name: AppRoute.settings.name,
          builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
          routes: <RouteBase> [
            GoRoute(
              path: AppRoute.favourites.nameFromPath,
              name: AppRoute.favourites.name,
              builder: (BuildContext context, GoRouterState state) => const FavouritesScreen(),
            )
          ]
        ),
      ]
    ),

  ]
);