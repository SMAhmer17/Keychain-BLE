import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:keychain_ble/core/router/app_route_constants.dart';
import 'package:keychain_ble/features/ble/presentation/ble_shell.dart';
import 'package:keychain_ble/features/ble/presentation/connection_status/connection_status_screen.dart';
import 'package:keychain_ble/features/ble/presentation/device_logs/device_logs_screen.dart';
import 'package:keychain_ble/features/ble/presentation/discover/discover_screen.dart';
import 'package:keychain_ble/features/ble/presentation/guide/guide_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.discover,
    debugLogDiagnostics: kDebugMode,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BleShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.discover,
                name: AppRouteName.discover,
                builder: (context, state) => const DiscoverScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.logs,
                name: AppRouteName.logs,
                builder: (context, state) => const DeviceLogsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.status,
                name: AppRouteName.status,
                builder: (context, state) => const ConnectionStatusScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.guide,
                name: AppRouteName.guide,
                builder: (context, state) => const GuideScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No route defined for ${state.uri}')),
    ),
  );
});
