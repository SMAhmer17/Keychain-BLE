import 'package:freezed_annotation/freezed_annotation.dart';

part 'ble_log_entry.freezed.dart';

enum BleLogDirection { sent, received }

@freezed
abstract class BleLogEntry with _$BleLogEntry {
  const factory BleLogEntry({
    required DateTime timestamp,
    required BleLogDirection direction,
    required String payload,
  }) = _BleLogEntry;
}
