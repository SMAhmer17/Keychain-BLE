# Keychain BLE

A Flutter application for connecting to and communicating with BLE (Bluetooth Low Energy) devices such as the ESP32. Built with Riverpod 3 and flutter_blue_plus.

---

## What It Does

Keychain BLE acts as a BLE central (client). It scans for nearby BLE peripherals, connects to them, and sends/receives JSON commands over a GATT characteristic. The primary use case is controlling an ESP32-based keychain device by sending color commands.

---

## Features

- Scan for nearby BLE devices (named devices only — anonymous devices are filtered out)
- Connect to any BLE peripheral with configurable Service and Characteristic UUIDs
- Send JSON commands with one tap via color shortcut buttons (Red, Green, Blue)
- Send custom text/command via a free-text input field
- Preset command chips for quick sends (PING, STATUS, INFUSE)
- Live log of all sent (↑) and received (↓) messages with timestamps
- Connection status screen with RSSI signal strength monitoring
- Auto-reconnect on unexpected disconnection
- UUID configuration without recompiling (gear icon on Discover screen)
- Supports both 16-bit short UUIDs (`FFE0`) and full 128-bit UUIDs

---

## Tech Stack

| Layer | Technology |
|---|---|
| State Management | Riverpod 3 (`Notifier`) |
| Navigation | GoRouter (StatefulShellRoute) |
| BLE | flutter_blue_plus v1.35.3 |
| Local Storage | SharedPreferences (UUID config persistence) |
| Models | Freezed (immutable sealed classes) |

---

## App Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── ble_constants.dart      # UUIDs, RSSI thresholds, preset commands
│   ├── router/                     # GoRouter + 4-tab shell
│   ├── service/
│   │   ├── ble_service.dart        # flutter_blue_plus wrapper
│   │   └── ble_permission_service.dart
│   └── utils/
│       └── app_logger.dart
├── features/
│   └── ble/
│       ├── datasource/
│       │   └── ble_data_source.dart      # Maps scan results → BleDevice
│       ├── repository/
│       │   └── ble_repository_impl.dart  # Error handling wrapper
│       ├── provider/
│       │   ├── ble_scan_notifier.dart    # Scan state
│       │   ├── ble_connection_notifier.dart  # Connection + send
│       │   ├── ble_log_notifier.dart     # Message log
│       │   └── ble_config_notifier.dart  # UUID persistence
│       ├── model/
│       │   ├── ble_device.dart
│       │   ├── ble_connection_status.dart
│       │   └── ble_log_entry.dart
│       └── presentation/
│           ├── discover/           # Scan screen
│           ├── device_logs/        # Send commands + message log
│           ├── connection_status/  # RSSI + device info
│           └── guide/              # Help screen
└── main.dart
```

---

## How It Works

### 1. Scanning

The app uses `flutter_blue_plus` to scan for BLE peripherals. Only devices that broadcast a name (Complete Local Name in advertisement packet) are shown. Anonymous/unnamed devices are filtered out.

### 2. Connecting

When a device is tapped, the app:
1. Stops the scan
2. Calls `device.connect()`
3. Calls `device.discoverServices()`
4. Finds the target service by UUID (supports both short and full UUID formats)
5. Finds the target characteristic and enables notifications (`setNotifyValue(true)`)
6. Transitions to `BleConnected` state

### 3. Sending Data

All commands are UTF-8 encoded and written to the characteristic using `characteristic.write(bytes, withoutResponse: false)`.

**Color buttons** send JSON payloads:

| Button | Payload sent |
|---|---|
| Red | `{"id":0,"color":"RED"}` |
| Green | `{"id":1,"color":"GREEN"}` |
| Blue | `{"id":2,"color":"BLUE"}` |

**Preset chips** send plain text commands:
- `PING`
- `STATUS`
- `INFUSE:ORB1:COLOR:RED`

**Custom input** — type any string and tap Send.

### 4. Receiving Data

The app subscribes to characteristic notifications. Every incoming byte array is decoded as UTF-8 and shown as a green `↓` entry in the Logs screen.

### 5. UUID Configuration

Default UUIDs (matching a standard ESP32 BLE UART setup):

| | UUID |
|---|---|
| Service | `0000FFE0-0000-1000-8000-00805F9B34FB` |
| Characteristic | `0000FFE1-0000-1000-8000-00805F9B34FB` |

These can be changed at runtime by tapping the **gear icon (⚙)** on the Discover screen. Values are persisted to SharedPreferences.

---

## BLE Connection State Machine

```
BleIdle
  └─► BleConnecting   (tapped a device)
        ├─► BleConnected    (services discovered + characteristic subscribed)
        └─► BleError        (connection or discovery failed)

BleConnected
  └─► BleDisconnected  (user disconnects or device drops)
        └─► BleConnecting   (reconnect / discover again)
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- Physical iOS or Android device (BLE does not work on simulators/emulators)
- An ESP32 or any BLE peripheral exposing the FFE0/FFE1 service

### Run

```bash
flutter pub get
flutter run
```

### Permissions

**Android** — declared in `AndroidManifest.xml`:
- `BLUETOOTH_SCAN`
- `BLUETOOTH_CONNECT`
- `ACCESS_FINE_LOCATION` (Android 11 and below)

**iOS** — declared in `Info.plist`:
- `NSBluetoothAlwaysUsageDescription`

---

## Testing Without ESP32

Use **nRF Connect** (free, iOS + Android) on a second phone to emulate a BLE peripheral:

1. Open nRF Connect → **ADVERTISER** tab → create a new advertiser
2. Add record: **Complete Local Name** → e.g. `EXP 32`
3. Enable **Connectable** + **Discoverable** in Options
4. Go to **☰ → GATT Server** → add service `FFE0` → add characteristic `FFE1` with **Write + Notify** properties
5. Start advertising
6. Open Keychain BLE → Discover → tap the device → connect
7. Press color buttons → verify in nRF Connect GATT Server that the characteristic value updates with the received JSON

---

## Key Files

| File | Purpose |
|---|---|
| [ble_constants.dart](lib/core/constants/ble_constants.dart) | Default UUIDs and preset commands |
| [ble_service.dart](lib/core/service/ble_service.dart) | Low-level BLE operations |
| [ble_connection_notifier.dart](lib/features/ble/provider/ble_connection_notifier.dart) | Connection state + send logic |
| [device_logs_screen.dart](lib/features/ble/presentation/device_logs/device_logs_screen.dart) | Color buttons + log UI |
| [ble_data_source.dart](lib/features/ble/datasource/ble_data_source.dart) | Scan result mapping + name filter |

---

*Maintained by Sh M Ahmer*
