import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:keychain_ble/core/constants/ble_constants.dart';
import 'package:keychain_ble/core/providers/theme_notifier_provider.dart';
import 'package:keychain_ble/core/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'ble_config_notifier.freezed.dart';

// ————————————————— SharedPreferences keys —————————————————
const _kServiceUuid = 'ble_service_uuid';
const _kCharUuid = 'ble_char_uuid';

@freezed
abstract class BleConfig with _$BleConfig {
  const factory BleConfig({
    required String serviceUuid,
    required String characteristicUuid,
  }) = _BleConfig;

  /// Default values from [BleConstants] — used when nothing is saved yet.
  factory BleConfig.defaults() => const BleConfig(
        serviceUuid: BleConstants.serviceUuid,
        characteristicUuid: BleConstants.characteristicUuid,
      );
}

class BleConfigNotifier extends Notifier<BleConfig> {
  late SharedPreferences _prefs;

  @override
  BleConfig build() {
    _prefs = ref.read(sharedPreferencesProvider);
    return BleConfig(
      serviceUuid: _prefs.getString(_kServiceUuid) ?? BleConstants.serviceUuid,
      characteristicUuid:
          _prefs.getString(_kCharUuid) ?? BleConstants.characteristicUuid,
    );
  }

  Future<void> updateServiceUuid(String uuid) async {
    final trimmed = uuid.trim();
    AppLogger.info('[Config] Service UUID updated → $trimmed');
    await _prefs.setString(_kServiceUuid, trimmed);
    state = state.copyWith(serviceUuid: trimmed);
  }

  Future<void> updateCharacteristicUuid(String uuid) async {
    final trimmed = uuid.trim();
    AppLogger.info('[Config] Characteristic UUID updated → $trimmed');
    await _prefs.setString(_kCharUuid, trimmed);
    state = state.copyWith(characteristicUuid: trimmed);
  }

  Future<void> resetToDefaults() async {
    AppLogger.info('[Config] UUIDs reset to defaults');
    await _prefs.remove(_kServiceUuid);
    await _prefs.remove(_kCharUuid);
    state = BleConfig.defaults();
  }
}

final bleConfigNotifierProvider =
    NotifierProvider<BleConfigNotifier, BleConfig>(BleConfigNotifier.new);
