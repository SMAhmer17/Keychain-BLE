import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:keychain_ble/core/service/ble_service.dart';
import 'package:keychain_ble/features/ble/model/ble_device.dart';

class BleDataSource {
  BleDataSource(this._service);

  final BleService _service;

  // ————————————————— Scan —————————————————

  Future<void> startScan() => _service.startScan();

  Future<void> stopScan() => _service.stopScan();

  Stream<bool> get isScanningStream => _service.isScanningStream;

  Stream<List<BleDevice>> get scanResultsStream =>
      _service.scanResultsStream.map(
        (results) {
          final named = <BleDevice>[];
          for (final r in results) {
            final name = r.device.platformName.isNotEmpty
                ? r.device.platformName
                : r.advertisementData.advName.isNotEmpty
                    ? r.advertisementData.advName
                    : null;
            if (name == null) continue; // skip unnamed/anonymous devices
            named.add(BleDevice(
              remoteId: r.device.remoteId.str,
              name: name,
              rssi: r.rssi,
              rawDevice: r.device,
            ));
          }
          return named;
        },
      );

  // ————————————————— Connection —————————————————

  Future<void> connect(BleDevice device) =>
      _service.connect(device.rawDevice);

  Future<void> disconnect(BleDevice device) =>
      _service.disconnect(device.rawDevice);

  Stream<BluetoothConnectionState> connectionStateStream(BleDevice device) =>
      _service.connectionStateStream(device.rawDevice);

  Future<BluetoothCharacteristic> subscribeToCharacteristic(
    BleDevice device, {
    required String serviceUuid,
    required String characteristicUuid,
  }) =>
      _service.subscribeToCharacteristic(
        device.rawDevice,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
      );

  // ————————————————— Communication —————————————————

  Future<void> sendCommand(
    BluetoothCharacteristic characteristic,
    String command,
  ) =>
      _service.writeCommand(characteristic, command);

  Stream<String> notificationStream(BluetoothCharacteristic characteristic) =>
      _service.notificationStream(characteristic);

  // ————————————————— RSSI —————————————————

  Future<int> readRssi(BleDevice device) =>
      _service.readRssi(device.rawDevice);

  // ————————————————— Adapter state —————————————————

  Stream<BluetoothAdapterState> get adapterStateStream =>
      _service.adapterStateStream;

}
