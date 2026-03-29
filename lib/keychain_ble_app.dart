import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keychain_ble/core/providers/theme_notifier_provider.dart';
import 'package:keychain_ble/core/router/app_router.dart';
import 'package:keychain_ble/core/themes/dark_theme.dart';
import 'package:keychain_ble/core/themes/light_theme.dart';

class KeychainBleApp extends ConsumerWidget {
  const KeychainBleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Keychain BLE',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
