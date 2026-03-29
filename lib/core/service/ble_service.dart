import 'dart:convert';

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
    await FlutterBluePlus.startScan(timeout: timeout);
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
      AppLogger.error('[BLE] Service not found: $serviceUuid');
      AppLogger.info('[BLE] Available services: ${services.map((s) => s.uuid.toString()).join(', ')}');
      throw StateError('Service $serviceUuid not found on ${device.platformName}');
    }

    final characteristic = targetService.characteristics.where((c) {
      return _normalizeUuid(c.uuid.toString()) == _normalizeUuid(characteristicUuid);
    }).firstOrNull;

    if (characteristic == null) {
      AppLogger.error('[BLE] Characteristic not found: $characteristicUuid');
      AppLogger.info('[BLE] Available characteristics: ${targetService.characteristics.map((c) => c.uuid.toString()).join(', ')}');
      throw StateError('Characteristic $characteristicUuid not found');
    }

    await characteristic.setNotifyValue(true);
    AppLogger.success('[BLE] Subscribed to characteristic notifications');
    return characteristic;
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
