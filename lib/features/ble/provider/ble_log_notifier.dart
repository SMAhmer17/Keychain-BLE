import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keychain_ble/core/utils/app_logger.dart';
import 'package:keychain_ble/features/ble/model/ble_connection_status.dart';
import 'package:keychain_ble/features/ble/model/ble_log_entry.dart';
import 'package:keychain_ble/features/ble/provider/ble_connection_notifier.dart';

const _maxLogEntries = 500;

class BleLogNotifier extends Notifier<List<BleLogEntry>> {
  StreamSubscription<String>? _notificationSub;

  @override
  List<BleLogEntry> build() {
    ref.listen<BleConnectionStatus>(
      bleConnectionNotifierProvider,
      (previous, next) {
        next.maybeWhen(
          connected: (device, characteristic, serviceUuid, charUuid, rssi) {
            _notificationSub?.cancel();
            _notificationSub = ref
                .read(bleConnectionNotifierProvider.notifier)
                .notificationStream(characteristic)
                .listen(
              (payload) {
                AppLogger.success('[BLE] ← Received: $payload');
                addEntry(BleLogEntry(
                  timestamp: DateTime.now(),
                  direction: BleLogDirection.received,
                  payload: payload,
                ));
              },
              onError: (Object e) {
                AppLogger.error('[BLE] Notification stream error', e);
              },
            );
          },
          orElse: () {
            _notificationSub?.cancel();
            _notificationSub = null;
          },
        );
      },
    );

    ref.onDispose(() => _notificationSub?.cancel());

    return [];
  }

  void addEntry(BleLogEntry entry) {
    final updated = [...state, entry];
    if (updated.length > _maxLogEntries) {
      state = updated.sublist(updated.length - _maxLogEntries);
    } else {
      state = updated;
    }
  }

  void clearLogs() => state = [];
}

final bleLogNotifierProvider =
    NotifierProvider<BleLogNotifier, List<BleLogEntry>>(BleLogNotifier.new);
