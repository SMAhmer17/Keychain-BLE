import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keychain_ble/app2/core/router/sori_router.dart';
import 'package:keychain_ble/app2/core/theme/sori_theme.dart';
import 'package:keychain_ble/core/providers/theme_notifier_provider.dart';

class SoriApp extends ConsumerWidget {
  const SoriApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final router = ref.watch(soriRouterProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: themeMode == ThemeMode.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: MaterialApp.router(
        title: 'Sori',
        debugShowCheckedModeBanner: false,
        theme: soriLightTheme,
        darkTheme: soriDarkTheme,
        themeMode: themeMode,
        routerConfig: router,
      ),
    );
  }
}
