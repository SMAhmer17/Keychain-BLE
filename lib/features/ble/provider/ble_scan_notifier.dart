import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:keychain_ble/core/utils/app_logger.dart';
import 'package:keychain_ble/features/ble/model/ble_device.dart';
import 'package:keychain_ble/features/ble/provider/ble_providers.dart';
import 'package:keychain_ble/features/ble/repository/ble_repository.dart';

part 'ble_scan_notifier.freezed.dart';

@freezed
abstract class BleScanState with _$BleScanState {
  const factory BleScanState({
    @Default([]) List<BleDevice> devices,
    @Default(false) bool isScanning,
    String? errorMessage,
  }) = _BleScanState;
}

class BleScanNotifier extends Notifier<BleScanState> {
  late BleRepository _repo;
  StreamSubscription<List<BleDevice>>? _scanSub;

  @override
  BleScanState build() {
    _repo = ref.watch(bleRepositoryProvider);
    ref.onDispose(() {
      _scanSub?.cancel();
      _repo.stopScan();
    });
    return const BleScanState();
  }

  Future<void> startScan() async {
    await _scanSub?.cancel();
    state = state.copyWith(devices: [], isScanning: true, errorMessage: null);

    _scanSub = _repo.scanResultsStream.listen(
      (devices) {
        // Deduplicate by remoteId, keep best RSSI
        final map = <String, BleDevice>{};
        for (final d in devices) {
          final existing = map[d.remoteId];
          if (existing == null || d.rssi > existing.rssi) {
            map[d.remoteId] = d;
          }
        }
        state = state.copyWith(devices: map.values.toList());
      },
      onError: (Object e) {
        AppLogger.error('[BLE] Scan stream error', e);
        state = state.copyWith(
          isScanning: false,
          errorMessage: e.toString(),
        );
      },
    );

    try {
      await _repo.startScan();
    } catch (e, stack) {
      AppLogger.error('[BLE] startScan failed', e, stack);
      state = state.copyWith(
        isScanning: false,
        errorMessage: e.toString(),
      );
      return;
    }

    // Scan timeout — mark scanning as done
    state = state.copyWith(isScanning: false);
  }

  Future<void> stopScan() async {
    await _scanSub?.cancel();
    _scanSub = null;
    await _repo.stopScan();
    state = state.copyWith(isScanning: false);
  }

  void clearError() => state = state.copyWith(errorMessage: null);
}

final bleScanNotifierProvider =
    NotifierProvider<BleScanNotifier, BleScanState>(BleScanNotifier.new);
