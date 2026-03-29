import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ble_device.freezed.dart';

@freezed
abstract class BleDevice with _$BleDevice {
  const factory BleDevice({
    required String remoteId,
    required String name,
    required int rssi,
    required BluetoothDevice rawDevice,
  }) = _BleDevice;
}
