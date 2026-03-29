import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:keychain_ble/core/utils/app_logger.dart';
import 'package:keychain_ble/features/ble/datasource/ble_data_source.dart';
import 'package:keychain_ble/features/ble/model/ble_device.dart';
import 'package:keychain_ble/features/ble/repository/ble_repository.dart';

class BleRepositoryImpl implements BleRepository {
  BleRepositoryImpl(this._dataSource);

  final BleDataSource _dataSource;

  @override
  Stream<List<BleDevice>> get scanResultsStream => _dataSource.scanResultsStream;

  @override
  Stream<bool> get isScanningStream => _dataSource.isScanningStream;

  @override
  Stream<BluetoothAdapterState> get adapterStateStream =>
      _dataSource.adapterStateStream;

  @override
  Future<void> startScan() async {
    try {
      await _dataSource.startScan();
    } catch (e, stack) {
      AppLogger.error('[BLE] startScan failed', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> stopScan() async {
    try {
      await _dataSource.stopScan();
    } catch (e, stack) {
      AppLogger.error('[BLE] stopScan failed', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> connect(BleDevice device) async {
    try {
      await _dataSource.connect(device);
    } catch (e, stack) {
      AppLogger.error('[BLE] connect failed', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> disconnect(BleDevice device) async {
    try {
      await _dataSource.disconnect(device);
    } catch (e, stack) {
      AppLogger.error('[BLE] disconnect failed', e, stack);
      rethrow;
    }
  }

  @override
  Stream<BluetoothConnectionState> connectionStateStream(BleDevice device) =>
      _dataSource.connectionStateStream(device);

  @override
  Future<BluetoothCharacteristic> subscribeToCharacteristic(
    BleDevice device, {
    required String serviceUuid,
    required String characteristicUuid,
  }) async {
    try {
      return await _dataSource.subscribeToCharacteristic(
        device,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
      );
    } catch (e, stack) {
      AppLogger.error('[BLE] subscribeToCharacteristic failed', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> sendCommand(
    BluetoothCharacteristic characteristic,
    String command,
  ) async {
    try {
      await _dataSource.sendCommand(characteristic, command);
    } catch (e, stack) {
      AppLogger.error('[BLE] sendCommand failed', e, stack);
      rethrow;
    }
  }

  @override
  Stream<String> notificationStream(BluetoothCharacteristic characteristic) =>
      _dataSource.notificationStream(characteristic);

  @override
  Future<int> readRssi(BleDevice device) async {
    try {
      return await _dataSource.readRssi(device);
    } catch (e, stack) {
      AppLogger.error('[BLE] readRssi failed', e, stack);
      rethrow;
    }
  }

}
