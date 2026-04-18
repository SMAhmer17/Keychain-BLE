import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:keychain_ble/core/constants/ble_constants.dart';
import 'package:keychain_ble/core/service/ble_permission_service.dart';
import 'package:keychain_ble/features/ble/model/ble_connection_status.dart';
import 'package:keychain_ble/features/ble/model/ble_device.dart';
import 'package:keychain_ble/features/ble/provider/ble_connection_notifier.dart';
import 'package:keychain_ble/features/ble/provider/ble_scan_notifier.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry point helper
// ─────────────────────────────────────────────────────────────────────────────

Future<void> showBleDeviceDialog(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const BleDeviceDialog(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// BleDeviceDialog
// ─────────────────────────────────────────────────────────────────────────────

class BleDeviceDialog extends ConsumerStatefulWidget {
  const BleDeviceDialog({super.key});

  @override
  ConsumerState<BleDeviceDialog> createState() => _BleDeviceDialogState();
}

class _BleDeviceDialogState extends ConsumerState<BleDeviceDialog>
    with TickerProviderStateMixin {
  BlePermissionResult? _permResult;
  bool _checkingPerms = true;

  // Pulse animation for the scanning dot indicator
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  // Rotation animation for the bluetooth icon while scanning
  late final AnimationController _rotateCtrl;
  late final Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _rotateAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_rotateCtrl);

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndScan());
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkAndScan() async {
    setState(() => _checkingPerms = true);
    final result = await BlePermissionService.instance.checkAndRequest();
    if (!mounted) return;
    setState(() {
      _permResult = result;
      _checkingPerms = false;
    });
    if (result == BlePermissionResult.granted) {
      ref.read(bleScanNotifierProvider.notifier).startScan();
    }
  }

  void _connectToDevice(BleDevice device) {
    ref.read(bleScanNotifierProvider.notifier).stopScan();
    ref.read(bleConnectionNotifierProvider.notifier).connect(device);
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(bleScanNotifierProvider);
    final connState = ref.watch(bleConnectionNotifierProvider);

    // Auto-dismiss when connection succeeds.
    // Deferred to the next frame so the navigator isn't called while locked
    // during a build/state-update cycle.
    ref.listen<BleConnectionStatus>(bleConnectionNotifierProvider,
        (prev, next) {
      if (next is BleConnected && prev is! BleConnected && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final nav = Navigator.of(context, rootNavigator: true);
          if (nav.canPop()) nav.pop();
        });
      }
    });

    final isConnecting = connState is BleConnecting;

    // Drive the rotation only while scanning
    if (scanState.isScanning) {
      if (!_rotateCtrl.isAnimating) _rotateCtrl.repeat();
    } else {
      _rotateCtrl.stop();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.88,
      expand: false,
      builder: (context, scrollController) {
        return _SheetShell(
          scrollController: scrollController,
          pulseAnim: _pulseAnim,
          rotateAnim: _rotateAnim,
          isScanning: scanState.isScanning,
          isConnecting: isConnecting,
          permResult: _permResult,
          checkingPerms: _checkingPerms,
          connectingDevice:
              connState is BleConnecting ? connState.device : null,
          devices: scanState.devices,
          onRetry: _checkAndScan,
          onScan: () => ref.read(bleScanNotifierProvider.notifier).startScan(),
          onStop: () => ref.read(bleScanNotifierProvider.notifier).stopScan(),
          onConnect: _connectToDevice,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sheet chrome
// ─────────────────────────────────────────────────────────────────────────────

class _SheetShell extends StatelessWidget {
  const _SheetShell({
    required this.scrollController,
    required this.pulseAnim,
    required this.rotateAnim,
    required this.isScanning,
    required this.isConnecting,
    required this.permResult,
    required this.checkingPerms,
    required this.connectingDevice,
    required this.devices,
    required this.onRetry,
    required this.onScan,
    required this.onStop,
    required this.onConnect,
  });

  final ScrollController scrollController;
  final Animation<double> pulseAnim;
  final Animation<double> rotateAnim;
  final bool isScanning;
  final bool isConnecting;
  final BlePermissionResult? permResult;
  final bool checkingPerms;
  final BleDevice? connectingDevice;
  final List<BleDevice> devices;
  final VoidCallback onRetry;
  final VoidCallback onScan;
  final VoidCallback onStop;
  final void Function(BleDevice) onConnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // ── Drag handle ────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // ── Header ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                RotationTransition(
                  turns: rotateAnim,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EEFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.bluetooth_searching,
                      color: Color(0xFF7B61FF),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connect Device',
                        style: TextStyle(
                          fontFamily: 'Punto',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        'Tap a device to pair with your Sori',
                        style: TextStyle(
                          fontFamily: 'Punto',
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
                // Scanning pulse dot
                if (isScanning)
                  FadeTransition(
                    opacity: pulseAnim,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7B61FF),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 4),

          // ── Body ───────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildBody(scrollController),
            ),
          ),

          // ── Footer scan button ─────────────────────
          if (!isConnecting) ...[
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            SafeArea(
              top: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: isScanning
                          ? const Color(0xFFFFEEEE)
                          : const Color(0xFF7B61FF),
                      foregroundColor: isScanning
                          ? const Color(0xFFE53935)
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: isScanning ? onStop : onScan,
                    icon: Icon(
                      isScanning
                          ? Icons.stop_rounded
                          : Icons.bluetooth_searching,
                      size: 18,
                    ),
                    label: Text(
                      isScanning ? 'Stop Scanning' : 'Scan for Devices',
                      style: const TextStyle(
                        fontFamily: 'Punto',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody(ScrollController scrollController) {
    if (checkingPerms) {
      return const _LoadingView(key: ValueKey('loading'));
    }

    if (permResult != null && permResult != BlePermissionResult.granted) {
      return _PermissionView(
        key: const ValueKey('perm'),
        result: permResult!,
        onRetry: onRetry,
      );
    }

    if (isConnecting && connectingDevice != null) {
      return _ConnectingView(
        key: ValueKey('connecting-${connectingDevice!.remoteId}'),
        device: connectingDevice!,
      );
    }

    if (devices.isEmpty) {
      return _EmptyView(
        key: const ValueKey('empty'),
        isScanning: isScanning,
      );
    }

    return ListView.separated(
      key: const ValueKey('list'),
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: devices.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 72, color: Color(0xFFF5F5F5)),
      itemBuilder: (context, i) => _SoriDeviceTile(
        device: devices[i],
        onTap: () => onConnect(devices[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Device tile
// ─────────────────────────────────────────────────────────────────────────────

class _SoriDeviceTile extends StatelessWidget {
  const _SoriDeviceTile({required this.device, required this.onTap});

  final BleDevice device;
  final VoidCallback onTap;

  Color _rssiColor(int rssi) {
    if (rssi >= BleConstants.rssiExcellent) return const Color(0xFF4CAF50);
    if (rssi >= BleConstants.rssiGood) return const Color(0xFFFF9800);
    if (rssi >= BleConstants.rssiFair) return const Color(0xFFFFC107);
    return const Color(0xFFF44336);
  }

  String _rssiLabel(int rssi) {
    if (rssi >= BleConstants.rssiExcellent) return 'Excellent';
    if (rssi >= BleConstants.rssiGood) return 'Good';
    if (rssi >= BleConstants.rssiFair) return 'Fair';
    return 'Weak';
  }

  @override
  Widget build(BuildContext context) {
    final rssiColor = _rssiColor(device.rssi);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Bluetooth icon badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.bluetooth, color: rssiColor, size: 22),
            ),
            const SizedBox(width: 14),

            // Name + ID
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name.isNotEmpty ? device.name : 'Unknown Device',
                    style: const TextStyle(
                      fontFamily: 'Punto',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    device.remoteId,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                ],
              ),
            ),

            // RSSI badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${device.rssi} dBm',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: rssiColor,
                  ),
                ),
                Text(
                  _rssiLabel(device.rssi),
                  style: TextStyle(fontSize: 10, color: rssiColor),
                ),
              ],
            ),

            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFE0E0E0), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Connecting view — pulsing spinner shown while BLE handshake is in progress
// ─────────────────────────────────────────────────────────────────────────────

class _ConnectingView extends StatefulWidget {
  const _ConnectingView({super.key, required this.device});

  final BleDevice device;

  @override
  State<_ConnectingView> createState() => _ConnectingViewState();
}

class _ConnectingViewState extends State<_ConnectingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scale,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EEFF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B61FF).withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bluetooth_connected,
                  color: Color(0xFF7B61FF),
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Connecting to',
              style: TextStyle(
                fontFamily: 'Punto',
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.device.name.isNotEmpty
                  ? widget.device.name
                  : widget.device.remoteId,
              style: const TextStyle(
                fontFamily: 'Punto',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF7B61FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty / scanning view
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyView extends StatefulWidget {
  const _EmptyView({super.key, required this.isScanning});

  final bool isScanning;

  @override
  State<_EmptyView> createState() => _EmptyViewState();
}

class _EmptyViewState extends State<_EmptyView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isScanning)
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, _) {
                return CustomPaint(
                  size: const Size(80, 80),
                  painter: _RadarPainter(progress: _ctrl.value),
                );
              },
            )
          else
            Icon(Icons.bluetooth_disabled,
                size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            widget.isScanning ? 'Searching for devices…' : 'No devices found',
            style: const TextStyle(
              fontFamily: 'Punto',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.isScanning
                ? 'Make sure your device is powered on'
                : 'Tap "Scan for Devices" to search',
            style: const TextStyle(
              fontFamily: 'Punto',
              fontSize: 12,
              color: Color(0xFFBDBDBD),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple radar ripple painter
class _RadarPainter extends CustomPainter {
  const _RadarPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final t = (progress + i / 3) % 1.0;
      final radius = maxR * t;
      final opacity = (1 - t) * 0.35;
      final paint = Paint()
        ..color = const Color(0xFF7B61FF).withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, radius, paint);
    }

    // Center bluetooth icon placeholder dot
    canvas.drawCircle(
      center,
      10,
      Paint()..color = const Color(0xFFF0EEFF),
    );
    canvas.drawCircle(
      center,
      10,
      Paint()
        ..color = const Color(0xFF7B61FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_RadarPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading + Permission views
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Color(0xFF7B61FF),
        ),
      ),
    );
  }
}

class _PermissionView extends StatelessWidget {
  const _PermissionView({super.key, required this.result, required this.onRetry});

  final BlePermissionResult result;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isOff = result == BlePermissionResult.bluetoothOff;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOff ? Icons.bluetooth_disabled : Icons.lock_outline,
            size: 52,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            isOff ? 'Bluetooth is Off' : 'Permission Required',
            style: const TextStyle(
              fontFamily: 'Punto',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isOff
                ? 'Turn on Bluetooth to discover devices.'
                : 'Allow Bluetooth access so Sori can find your device.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Punto',
              fontSize: 13,
              color: Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF7B61FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onRetry,
            child: const Text(
              'Try Again',
              style: TextStyle(fontFamily: 'Punto'),
            ),
          ),
        ],
      ),
    );
  }
}
