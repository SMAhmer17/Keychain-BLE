import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:keychain_ble/core/constants/ble_constants.dart';
import 'package:keychain_ble/core/router/app_route_constants.dart';
import 'package:keychain_ble/features/ble/model/ble_connection_status.dart';
import 'package:keychain_ble/features/ble/presentation/widgets/uuid_config_dialog.dart';
import 'package:keychain_ble/features/ble/provider/ble_config_notifier.dart';
import 'package:keychain_ble/features/ble/provider/ble_connection_notifier.dart';

class ConnectionStatusScreen extends ConsumerStatefulWidget {
  const ConnectionStatusScreen({super.key});

  @override
  ConsumerState<ConnectionStatusScreen> createState() =>
      _ConnectionStatusScreenState();
}

class _ConnectionStatusScreenState
    extends ConsumerState<ConnectionStatusScreen> {
  bool _autoReconnect = false;

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(bleConnectionNotifierProvider);
    final config = ref.watch(bleConfigNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_ethernet),
            tooltip: 'Configure UUIDs',
            onPressed: () => UuidConfigDialog.show(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ————————————————— State badge —————————————————
          _StateBadgeCard(status: status),
          const SizedBox(height: 12),

          // ————————————————— Device info —————————————————
          status.maybeWhen(
            connected: (device, _, _, _, rssi) => Column(
              children: [
                _InfoCard(
                  title: 'Device',
                  icon: Icons.devices,
                  children: [
                    _InfoRow(label: 'Name', value: device.name),
                    _InfoRow(label: 'ID', value: device.remoteId),
                  ],
                ),
                const SizedBox(height: 12),
                _RssiCard(rssi: rssi),
                const SizedBox(height: 12),
                _InfoCard(
                  title: 'Services',
                  icon: Icons.settings_ethernet,
                  children: [
                    _CopyRow(
                      label: 'Service UUID',
                      value: config.serviceUuid,
                    ),
                    _CopyRow(
                      label: 'Char UUID',
                      value: config.characteristicUuid,
                    ),
                  ],
                ),
              ],
            ),
            disconnected: (lastDevice) => _InfoCard(
              title: 'Last Device',
              icon: Icons.history,
              children: [
                _InfoRow(
                  label: 'Name',
                  value: lastDevice?.name ?? '—',
                ),
                _InfoRow(
                  label: 'ID',
                  value: lastDevice?.remoteId ?? '—',
                ),
              ],
            ),
            orElse: () => const SizedBox.shrink(),
          ),

          const SizedBox(height: 12),

          // ————————————————— Controls —————————————————
          _InfoCard(
            title: 'Controls',
            icon: Icons.tune,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Auto-Reconnect'),
                subtitle: const Text('Re-attempt connection on unexpected drop'),
                value: _autoReconnect,
                onChanged: (value) {
                  setState(() => _autoReconnect = value);
                  ref
                      .read(bleConnectionNotifierProvider.notifier)
                      .setAutoReconnect(value);
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ————————————————— Action buttons —————————————————
          if (status is BleConnected)
            OutlinedButton.icon(
              icon: const Icon(Icons.bluetooth_disabled),
              label: const Text('Disconnect'),
              onPressed: () =>
                  ref.read(bleConnectionNotifierProvider.notifier).disconnect(),
            ),

          if (status is BleDisconnected) ...[
            if (status.lastDevice != null)
              FilledButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reconnect'),
                onPressed: () => ref
                    .read(bleConnectionNotifierProvider.notifier)
                    .connect(status.lastDevice!),
              ),
            const SizedBox(height: 8),
          ],

          if (status is BleError && status.device != null) ...[
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Connection'),
              onPressed: () => ref
                  .read(bleConnectionNotifierProvider.notifier)
                  .connect(status.device!),
            ),
            const SizedBox(height: 8),
          ],

          OutlinedButton.icon(
            icon: const Icon(Icons.bluetooth_searching),
            label: const Text('Discover Again'),
            onPressed: () => context.go(AppRoute.discover),
          ),
        ],
      ),
    );
  }
}

// ————————————————— Sub-widgets —————————————————

class _StateBadgeCard extends StatelessWidget {
  const _StateBadgeCard({required this.status});
  final BleConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (status) {
      BleConnected() => ('CONNECTED', Colors.green, Icons.bluetooth_connected),
      BleConnecting() => ('CONNECTING…', Colors.orange, Icons.bluetooth_searching),
      BleDisconnected() => ('DISCONNECTED', Colors.red, Icons.bluetooth_disabled),
      BleError(:final message) => ('ERROR', Colors.red, Icons.error_outline),
      BleIdle() => ('IDLE', Colors.grey, Icons.bluetooth),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RssiCard extends StatelessWidget {
  const _RssiCard({required this.rssi});
  final int? rssi;

  @override
  Widget build(BuildContext context) {
    final value = rssi ?? 0;
    final color = _rssiColor(value);
    final label = _rssiLabel(value);
    final fraction = ((value + 100) / 60).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.signal_cellular_alt, color: color),
                const SizedBox(width: 8),
                Text(
                  'Signal Strength',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                Text(
                  rssi != null ? '$value dBm' : '—',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Text(label, style: TextStyle(color: color, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: fraction,
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  Color _rssiColor(int rssi) {
    if (rssi >= BleConstants.rssiExcellent) return Colors.green;
    if (rssi >= BleConstants.rssiGood) return Colors.orange;
    if (rssi >= BleConstants.rssiFair) return Colors.amber;
    return Colors.red;
  }

  String _rssiLabel(int rssi) {
    if (rssi >= BleConstants.rssiExcellent) return 'Excellent';
    if (rssi >= BleConstants.rssiGood) return 'Good';
    if (rssi >= BleConstants.rssiFair) return 'Fair';
    return 'Weak';
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyRow extends StatelessWidget {
  const _CopyRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Copy',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied to clipboard'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
