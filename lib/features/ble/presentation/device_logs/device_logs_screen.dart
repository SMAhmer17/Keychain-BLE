import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:keychain_ble/core/constants/ble_constants.dart';
import 'package:keychain_ble/core/router/app_route_constants.dart';
import 'package:keychain_ble/features/ble/model/ble_connection_status.dart';
import 'package:keychain_ble/features/ble/model/ble_log_entry.dart';
import 'package:keychain_ble/features/ble/provider/ble_connection_notifier.dart';
import 'package:keychain_ble/features/ble/provider/ble_log_notifier.dart';

class DeviceLogsScreen extends ConsumerStatefulWidget {
  const DeviceLogsScreen({super.key});

  @override
  ConsumerState<DeviceLogsScreen> createState() => _DeviceLogsScreenState();
}

class _DeviceLogsScreenState extends ConsumerState<DeviceLogsScreen> {
  final _commandController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _commandController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionStatus = ref.watch(bleConnectionNotifierProvider);
    final logs = ref.watch(bleLogNotifierProvider);

    // Auto-scroll when logs update
    ref.listen(bleLogNotifierProvider, (_, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    });

    final deviceName = switch (connectionStatus) {
      BleConnected(:final device) => device.name,
      BleConnecting(:final device) => device.name,
      _ => null,
    };

    final isConnected = connectionStatus is BleConnected;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Device Logs'),
            if (deviceName != null)
              Text(
                deviceName,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        actions: [
          _ConnectionChip(status: connectionStatus),
          const SizedBox(width: 4),
          if (isConnected)
            IconButton(
              icon: const Icon(Icons.bluetooth_disabled),
              tooltip: 'Disconnect',
              onPressed: () =>
                  ref.read(bleConnectionNotifierProvider.notifier).disconnect(),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear logs',
            onPressed: ref.read(bleLogNotifierProvider.notifier).clearLogs,
          ),
        ],
      ),
      body: Column(
        children: [
          // ————————————————— Log list / state views —————————————————
          Expanded(
            child: switch (connectionStatus) {
              // Actively connecting — show spinner so user knows it's working
              BleConnecting(:final device) => _ConnectingPlaceholder(
                  deviceName: device.name,
                ),

              // Connected — show logs (or empty hint if none yet)
              BleConnected() => logs.isEmpty
                  ? const Center(
                      child: Text('Connected. Send a command to see logs.'))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemCount: logs.length,
                      itemBuilder: (_, index) =>
                          _LogEntryRow(entry: logs[index]),
                    ),

              // Error — show message + retry / back to discover
              BleError(:final message) => _ErrorPlaceholder(
                  message: message,
                  onGoDiscover: () => context.go(AppRoute.discover),
                ),

              // Idle or disconnected — show logs if any remain, else placeholder
              _ => logs.isNotEmpty
                  ? ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemCount: logs.length,
                      itemBuilder: (_, index) =>
                          _LogEntryRow(entry: logs[index]),
                    )
                  : _NotConnectedPlaceholder(
                      onGoDiscover: () => context.go(AppRoute.discover),
                    ),
            },
          ),

          // ————————————————— Input area (only when connected) —————————————————
          if (isConnected) ...[
            const Divider(height: 1),
            _ColorButtons(onSend: _sendCommand),
            const Divider(height: 1),
            _PresetChips(onSend: _sendCommand),
            const Divider(height: 1),
            _CommandInputBar(
              controller: _commandController,
              onSend: _sendFromTextField,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _sendCommand(String command) async {
    final notifier = ref.read(bleConnectionNotifierProvider.notifier);
    await notifier.sendCommand(command);
    // Add sent entry to log
    ref.read(bleLogNotifierProvider.notifier).addEntry(notifier.sentEntry(command));
  }

  Future<void> _sendFromTextField() async {
    final command = _commandController.text.trim();
    if (command.isEmpty) return;
    _commandController.clear();
    await _sendCommand(command);
  }
}

// ————————————————— Widgets —————————————————

class _ConnectionChip extends StatelessWidget {
  const _ConnectionChip({required this.status});
  final BleConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      BleConnected() => ('Connected', Colors.green),
      BleConnecting() => ('Connecting…', Colors.orange),
      BleDisconnected() => ('Disconnected', Colors.red),
      BleError() => ('Error', Colors.red),
      BleIdle() => ('Idle', Colors.grey),
    };

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _LogEntryRow extends StatelessWidget {
  const _LogEntryRow({required this.entry});
  final BleLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final isSent = entry.direction == BleLogDirection.sent;
    final color = isSent ? Colors.blue.shade700 : Colors.green.shade700;
    final arrow = isSent ? '↑' : '↓';
    final timeStr = DateFormat('HH:mm:ss.SSS').format(entry.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeStr,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 8),
          Text(
            arrow,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              entry.payload,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorButtons extends StatelessWidget {
  const _ColorButtons({required this.onSend});
  final void Function(String) onSend;

  static const _colors = [
    (id: 0, label: 'Red', color: Colors.red),
    (id: 1, label: 'Green', color: Colors.green),
    (id: 2, label: 'Blue', color: Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Text('Color:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 12),
          ..._colors.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: entry.color,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => onSend(
                  jsonEncode({'id': entry.id, 'color': entry.label.toUpperCase()}),
                ),
                child: Text(entry.label, style: const TextStyle(fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetChips extends StatelessWidget {
  const _PresetChips({required this.onSend});
  final void Function(String) onSend;

  @override
  Widget build(BuildContext context) {
    final presets = [
      BleConstants.cmdPing,
      BleConstants.cmdStatus,
      BleConstants.cmdInfuseExample,
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: presets.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) => ActionChip(
          label: Text(presets[index], style: const TextStyle(fontSize: 12)),
          onPressed: () => onSend(presets[index]),
        ),
      ),
    );
  }
}

class _CommandInputBar extends StatelessWidget {
  const _CommandInputBar({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type a command…',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => onSend(),
                textInputAction: TextInputAction.send,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onSend,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectingPlaceholder extends StatelessWidget {
  const _ConnectingPlaceholder({required this.deviceName});
  final String deviceName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 20),
          Text(
            'Connecting to $deviceName…',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Discovering services',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({required this.message, required this.onGoDiscover});
  final String message;
  final VoidCallback onGoDiscover;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            const Text(
              'Connection Failed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.bluetooth_searching),
              label: const Text('Back to Discover'),
              onPressed: onGoDiscover,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotConnectedPlaceholder extends StatelessWidget {
  const _NotConnectedPlaceholder({required this.onGoDiscover});
  final VoidCallback onGoDiscover;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bluetooth_disabled,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Not connected',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: onGoDiscover,
            icon: const Icon(Icons.bluetooth_searching),
            label: const Text('Go to Discover'),
          ),
        ],
      ),
    );
  }
}
