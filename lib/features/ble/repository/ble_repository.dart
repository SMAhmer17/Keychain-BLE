import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:keychain_ble/features/ble/model/ble_device.dart';

abstract class BleRepository {
  Stream<List<BleDevice>> get scanResultsStream;
  Stream<bool> get isScanningStream;
  Stream<BluetoothAdapterState> get adapterStateStream;

  Future<void> startScan();
  Future<void> stopScan();

  Future<void> connect(BleDevice device);
  Future<void> disconnect(BleDevice device);
  Stream<BluetoothConnectionState> connectionStateStream(BleDevice device);
  Future<BluetoothCharacteristic> subscribeToCharacteristic(
    BleDevice device, {
    required String serviceUuid,
    required String characteristicUuid,
  });

  Future<void> sendCommand(BluetoothCharacteristic characteristic, String command);
  Stream<String> notificationStream(BluetoothCharacteristic characteristic);

  Future<int> readRssi(BleDevice device);
}
