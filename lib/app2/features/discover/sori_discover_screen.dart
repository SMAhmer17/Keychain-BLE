import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Bead config — positions as fractions of available width/height
// ─────────────────────────────────────────────────────────────────────────────

class _BeadConfig {
  final Color color;
  final String iconPath;
  final double size;

  /// Fraction of available width (0.0 – 1.0), anchors to bead center
  final double leftFrac;

  /// Fraction of available height (0.0 – 1.0), anchors to bead center
  final double topFrac;

  const _BeadConfig({
    required this.color,
    required this.iconPath,
    required this.size,
    required this.leftFrac,
    required this.topFrac,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class SoriDiscoverScreen extends StatelessWidget {
  const SoriDiscoverScreen({super.key});

  static const _beads = [
    // ── Large beads ──────────────────────────────────────────────
    _BeadConfig(
      color: Color(0xFFCE93D8), // purple
      iconPath: 'assets/icons/light/star_beads.svg',
      size: 110,
      leftFrac: 0.30,
      topFrac: 0.34,
    ),
    _BeadConfig(
      color: Color(0xFFA5D6A7), // green
      iconPath: 'assets/icons/light/star_beads.svg',
      size: 130,
      leftFrac: 0.06,
      topFrac: 0.49,
    ),
    _BeadConfig(
      color: Color(0xFFFFF176), // yellow
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 130,
      leftFrac: 0.17,
      topFrac: 0.64,
    ),
    _BeadConfig(
      color: Color(0xFF90CAF9), // blue
      iconPath: 'assets/icons/light/heart_beads.svg',
      size: 140,
      leftFrac: 0.72,
      topFrac: 0.62,
    ),
    _BeadConfig(
      color: Color(0xFFF48FB1), // pink
      iconPath: 'assets/icons/light/heart_beads.svg',
      size: 120,
      leftFrac: 0.40,
      topFrac: 0.74,
    ),

    // ── Medium beads ─────────────────────────────────────────────
    _BeadConfig(
      color: Color(0xFF80DEEA), // teal
      iconPath: 'assets/icons/light/heart_beads.svg',
      size: 80,
      leftFrac: 0.62,
      topFrac: 0.39,
    ),
    _BeadConfig(
      color: Color(0xFFFFF59D), // light yellow
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 72,
      leftFrac: 0.83,
      topFrac: 0.47,
    ),
    _BeadConfig(
      color: Color(0xFFB39DDB), // lavender
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 60,
      leftFrac: 0.84,
      topFrac: 0.58,
    ),

    // ── Small beads ──────────────────────────────────────────────
    _BeadConfig(
      color: Color(0xFF80DEEA), // tiny teal
      iconPath: 'assets/icons/light/heart_beads.svg',
      size: 38,
      leftFrac: 0.62,
      topFrac: 0.54,
    ),
    _BeadConfig(
      color: Color(0xFFFFCC80), // tiny orange
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 30,
      leftFrac: 0.57,
      topFrac: 0.52,
    ),
    _BeadConfig(
      color: Color(0xFFC5E1A5), // tiny green
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 32,
      leftFrac: 0.64,
      topFrac: 0.63,
    ),
    _BeadConfig(
      color: Color(0xFFCE93D8), // tiny purple
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 28,
      leftFrac: 0.56,
      topFrac: 0.59,
    ),
    _BeadConfig(
      color: Color(0xFFB39DDB), // tiny lavender
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 24,
      leftFrac: 0.53,
      topFrac: 0.65,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Background dot patterns ──────────────────────────────
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/icons/light/center_dots.svg',
              width: size.width * 0.65,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              'assets/icons/light/bottom_left_dots.svg',
              width: size.width * 0.45,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/icons/light/bottom_right_dots.svg',
              width: size.width * 0.45,
            ),
          ),

          // ── Scattered beads ──────────────────────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              return Stack(
                children: _beads.map((b) {
                  final left = w * b.leftFrac - b.size / 2;
                  final top = h * b.topFrac - b.size / 2;
                  return Positioned(
                    left: left,
                    top: top,
                    child: _BeadWidget(config: b),
                  );
                }).toList(),
              );
            },
          ),

          // ── Header ───────────────────────────────────────────────
          Positioned(
            top: topPad + 12,
            left: 24,
            right: 24,
            child: const _PlaylistHeader(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _PlaylistHeader extends StatelessWidget {
  const _PlaylistHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Playlist',
          style: TextStyle(
            fontFamily: 'Punto',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFFCDB8E8),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(
            3,
            (_) => Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFD4C5EC),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bead widget
// ─────────────────────────────────────────────────────────────────────────────

class _BeadWidget extends StatelessWidget {
  const _BeadWidget({required this.config});

  final _BeadConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        color: config.color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: config.color.withValues(alpha: 0.45),
            blurRadius: config.size * 0.18,
            offset: Offset(0, config.size * 0.06),
          ),
        ],
      ),
      padding: EdgeInsets.all(config.size * 0.22),
      child: SvgPicture.asset(
        config.iconPath,
        colorFilter: const ColorFilter.mode(
          Color(0xFF2D2D2D),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
