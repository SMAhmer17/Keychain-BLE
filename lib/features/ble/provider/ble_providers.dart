import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keychain_ble/core/service/ble_service.dart';
import 'package:keychain_ble/features/ble/datasource/ble_data_source.dart';
import 'package:keychain_ble/features/ble/repository/ble_repository.dart';
import 'package:keychain_ble/features/ble/repository/ble_repository_impl.dart';

final bleServiceProvider = Provider<BleService>((_) => BleService.instance);

final bleDataSourceProvider = Provider<BleDataSource>(
  (ref) => BleDataSource(ref.watch(bleServiceProvider)),
);

final bleRepositoryProvider = Provider<BleRepository>(
  (ref) => BleRepositoryImpl(ref.watch(bleDataSourceProvider)),
);
