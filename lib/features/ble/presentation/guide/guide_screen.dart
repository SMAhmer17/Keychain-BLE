import 'package:flutter/material.dart';
import 'package:keychain_ble/core/constants/ble_constants.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connection Guide')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionHeader('How to Connect'),
          _StepList(),
          SizedBox(height: 20),
          _SectionHeader('Test Checklist'),
          _ChecklistSection(),
          SizedBox(height: 20),
          _SectionHeader('ESP32 Response Reference'),
          _ResponseReferenceTable(),
          SizedBox(height: 20),
          _SectionHeader('Troubleshooting'),
          _TroubleshootingSection(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ————————————————— Section header —————————————————

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

// ————————————————— How to connect steps —————————————————

class _StepList extends StatelessWidget {
  const _StepList();

  @override
  Widget build(BuildContext context) {
    const steps = [
      'Power on your ESP32 Keychain device.',
      'Enable Bluetooth on your phone.',
      'Open the Discover tab.',
      'Tap "Scan" — your device should appear within 10 seconds.',
      'Tap the device name in the list to connect.',
      'You will be taken to the Logs tab automatically.',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: steps.indexed.map((e) {
            final (i, step) = e;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(step)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ————————————————— Checklist —————————————————

class _ChecklistSection extends StatelessWidget {
  const _ChecklistSection();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('BLE adapter is ON on your phone', true),
      ('ESP32 device is powered and advertising', true),
      ('Device appears in the scan list', true),
      ('Connection succeeds (status shows CONNECTED)', true),
      ('Service UUID matches the constant in BleConstants', false),
      ('Characteristic UUID matches the constant in BleConstants', false),
      ('Send "PING" — response appears in logs', true),
      ('Manual INFUSE command is sent and ESP32 responds', false),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: items.map((item) {
            final (label, basic) = item;
            return ListTile(
              dense: true,
              leading: Icon(
                basic ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                color: basic ? Colors.green : Colors.orange,
                size: 20,
              ),
              title: Text(label, style: const TextStyle(fontSize: 13)),
              subtitle: basic
                  ? null
                  : const Text(
                      'Requires real ESP32 hardware',
                      style: TextStyle(fontSize: 11),
                    ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ————————————————— Response reference table —————————————————

class _ResponseReferenceTable extends StatelessWidget {
  const _ResponseReferenceTable();

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('CONNECTED', 'Device acknowledged connection'),
      ('PEER_DETECTED', 'Another Keychain device is nearby'),
      ('SONG_RECEIVED:ID:USER:name:TIME:ts', 'Received song data from a peer'),
      ('FRIEND_CONFIRMED:user123', 'Friend handshake completed'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: rows.map((row) {
            final (response, meaning) = row;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      response,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Text(
                      meaning,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ————————————————— Troubleshooting —————————————————

class _TroubleshootingSection extends StatelessWidget {
  const _TroubleshootingSection();

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Device not appearing in scan',
        '• Check the ESP32 is powered on\n'
            '• Move closer (< 10 m)\n'
            '• Stop and restart the scan\n'
            '• Reboot the ESP32',
      ),
      (
        'Connection keeps failing',
        '• Go to phone Bluetooth settings and forget the device\n'
            '• Restart Bluetooth on your phone\n'
            '• Power-cycle the ESP32',
      ),
      (
        'No response to commands',
        '• Verify Service UUID: ${BleConstants.serviceUuid}\n'
            '• Verify Char UUID: ${BleConstants.characteristicUuid}\n'
            '• Check ESP32 firmware handles the command format',
      ),
      (
        'App shows "Error" state',
        '• Check the error message in the Status tab\n'
            '• Ensure you granted Bluetooth permissions\n'
            '• On Android 12+, grant Nearby Devices permission',
      ),
    ];

    return Column(
      children: items.map((item) {
        final (question, answer) = item;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
              question,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(answer, style: const TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
