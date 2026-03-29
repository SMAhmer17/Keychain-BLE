/// ESP32 BLE UUIDs and configuration constants.
///
/// Replace the placeholder UUIDs below with the real values
/// provided by the hardware team before connecting to a physical device.
class BleConstants {
  BleConstants._();

  // ————————————————— ESP32 UUIDs —————————————————

  /// Primary GATT service UUID exposed by the ESP32.
  static const String serviceUuid =
      '0000FFE0-0000-1000-8000-00805F9B34FB';

  /// Characteristic UUID used for both write (app → ESP32)
  /// and notify (ESP32 → app).
  static const String characteristicUuid =
      '0000FFE1-0000-1000-8000-00805F9B34FB';

  // ————————————————— Scan config —————————————————

  static const Duration scanTimeout = Duration(seconds: 10);

  // ————————————————— RSSI thresholds (dBm) —————————————————

  /// Signal is excellent at or above this value.
  static const int rssiExcellent = -60;

  /// Signal is good at or above this value (below excellent).
  static const int rssiGood = -75;

  /// Signal is fair at or above this value (below good).
  static const int rssiFair = -85;

  // ————————————————— Preset commands —————————————————

  static const String cmdPing = 'PING';
  static const String cmdStatus = 'STATUS';
  static const String cmdInfuseExample = 'INFUSE:ORB1:COLOR:RED';
}
