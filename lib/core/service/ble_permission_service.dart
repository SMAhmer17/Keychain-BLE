import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:keychain_ble/core/utils/app_logger.dart';
import 'package:permission_handler/permission_handler.dart';

/// Result of a permission check/request.
enum BlePermissionResult {
  /// All required permissions granted — safe to scan.
  granted,

  /// One or more permissions denied (user can be prompted again).
  denied,

  /// Permissions permanently denied — user must open app settings.
  permanentlyDenied,

  /// Bluetooth adapter is off — user needs to enable it.
  bluetoothOff,
}

class BlePermissionService {
  BlePermissionService._();
  static final BlePermissionService instance = BlePermissionService._();

  /// Checks BLE adapter state and requests all required runtime permissions.
  /// Returns a [BlePermissionResult] describing the outcome.
  Future<BlePermissionResult> checkAndRequest() async {
    // ── 1. Check adapter state ──────────────────────────────────────────────
    final adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState == BluetoothAdapterState.off) {
      AppLogger.warning('[BLE] Bluetooth adapter is OFF');
      return BlePermissionResult.bluetoothOff;
    }

    // ── 2. No runtime permissions needed on iOS (handled by plist keys) ─────
    if (Platform.isIOS) {
      AppLogger.info('[BLE] iOS — no runtime BLE permissions needed');
      return BlePermissionResult.granted;
    }

    // ── 3. Android: request appropriate permissions based on API level ───────
    final permissions = await _requiredAndroidPermissions();
    AppLogger.info('[BLE] Requesting permissions: $permissions');

    final statuses = await permissions.request();

    final allGranted = statuses.values.every(
      (s) => s == PermissionStatus.granted,
    );
    if (allGranted) {
      AppLogger.success('[BLE] All BLE permissions granted');
      return BlePermissionResult.granted;
    }

    final anyPermanentlyDenied = statuses.values.any(
      (s) => s == PermissionStatus.permanentlyDenied,
    );
    if (anyPermanentlyDenied) {
      AppLogger.error('[BLE] Permissions permanently denied');
      return BlePermissionResult.permanentlyDenied;
    }

    AppLogger.warning('[BLE] Permissions denied');
    return BlePermissionResult.denied;
  }

  Future<List<Permission>> _requiredAndroidPermissions() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;
    AppLogger.info('[BLE] Android SDK: $sdkInt');

    return [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      // ACCESS_FINE_LOCATION is only required for BLE scanning below API 31.
      // The manifest declares it with maxSdkVersion="30", so permission_handler
      // returns `denied` on API 31+ if we request it — causing a false failure.
      if (sdkInt < 31) Permission.locationWhenInUse,
    ];
  }
}
