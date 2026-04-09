import 'dart:convert';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:keychain_ble/core/constants/ble_constants.dart';
import 'package:keychain_ble/core/utils/app_logger.dart';

/// Thin adapter over [FlutterBluePlus] static API.
/// All operations are logged via [AppLogger].
class BleService {
  BleService._();

  static final BleService instance = BleService._();

  // ————————————————— Adapter state —————————————————

  Stream<BluetoothAdapterState> get adapterStateStream =>
      FlutterBluePlus.adapterState;

  // ————————————————— Scanning —————————————————

  Future<void> startScan({Duration timeout = BleConstants.scanTimeout}) async {
    AppLogger.info('[BLE] Starting scan (timeout: ${timeout.inSeconds}s)');
    await FlutterBluePlus.startScan(
      timeout: timeout,
      continuousUpdates: true,
      removeIfGone: const Duration(seconds: 3),
    );
  }

  Future<void> stopScan() async {
    AppLogger.info('[BLE] Stopping scan');
    await FlutterBluePlus.stopScan();
  }

  Stream<List<ScanResult>> get scanResultsStream =>
      FlutterBluePlus.scanResults;

  Stream<bool> get isScanningStream => FlutterBluePlus.isScanning;

  // ————————————————— Connection —————————————————

  Future<void> connect(BluetoothDevice device) async {
    AppLogger.info('[BLE] Connecting to ${device.platformName} (${device.remoteId})');
    await device.connect(
      timeout: const Duration(seconds: 15),
      autoConnect: false,
    );
    // Android's GATT stack needs a brief moment after connection before
    // service discovery is reliable. Without this, discoverServices() can
    // return an empty list on the first attempt on many Android devices.
    if (Platform.isAndroid) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    AppLogger.success('[BLE] Connected to ${device.platformName}');
  }

  Future<void> disconnect(BluetoothDevice device) async {
    AppLogger.info('[BLE] Disconnecting from ${device.platformName}');
    await device.disconnect();
    AppLogger.info('[BLE] Disconnected from ${device.platformName}');
  }

  Stream<BluetoothConnectionState> connectionStateStream(
    BluetoothDevice device,
  ) =>
      device.connectionState;

  // ————————————————— Services & Characteristics —————————————————

  Future<List<BluetoothService>> discoverServices(
    BluetoothDevice device,
  ) async {
    AppLogger.info('[BLE] Discovering services on ${device.platformName}');
    final services = await device.discoverServices();
    AppLogger.info('[BLE] Found ${services.length} service(s)');
    return services;
  }

  /// Normalises a UUID to full 128-bit lowercase form so that short UUIDs
  /// (e.g. `ffe0`) and full UUIDs (e.g. `0000ffe0-0000-1000-8000-00805f9b34fb`)
  /// compare as equal.
  String _normalizeUuid(String uuid) {
    final s = uuid.trim().toLowerCase().replaceAll('-', '');
    if (s.length == 4) return '0000${s}00001000800000805f9b34fb';
    if (s.length == 8) return '${s}00001000800000805f9b34fb';
    return s;
  }

  /// Finds the target characteristic within discovered services using the
  /// provided [serviceUuid] and [characteristicUuid], enables notifications,
  /// and returns it. Throws [StateError] if not found.
  Future<BluetoothCharacteristic> subscribeToCharacteristic(
    BluetoothDevice device, {
    required String serviceUuid,
    required String characteristicUuid,
  }) async {
    final services = await discoverServices(device);

    final targetService = services.where((s) {
      return _normalizeUuid(s.uuid.toString()) == _normalizeUuid(serviceUuid);
    }).firstOrNull;

    if (targetService == null) {
      final available = services.map((s) => s.uuid.toString()).join(', ');
      AppLogger.error('[BLE] Service not found: $serviceUuid');
      AppLogger.info('[BLE] Available services: $available');
      throw StateError(
        'Service UUID not found.\n'
        'Expected: $serviceUuid\n'
        'Device has: ${available.isEmpty ? '(none)' : available}',
      );
    }

    final characteristic = targetService.characteristics.where((c) {
      return _normalizeUuid(c.uuid.toString()) == _normalizeUuid(characteristicUuid);
    }).firstOrNull;

    if (characteristic == null) {
      final available = targetService.characteristics.map((c) => c.uuid.toString()).join(', ');
      AppLogger.error('[BLE] Characteristic not found: $characteristicUuid');
      AppLogger.info('[BLE] Available characteristics: $available');
      throw StateError(
        'Characteristic UUID not found.\n'
        'Expected: $characteristicUuid\n'
        'Service has: ${available.isEmpty ? '(none)' : available}',
      );
    }

    await characteristic.setNotifyValue(true);
    AppLogger.success('[BLE] Subscribed to characteristic notifications');
    return characteristic;
  }

  /// Auto-discovers write and notify characteristics across all services.
  ///
  /// First tries to find a single characteristic that supports both Write and
  /// Notify. If not found (common on ESP32 firmware with split characteristics),
  /// finds the best write char and notify char separately within the same service.
  Future<({
    BluetoothCharacteristic writeCharacteristic,
    BluetoothCharacteristic notifyCharacteristic,
    String serviceUuid,
  })> autoDiscoverCharacteristic(BluetoothDevice device) async {
    final services = await discoverServices(device);

    for (final service in services) {
      final chars = service.characteristics;
      final svcUuid = service.uuid.toString();

      // Pass 1 — single characteristic with both Write + Notify (ideal)
      for (final char in chars) {
        final props = char.properties;
        final canWrite = props.write || props.writeWithoutResponse;
        final canNotify = props.notify || props.indicate;
        if (canWrite && canNotify) {
          await char.setNotifyValue(true);
          AppLogger.success('[BLE] Auto-discovered (combined) → svc=$svcUuid  char=${char.uuid}');
          return (
            writeCharacteristic: char,
            notifyCharacteristic: char,
            serviceUuid: svcUuid,
          );
        }
      }

      // Pass 2 — separate write and notify characteristics in the same service
      final writeChar = chars.where((c) {
        return c.properties.write || c.properties.writeWithoutResponse;
      }).firstOrNull;

      final notifyChar = chars.where((c) {
        return c.properties.notify || c.properties.indicate;
      }).firstOrNull;

      if (writeChar != null && notifyChar != null) {
        await notifyChar.setNotifyValue(true);
        AppLogger.success(
          '[BLE] Auto-discovered (split) → svc=$svcUuid  '
          'write=${writeChar.uuid}  notify=${notifyChar.uuid}',
        );
        return (
          writeCharacteristic: writeChar,
          notifyCharacteristic: notifyChar,
          serviceUuid: svcUuid,
        );
      }
    }

    final allServices = services.map((s) => s.uuid.toString()).join(', ');
    throw StateError(
      'No writable+notifiable characteristic found.\nDevice services: $allServices',
    );
  }

  // ————————————————— Communication —————————————————

  Future<void> writeCommand(
    BluetoothCharacteristic characteristic,
    String command,
  ) async {
    AppLogger.info('[BLE] → Sending: $command');
    final bytes = utf8.encode(command);
    await characteristic.write(bytes, withoutResponse: false);
  }

  Stream<String> notificationStream(
    BluetoothCharacteristic characteristic,
  ) =>
      characteristic.lastValueStream
          .where((bytes) => bytes.isNotEmpty)
          .map((bytes) => utf8.decode(bytes, allowMalformed: true));

  // ————————————————— RSSI —————————————————

  Future<int> readRssi(BluetoothDevice device) async {
    final rssi = await device.readRssi();
    AppLogger.debug('[BLE] RSSI: $rssi dBm');
    return rssi;
  }
}
