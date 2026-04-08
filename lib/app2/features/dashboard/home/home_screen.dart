import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keychain_ble/core/extensions/size_extensions.dart';
import 'package:keychain_ble/features/ble/model/ble_connection_status.dart';
import 'package:keychain_ble/features/ble/provider/ble_connection_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final topPad = MediaQuery.paddingOf(context).top;
    final bleState = ref.watch(bleConnectionNotifierProvider);
    final isConnected = bleState is BleConnected;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Background dot patterns ──────────────────────────────
          Positioned(
            top: .15.sh,
            right: 0,
            child: SvgPicture.asset(
              'assets/icons/light/center_dots.svg',
              width: 250,
              height: 217,
            ),
          ),
          // Positioned(
          //   top: size.height * 0.3,
          //   left: size.width * 0.05,
          //   right: size.width * 0.05,
          //   child: SvgPicture.asset(
          //     'assets/icons/light/center_circle_dots.svg',
          //     width: size.width * 0.9,
          //   ),
          // ),
          Positioned(
            bottom: .15.sh,
            left: 0,
            child: SvgPicture.asset(
              'assets/icons/light/bottom_left_dots.svg',
              width: 185,
              height: 139,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/icons/light/bottom_right_dots.svg',
              width: 155,
              height: 132,
            ),
          ),

          // ── App name ─────────────────────────────────────────────
          Positioned(
            top: topPad + 20,
            left: 24,
            child: SvgPicture.asset(
              'assets/icons/light/app_name.svg',
              height: 38,
            ),
          ),

          // ── Avatar + beads + status ───────────────────────────────
          Positioned.fill(
            top: .3.sh,
            child: _AvatarScene(size: size, isConnected: isConnected),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar scene
// ─────────────────────────────────────────────────────────────────────────────

class _AvatarScene extends StatelessWidget {
  const _AvatarScene({required this.size, required this.isConnected});

  final Size size;
  final bool isConnected;

  // 5 beads evenly spaced in a semicircle from -150° to -30° (above avatar)
  static const _beadDefs = [
    (
      icon: 'assets/icons/light/heart_beads.svg',
      color: Color(0xFFEF9A9A),
      name: 'Pink',
      size: 58.0,
    ),
    (
      icon: 'assets/icons/light/plus_beads.svg',
      color: Color(0xFFCE93D8),
      name: 'Purple',
      size: 68.0,
    ),
    (
      icon: 'assets/icons/light/heart_beads.svg',
      color: Color(0xFF90CAF9),
      name: 'Blue',
      size: 68.0,
    ),
    (
      icon: 'assets/icons/light/plus_beads.svg',
      color: Color(0xFFFFCC80),
      name: 'Orange',
      size: 68.0,
    ),
    (
      icon: 'assets/icons/light/star_beads.svg',
      color: Color(0xFFA5D6A7),
      name: 'Green',
      size: 68.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final avatarSize = size.width * 0.65;

    // Avatar visual center within this scene
    final cx = size.width / 2;
    final cy =
        avatarSize * 0.4 +
        avatarSize * 0.42; // avatar top + ~half avatar height

    // Arc radius — sits beads on the edge of the bg dot circle
    final radius = avatarSize * 0.58;

    // Evenly spread 5 beads from -150° to -30° (in radians)
    const startDeg = -150.0;
    const endDeg = -30.0;
    final step = (endDeg - startDeg) / (_beadDefs.length - 1);

    final beads = List.generate(_beadDefs.length, (i) {
      final rad = (startDeg + i * step) * math.pi / 180;
      return _BeadData(
        iconPath: _beadDefs[i].icon,
        color: _beadDefs[i].color,
        colorName: _beadDefs[i].name,
        size: _beadDefs[i].size - 10,
        dx: cx + radius * math.cos(rad),
        dy: cy + radius * math.sin(rad),
      );
    });

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1 — Avatar background dots (bottom-most)
        Positioned(
          left: (size.width - (avatarSize + 60)) / 2,
          top: avatarSize * 0.2,
          child: SvgPicture.asset(
            'assets/icons/light/avatar_bg_dots.svg',
            width: avatarSize + 60,
          ),
        ),

        // 2 — Avatar image
        Positioned(
          left: (size.width - avatarSize + 20) / 2,
          top: avatarSize * 0.4,
          child: Image.asset(
            'assets/images/light/center_avatar.png',
            width: avatarSize - 20,
          ),
        ),

        // 3 — Beads on top of everything
        ...beads.map(
          (b) => Positioned(
            left: b.dx - b.size / 2,
            top: b.dy - b.size / 1,
            child: _BeadWidget(data: b),
          ),
        ),

        // 4 — Status pill
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
// Bead
// ─────────────────────────────────────────────────────────────────────────────

class _BeadData {
  final String iconPath;
  final Color color;
  final String colorName;
  final double size;
  final double dx;
  final double dy;

  const _BeadData({
    required this.iconPath,
    required this.color,
    required this.colorName,
    required this.size,
    required this.dx,
    required this.dy,
  });
}

class _BeadWidget extends StatelessWidget {
  const _BeadWidget({required this.data});

  final _BeadData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => debugPrint('[Bead tapped] ${data.colorName}'),
      child: Container(
        width: data.size,
        height: data.size,
        decoration: BoxDecoration(
          color: data.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: data.color.withValues(alpha: 0.45),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: SvgPicture.asset(
          data.iconPath,
          colorFilter: const ColorFilter.mode(
            Color(0xFF1A1A1A),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status pill
// ─────────────────────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
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
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isConnected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFBDBDBD),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isConnected ? 'Connected' : 'Not Connected',
            style: const TextStyle(
              fontFamily: 'Punto',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }
}
