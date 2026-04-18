import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keychain_ble/app2/core/widgets/sori_dots_background.dart';
import 'package:keychain_ble/app2/features/dashboard/home/ble_device_dialog.dart';
import 'package:keychain_ble/core/extensions/size_extensions.dart';
import 'package:keychain_ble/features/ble/model/ble_connection_status.dart';
import 'package:keychain_ble/features/ble/provider/ble_connection_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
final bleState = ref.watch(bleConnectionNotifierProvider);
    final isConnected = bleState is BleConnected;

    ref.listen<BleConnectionStatus>(bleConnectionNotifierProvider, (
      prev,
      next,
    ) {
      if (next is BleConnected && prev is! BleConnected) {
        final deviceName = next.device.name.isNotEmpty
            ? next.device.name
            : 'Device';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(seconds: 3),
            content: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Connected',
                        style: TextStyle(
                          fontFamily: 'Punto',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        deviceName,
                        style: const TextStyle(
                          fontFamily: 'Punto',
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SoriDotsBackground(
        child: Stack(
          children: [
            // ── Avatar + beads + status ───────────────────────────────
            Positioned.fill(
              top: .3.sh,
              child: _AvatarScene(size: size, isConnected: isConnected),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar scene — staggered bead float-in (#3)
// ─────────────────────────────────────────────────────────────────────────────

class _AvatarScene extends ConsumerStatefulWidget {
  const _AvatarScene({required this.size, required this.isConnected});

  final Size size;
  final bool isConnected;

  @override
  ConsumerState<_AvatarScene> createState() => _AvatarSceneState();
}

class _AvatarSceneState extends ConsumerState<_AvatarScene>
    with TickerProviderStateMixin {
  late final AnimationController _staggerCtrl;

  // Drives the charm tail + head entrance/exit
  late final AnimationController _charmCtrl;
  // Tail springs in first (0 % → 65 % of the timeline)
  late final Animation<double> _tailAnim;
  // Head follows with a slight delay (30 % → 100 %)
  late final Animation<double> _headAnim;

  // Continuous breathing scale on the avatar
  late final AnimationController _breatheCtrl;
  late final Animation<double> _breatheAnim;

  static const _beadDefs = [
    (
      icon: 'assets/icons/light/heart_beads.svg',
      color: Color(0xFFEF9A9A),
      name: 'PINK',
      size: 58.0,
    ),
    (
      icon: 'assets/icons/light/plus_beads.svg',
      color: Color(0xFFCE93D8),
      name: 'PURPLE',
      size: 68.0,
    ),
    (
      icon: 'assets/icons/light/heart_beads.svg',
      color: Color(0xFF90CAF9),
      name: 'BLUE',
      size: 68.0,
    ),
    (
      icon: 'assets/icons/light/plus_beads.svg',
      color: Color(0xFFFFCC80),
      name: 'ORANGE',
      size: 68.0,
    ),
    (
      icon: 'assets/icons/light/star_beads.svg',
      color: Color(0xFFA5D6A7),
      name: 'GREEN',
      size: 68.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _charmCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _tailAnim = CurvedAnimation(
      parent: _charmCtrl,
      curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
    );
    _headAnim = CurvedAnimation(
      parent: _charmCtrl,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    );

    _breatheCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _breatheAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    _charmCtrl.dispose();
    _breatheCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch directly so this widget rebuilds the moment BLE state changes
    final isConnected =
        ref.watch(bleConnectionNotifierProvider) is BleConnected;

    // Drive charm entrance / exit
    ref.listen<BleConnectionStatus>(bleConnectionNotifierProvider,
        (prev, next) {
      if (next is BleConnected && prev is! BleConnected) {
        _charmCtrl.forward();
      } else if (next is! BleConnected && prev is BleConnected) {
        _charmCtrl.reverse();
      }
    });

    final avatarSize = widget.size.width * 0.65;
    final cx = widget.size.width / 2;
    final cy = avatarSize * 0.4 + avatarSize * 0.42;
    final radius = avatarSize * 0.58;

    const startDeg = -150.0;
    const endDeg = -30.0;
    final step = (endDeg - startDeg) / (_beadDefs.length - 1);

    final beads = List.generate(_beadDefs.length, (i) {
      final rad = (startDeg + i * step) * math.pi / 180;
      return _BeadData(
        iconPath: _beadDefs[i].icon,
        color: _beadDefs[i].color,
        colorName: _beadDefs[i].name,
        beadIndex: i,
        size: _beadDefs[i].size - 10,
        dx: cx + radius * math.cos(rad),
        dy: cy + radius * math.sin(rad),
      );
    });

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1 — Background dots
        Positioned(
          left: (widget.size.width - (avatarSize + 60)) / 2,
          top: avatarSize * 0.2,
          child: SvgPicture.asset(
            'assets/icons/light/avatar_bg_dots.svg',
            width: avatarSize + 60,
          ),
        ),

        // 2 — Avatar (tappable)
        Positioned(
          left: (widget.size.width - avatarSize + 20) / 2,
          top: avatarSize * 0.4,
          child: ScaleTransition(
            scale: _breatheAnim,
            child: GestureDetector(
              onTap: () => showBleDeviceDialog(context),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Image.asset(
                  'assets/images/light/center_avatar.png',
                  key: ValueKey(isConnected),
                  width: avatarSize - 20,
                ),
              ),
            ),
          ),
        ),

        // 3 — Beads with staggered slide-up + fade-in
        ...beads.map((b) {
          final i = b.beadIndex;
          // Each bead starts 12% later in the timeline, runs for 40%
          final start = (i * 0.12).clamp(0.0, 1.0);
          final end = (start + 0.4).clamp(0.0, 1.0);

          final curved = CurvedAnimation(
            parent: _staggerCtrl,
            curve: Interval(start, end, curve: Curves.easeOut),
          );
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(curved);
          final fade = Tween<double>(begin: 0.0, end: 1.0).animate(curved);

          return Positioned(
            left: b.dx - b.size / 2,
            top: b.dy - b.size,
            child: FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: slide,
                child: _BeadWidget(data: b),
              ),
            ),
          );
        }),

        // 4 — Charm tail — springs in first
        Positioned(
          right: 16,
          top: avatarSize * 0.6 + avatarSize * 0.72,
          child: FadeTransition(
            opacity: _tailAnim,
            child: ScaleTransition(
              scale: _tailAnim,
              child: Image.asset(
                'assets/images/light/charm_connected_tail.png',
                width: avatarSize * 0.30,
              ),
            ),
          ),
        ),

        // 4b — Charm head — follows tail with stagger
        Positioned(
          right: 50,
          top: avatarSize * 0.76 + avatarSize * 0.72,
          child: FadeTransition(
            opacity: _headAnim,
            child: ScaleTransition(
              scale: _headAnim,
              child: Image.asset(
                'assets/images/light/charm_connected_avatar.png',
                width: avatarSize * 0.30,
              ),
            ),
          ),
        ),

        // 5 — Status pill (#6 animated)
        Positioned(
          left: 0,
          right: 0,
          top: avatarSize * 0.4 + avatarSize * 0.9,
          child: Center(child: _StatusPill(isConnected: isConnected)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bead data
// ─────────────────────────────────────────────────────────────────────────────

class _BeadData {
  final String iconPath;
  final Color color;
  final String colorName;
  final int beadIndex;
  final double size;
  final double dx;
  final double dy;

  const _BeadData({
    required this.iconPath,
    required this.color,
    required this.colorName,
    required this.beadIndex,
    required this.size,
    required this.dx,
    required this.dy,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Bead widget — spring bounce on tap (#2)
// ─────────────────────────────────────────────────────────────────────────────

class _BeadWidget extends ConsumerStatefulWidget {
  const _BeadWidget({required this.data});

  final _BeadData data;

  @override
  ConsumerState<_BeadWidget> createState() => _BeadWidgetState();
}

class _BeadWidgetState extends ConsumerState<_BeadWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.82).animate(
      CurvedAnimation(
        parent: _scaleCtrl,
        curve: Curves.easeIn,
        reverseCurve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _scaleCtrl.forward();
  void _onTapUp(TapUpDetails _) => _scaleCtrl.reverse();
  void _onTapCancel() => _scaleCtrl.reverse();

  void _handleTap() {
    final connState = ref.read(bleConnectionNotifierProvider);
    if (connState is BleConnected) {
      final command = jsonEncode({
        'id': widget.data.beadIndex,
        'color': widget.data.colorName,
      });
      ref.read(bleConnectionNotifierProvider.notifier).sendCommand(command);
    } else {
      showBleDeviceDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: widget.data.size,
          height: widget.data.size,
          decoration: BoxDecoration(
            color: widget.data.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.data.color.withValues(alpha: 0.45),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: SvgPicture.asset(
            widget.data.iconPath,
            colorFilter: const ColorFilter.mode(
              Color(0xFF1A1A1A),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status pill — animated background + dot + text (#6)
// ─────────────────────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isConnected ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dot — color + size animate
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(
              begin: const Color(0xFFBDBDBD),
              end: isConnected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFBDBDBD),
            ),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (_, color, _) => AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
              width: isConnected ? 10 : 8,
              height: isConnected ? 10 : 8,
              decoration: BoxDecoration(
                color: color ?? const Color(0xFFBDBDBD),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Label — weight + color animate
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            style: TextStyle(
              fontFamily: 'Punto',
              fontSize: 13,
              fontWeight: isConnected ? FontWeight.w600 : FontWeight.w500,
              color: isConnected
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFF424242),
            ),
            child: Text(isConnected ? 'Connected' : 'Not Connected'),
          ),
        ],
      ),
    );
  }
}
