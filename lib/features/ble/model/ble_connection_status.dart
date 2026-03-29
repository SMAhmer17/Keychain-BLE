import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:keychain_ble/features/ble/model/ble_device.dart';

part 'ble_connection_status.freezed.dart';

@freezed
sealed class BleConnectionStatus with _$BleConnectionStatus {
  const factory BleConnectionStatus.idle() = BleIdle;

  const factory BleConnectionStatus.connecting({
    required BleDevice device,
  }) = BleConnecting;

  const factory BleConnectionStatus.connected({
    required BleDevice device,
    required BluetoothCharacteristic characteristic,
    required String serviceUuid,
    required String characteristicUuid,
    int? rssi,
  }) = BleConnected;

  const factory BleConnectionStatus.disconnected({
    BleDevice? lastDevice,
  }) = BleDisconnected;

  const factory BleConnectionStatus.error({
    required String message,
    BleDevice? device,
  }) = BleError;
}
