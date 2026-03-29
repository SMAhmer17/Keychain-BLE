import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:keychain_ble/core/utils/app_logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupService {
  StartupService._();

  /// Initializes all services required before [runApp].
  /// Returns [prefs] and [packageInfo] for ProviderScope overrides.
  static Future<({SharedPreferences prefs, PackageInfo packageInfo})>
  initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    await _logDeviceInfo(packageInfo);

    return (prefs: prefs, packageInfo: packageInfo);
  }

  static Future<void> _logDeviceInfo(PackageInfo packageInfo) async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      AppLogger.info('——————— APP STARTUP INFO ———————');
      AppLogger.info('App: ${packageInfo.appName} ${packageInfo.version}+${packageInfo.buildNumber}');
      AppLogger.info('Package: ${packageInfo.packageName}');

      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        AppLogger.info('Platform: Android ${info.version.release} (SDK ${info.version.sdkInt})');
        AppLogger.info('Device: ${info.manufacturer} ${info.model}');
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        AppLogger.info('Platform: iOS ${info.systemVersion}');
        AppLogger.info('Device: ${info.name} (${info.model})');
      } else if (Platform.isMacOS) {
        final info = await deviceInfo.macOsInfo;
        AppLogger.info('Platform: macOS ${info.kernelVersion} — ${info.model}');
      } else {
        AppLogger.info('Platform: ${Platform.operatingSystem}');
      }

      AppLogger.info('——————————————————————————');
    } catch (e, stack) {
      AppLogger.error('Failed to log device info', e, stack);
    }
  }
}
