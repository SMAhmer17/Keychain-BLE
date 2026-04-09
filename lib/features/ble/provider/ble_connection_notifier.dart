import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keychain_ble/core/providers/theme_notifier_provider.dart';
import 'package:keychain_ble/core/utils/app_logger.dart';
import 'package:keychain_ble/features/ble/model/ble_connection_status.dart';
import 'package:keychain_ble/features/ble/model/ble_device.dart';
import 'package:keychain_ble/features/ble/model/ble_log_entry.dart';
import 'package:keychain_ble/features/ble/provider/ble_providers.dart';
import 'package:keychain_ble/features/ble/repository/ble_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLastDeviceId = 'ble_last_device_id';
const _kLastDeviceName = 'ble_last_device_name';

class BleConnectionNotifier extends Notifier<BleConnectionStatus> {
  late BleRepository _repo;
  late SharedPreferences _prefs;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSub;
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _notifyCharacteristic;
  bool _autoReconnect = false;
  Timer? _rssiTimer;

  @override
  BleConnectionStatus build() {
    _repo = ref.watch(bleRepositoryProvider);
    _prefs = ref.read(sharedPreferencesProvider);
    ref.onDispose(() {
      _connectionStateSub?.cancel();
      _rssiTimer?.cancel();
    });

    // Check if the device is still connected at OS level after app restart
    Future.microtask(_tryRestoreConnection);

    return const BleConnectionStatus.idle();
  }

  void _startRssiPolling() {
    _rssiTimer?.cancel();
    _rssiTimer = Timer.periodic(const Duration(seconds: 3), (_) => _heartbeat());
  }

  Future<void> _heartbeat() async {
    final current = state;
    if (current is! BleConnected) return;

    // Check OS-level connected devices list — this updates before supervision timeout
    final stillConnected = FlutterBluePlus.connectedDevices
        .any((d) => d.remoteId.str == current.device.remoteId);

    if (!stillConnected) {
      AppLogger.warning('[BLE] Device no longer in OS connected list — disconnecting');
      _onDeviceLost(current.device);
      return;
    }

    // Also update RSSI while connected
    try {
      final rssi = await _repo.readRssi(current.device);
      state = current.copyWith(rssi: rssi);
    } catch (_) {}
  }

  void _onDeviceLost(BleDevice device) {
    _stopRssiPolling();
    _connectionStateSub?.cancel();
    _writeCharacteristic = null;
    _notifyCharacteristic = null;
    state = BleConnectionStatus.disconnected(lastDevice: device);
    if (_autoReconnect) {
      Future.delayed(const Duration(seconds: 2), () {
        if (state is BleDisconnected) connect(device);
      });
    }
  }

  void _stopRssiPolling() {
    _rssiTimer?.cancel();
    _rssiTimer = null;
  }

  // ————————————————— Restore on app reopen —————————————————

  Future<void> _tryRestoreConnection() async {
    final savedId = _prefs.getString(_kLastDeviceId);
    if (savedId == null) return;

    final connectedDevices = FlutterBluePlus.connectedDevices;
    final btDevice = connectedDevices
        .where((d) => d.remoteId.str == savedId)
        .firstOrNull;

    if (btDevice == null) {
      AppLogger.info('[BLE] Last device $savedId not found in connected devices');
      return;
    }

    final savedName = _prefs.getString(_kLastDeviceName) ?? btDevice.platformName;
    AppLogger.info('[BLE] Restoring session with $savedName ($savedId)');

    final device = BleDevice(
      remoteId: savedId,
      name: savedName,
      rssi: 0,
      rawDevice: btDevice,
    );

    state = BleConnectionStatus.connecting(device: device);

    try {
      final discovered = await _repo.autoDiscoverCharacteristic(device);
      _writeCharacteristic = discovered.writeCharacteristic;
      _notifyCharacteristic = discovered.notifyCharacteristic;

      final rssi = await _repo.readRssi(device).catchError((_) => 0);

      state = BleConnectionStatus.connected(
        device: device,
        characteristic: discovered.notifyCharacteristic,
        serviceUuid: discovered.serviceUuid,
        characteristicUuid: discovered.notifyCharacteristic.uuid.toString(),
        rssi: rssi,
      );

      _watchConnectionState(device);
      _startRssiPolling();
      AppLogger.success('[BLE] Session restored with $savedName');
    } catch (e, stack) {
      AppLogger.error('[BLE] Failed to restore session', e, stack);
      state = const BleConnectionStatus.idle();
    }
  }

  // ————————————————— Connection —————————————————

  Future<void> connect(BleDevice device) async {
    state = BleConnectionStatus.connecting(device: device);

    try {
      await _repo.connect(device);

      final discovered = await _repo.autoDiscoverCharacteristic(device);
      _writeCharacteristic = discovered.writeCharacteristic;
      _notifyCharacteristic = discovered.notifyCharacteristic;

      final rssi = await _repo.readRssi(device).catchError((_) => 0);

      await _prefs.setString(_kLastDeviceId, device.remoteId);
      await _prefs.setString(_kLastDeviceName, device.name);

      state = BleConnectionStatus.connected(
        device: device,
        characteristic: discovered.notifyCharacteristic,
        serviceUuid: discovered.serviceUuid,
        characteristicUuid: discovered.notifyCharacteristic.uuid.toString(),
        rssi: rssi,
      );

      _watchConnectionState(device);
      _startRssiPolling();
    } catch (e, stack) {
      AppLogger.error('[BLE] Connection failed', e, stack);
      state = BleConnectionStatus.error(message: e.toString(), device: device);
    }
  }

  void _watchConnectionState(BleDevice device) {
    _connectionStateSub?.cancel();
    _connectionStateSub = _repo.connectionStateStream(device).listen((cs) {
      if (cs == BluetoothConnectionState.disconnected) {
        AppLogger.warning('[BLE] Connection lost to ${device.name}');
        _onDeviceLost(device);
      }
    });
  }

  Future<void> disconnect() async {
    final current = state;
    final device = switch (current) {
      BleConnected(:final device) => device,
      BleConnecting(:final device) => device,
      _ => null,
    };

    if (device == null) return;

    await _prefs.remove(_kLastDeviceId);
    await _prefs.remove(_kLastDeviceName);

    try {
      _stopRssiPolling();
      _connectionStateSub?.cancel();
      _connectionStateSub = null;
      _writeCharacteristic = null;
      _notifyCharacteristic = null;
      await _repo.disconnect(device);
    } catch (e, stack) {
      AppLogger.error('[BLE] Disconnect failed', e, stack);
    } finally {
      state = BleConnectionStatus.disconnected(lastDevice: device);
    }
  }

  // ————————————————— Commands —————————————————

  Future<void> sendCommand(String command) async {
    final char = _writeCharacteristic;
    if (char == null) {
      AppLogger.warning('[BLE] sendCommand called but not connected');
      return;
    }
    try {
      await _repo.sendCommand(char, command);
    } catch (e, stack) {
      AppLogger.error('[BLE] sendCommand failed', e, stack);
    }
  }

  Stream<String> notificationStream(BluetoothCharacteristic characteristic) =>
      _repo.notificationStream(characteristic);

  // ————————————————— RSSI polling —————————————————

  Future<void> refreshRssi() async {
    final current = state;
    if (current is! BleConnected) return;
    try {
      final rssi = await _repo.readRssi(current.device);
      state = current.copyWith(rssi: rssi);
    } catch (_) {}
  }

  // ————————————————— Auto-reconnect toggle —————————————————

  void setAutoReconnect(bool enabled) => _autoReconnect = enabled;

  bool get autoReconnect => _autoReconnect;

  // ————————————————— Log helper (called from UI) —————————————————

  BleLogEntry sentEntry(String command) => BleLogEntry(
        timestamp: DateTime.now(),
        direction: BleLogDirection.sent,
        payload: command,
      );
}

final bleConnectionNotifierProvider =
    NotifierProvider<BleConnectionNotifier, BleConnectionStatus>(
  BleConnectionNotifier.new,
);
