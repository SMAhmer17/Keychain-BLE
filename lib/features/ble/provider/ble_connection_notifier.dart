import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keychain_ble/core/utils/app_logger.dart';
import 'package:keychain_ble/features/ble/model/ble_connection_status.dart';
import 'package:keychain_ble/features/ble/model/ble_device.dart';
import 'package:keychain_ble/features/ble/model/ble_log_entry.dart';
import 'package:keychain_ble/features/ble/provider/ble_config_notifier.dart';
import 'package:keychain_ble/features/ble/provider/ble_providers.dart';
import 'package:keychain_ble/features/ble/repository/ble_repository.dart';

class BleConnectionNotifier extends Notifier<BleConnectionStatus> {
  late BleRepository _repo;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSub;
  BluetoothCharacteristic? _characteristic;
  bool _autoReconnect = false;

  @override
  BleConnectionStatus build() {
    _repo = ref.watch(bleRepositoryProvider);
    ref.onDispose(() {
      _connectionStateSub?.cancel();
    });
    return const BleConnectionStatus.idle();
  }

  // ————————————————— Connection —————————————————

  Future<void> connect(BleDevice device) async {
    state = BleConnectionStatus.connecting(device: device);

    // Read UUIDs from config at connection time so they're always current
    final config = ref.read(bleConfigNotifierProvider);

    try {
      await _repo.connect(device);
      final characteristic = await _repo.subscribeToCharacteristic(
        device,
        serviceUuid: config.serviceUuid,
        characteristicUuid: config.characteristicUuid,
      );
      _characteristic = characteristic;

      final rssi = await _repo.readRssi(device).catchError((_) => 0);

      state = BleConnectionStatus.connected(
        device: device,
        characteristic: characteristic,
        serviceUuid: config.serviceUuid,
        characteristicUuid: config.characteristicUuid,
        rssi: rssi,
      );

      // Watch for unexpected disconnection
      _connectionStateSub?.cancel();
      _connectionStateSub = _repo.connectionStateStream(device).listen((cs) {
        if (cs == BluetoothConnectionState.disconnected) {
          AppLogger.warning('[BLE] Connection lost to ${device.name}');
          state = BleConnectionStatus.disconnected(lastDevice: device);
          _characteristic = null;
          _connectionStateSub?.cancel();

          if (_autoReconnect) {
            Future.delayed(const Duration(seconds: 2), () {
              if (state is BleDisconnected) {
                AppLogger.info('[BLE] Auto-reconnecting to ${device.name}...');
                connect(device);
              }
            });
          }
        }
      });
    } catch (e, stack) {
      AppLogger.error('[BLE] Connection failed', e, stack);
      state = BleConnectionStatus.error(message: e.toString(), device: device);
    }
  }

  Future<void> disconnect() async {
    final current = state;
    final device = switch (current) {
      BleConnected(:final device) => device,
      BleConnecting(:final device) => device,
      _ => null,
    };

    if (device == null) return;

    try {
      _connectionStateSub?.cancel();
      _connectionStateSub = null;
      _characteristic = null;
      await _repo.disconnect(device);
    } catch (e, stack) {
      AppLogger.error('[BLE] Disconnect failed', e, stack);
    } finally {
      state = BleConnectionStatus.disconnected(lastDevice: device);
    }
  }

  // ————————————————— Commands —————————————————

  Future<void> sendCommand(String command) async {
    final char = _characteristic;
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
