import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:keychain_ble/core/constants/ble_constants.dart';
import 'package:keychain_ble/core/router/app_route_constants.dart';
import 'package:keychain_ble/core/service/ble_permission_service.dart';
import 'package:keychain_ble/features/ble/model/ble_device.dart';
import 'package:keychain_ble/features/ble/presentation/widgets/uuid_config_dialog.dart';
import 'package:keychain_ble/features/ble/provider/ble_config_notifier.dart';
import 'package:keychain_ble/features/ble/provider/ble_connection_notifier.dart';
import 'package:keychain_ble/features/ble/provider/ble_scan_notifier.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  BlePermissionResult? _permissionResult;
  bool _checkingPermissions = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndScan());
  }

  Future<void> _checkAndScan() async {
    setState(() => _checkingPermissions = true);

    final result = await BlePermissionService.instance.checkAndRequest();
    if (!mounted) return;

    setState(() {
      _permissionResult = result;
      _checkingPermissions = false;
    });

    if (result == BlePermissionResult.granted) {
      ref.read(bleScanNotifierProvider.notifier).startScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(bleScanNotifierProvider);
    final config = ref.watch(bleConfigNotifierProvider);

    if (_checkingPermissions) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_permissionResult != null &&
        _permissionResult != BlePermissionResult.granted) {
      return _PermissionBlocker(
        result: _permissionResult!,
        onRetry: _checkAndScan,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Devices'),
        actions: [
          if (scanState.isScanning)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
        // UUID info bar — always visible, shows what's currently configured
        bottom: _UuidInfoBar(
          serviceUuid: config.serviceUuid,
          charUuid: config.characteristicUuid,
          onEdit: () => UuidConfigDialog.show(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _checkAndScan,
        child: Column(
          children: [
            if (scanState.errorMessage != null)
              _ErrorBanner(
                message: scanState.errorMessage!,
                onDismiss:
                    ref.read(bleScanNotifierProvider.notifier).clearError,
              ),
            Expanded(
              child: scanState.devices.isEmpty
                  ? _EmptyState(isScanning: scanState.isScanning)
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: scanState.devices.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final device = scanState.devices[index];
                        return _DeviceTile(
                          device: device,
                          onTap: () => _connectToDevice(device),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: scanState.isScanning
            ? () => ref.read(bleScanNotifierProvider.notifier).stopScan()
            : _checkAndScan,
        icon: Icon(
          scanState.isScanning ? Icons.stop : Icons.bluetooth_searching,
        ),
        label: Text(scanState.isScanning ? 'Stop' : 'Scan'),
      ),
    );
  }

  void _connectToDevice(BleDevice device) {
    // Stop scan first (fire-and-forget — no need to await)
    ref.read(bleScanNotifierProvider.notifier).stopScan();

    // Navigate to Logs immediately so the user sees the live connection
    // progress (CONNECTING → CONNECTED / ERROR) on that screen.
    context.go(AppRoute.logs);

    // Start connection in the background — Logs screen watches state.
    ref.read(bleConnectionNotifierProvider.notifier).connect(device);
  }
}

// ————————————————— UUID info bar ——————————————————

class _UuidInfoBar extends StatelessWidget implements PreferredSizeWidget {
  const _UuidInfoBar({
    required this.serviceUuid,
    required this.charUuid,
    required this.onEdit,
  });

  final String serviceUuid;
  final String charUuid;
  final VoidCallback onEdit;

  // Shorten a UUID to first 8 chars + "…" for display
  String _short(String uuid) =>
      uuid.length > 8 ? '${uuid.substring(0, 8)}…' : uuid;

  @override
  Size get preferredSize => const Size.fromHeight(36);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDefault = serviceUuid == BleConstants.serviceUuid &&
        charUuid == BleConstants.characteristicUuid;

    return Container(
      height: 36,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            isDefault ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            size: 14,
            color: isDefault ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'SVC: ${_short(serviceUuid)}  •  CHR: ${_short(charUuid)}',
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(fontSize: 11),
            ),
            icon: const Icon(Icons.edit, size: 13),
            label: const Text('Edit'),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

// ————————————————— Permission blocker ——————————————————

class _PermissionBlocker extends StatelessWidget {
  const _PermissionBlocker({required this.result, required this.onRetry});

  final BlePermissionResult result;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final (icon, title, body, actionLabel, action) = switch (result) {
      BlePermissionResult.bluetoothOff => (
          Icons.bluetooth_disabled,
          'Bluetooth is Off',
          'Enable Bluetooth in your device settings, then try again.',
          'Try Again',
          onRetry,
        ),
      BlePermissionResult.denied => (
          Icons.lock_outline,
          'Permissions Required',
          'Keychain BLE needs Bluetooth permission to scan for nearby devices.',
          'Grant Permission',
          onRetry,
        ),
      BlePermissionResult.permanentlyDenied => (
          Icons.lock,
          'Permission Denied',
          'Bluetooth permission was permanently denied. Open app settings to grant it.',
          'Open Settings',
          () => openAppSettings(),
        ),
      _ => (
          Icons.error_outline,
          'Something Went Wrong',
          'Could not start BLE scanning.',
          'Retry',
          onRetry,
        ),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Discover Devices')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 72, color: Colors.grey.shade400),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                body,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel),
                onPressed: action,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ————————————————— Device tile ——————————————————

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device, required this.onTap});

  final BleDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rssiColor = _rssiColor(device.rssi);
    final rssiLabel = _rssiLabel(device.rssi);

    return ListTile(
      leading: Icon(Icons.bluetooth, color: rssiColor),
      title: Text(device.name,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        device.remoteId,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${device.rssi} dBm',
            style: TextStyle(
                color: rssiColor, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(rssiLabel, style: TextStyle(color: rssiColor, fontSize: 11)),
        ],
      ),
      onTap: onTap,
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

// ————————————————— Empty state ——————————————————

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isScanning});

  final bool isScanning;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bluetooth_disabled,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            isScanning ? 'Scanning for devices…' : 'No devices found',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down or tap Scan to search',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

// ————————————————— Error banner ——————————————————

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      backgroundColor: Colors.red.shade50,
      content: Text(message, style: const TextStyle(color: Colors.red)),
      actions: [
        TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
      ],
    );
  }
}
