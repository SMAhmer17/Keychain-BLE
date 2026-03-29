import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keychain_ble/core/providers/package_info_provider.dart';
import 'package:keychain_ble/core/providers/theme_notifier_provider.dart';
import 'package:keychain_ble/core/service/startup_service.dart';
import 'package:keychain_ble/core/utils/app_logger.dart';
import 'package:keychain_ble/keychain_ble_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) =>
      AppLogger.error('Flutter error', details.exception, details.stack);
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('Unhandled error', error, stack);
    return true;
  };

  final (:prefs, :packageInfo) = await StartupService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        packageInfoProvider.overrideWithValue(packageInfo),
      ],
      child: const KeychainBleApp(),
    ),
  );
}
