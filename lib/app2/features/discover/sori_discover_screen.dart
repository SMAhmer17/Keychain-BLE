import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keychain_ble/app2/core/widgets/sori_dots_background.dart';

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

  // Positions form an oval ring (cx≈0.43, cy≈0.46).
  // leftFrac × screenWidth  = horizontal pixel centre.
  // topFrac  × screenHeight = vertical pixel centre.
  // Aspect-ratio correction (≈390×780) keeps the ring visually circular.
  static const _beads = [
    // ── Outer ring — 5 large beads ───────────────────────────────
    _BeadConfig(
      color: Color(0xFFCE93D8), // purple  — 10 o'clock
      iconPath: 'assets/icons/light/star_beads.svg',
      size: 110,
      leftFrac: 0.28,
      topFrac: 0.18,
    ),
    _BeadConfig(
      color: Color(0xFFA5D6A7), // green   — 9 o'clock
      iconPath: 'assets/icons/light/star_beads.svg',
      size: 130,
      leftFrac: 0.09,
      topFrac: 0.38,
    ),
    _BeadConfig(
      color: Color(0xFFFFF176), // yellow  — 7 o'clock
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 130,
      leftFrac: 0.14,
      topFrac: 0.58,
    ),
    _BeadConfig(
      color: Color(0xFF90CAF9), // blue    — 3 o'clock
      iconPath: 'assets/icons/light/heart_beads.svg',
      size: 140,
      leftFrac: 0.70,
      topFrac: 0.53,
    ),
    _BeadConfig(
      color: Color(0xFFF48FB1), // pink    — 5 o'clock
      iconPath: 'assets/icons/light/heart_beads.svg',
      size: 120,
      leftFrac: 0.38,
      topFrac: 0.70,
    ),

    // ── Middle ring — 3 medium beads filling the upper arc ────────
    _BeadConfig(
      color: Color(0xFF80DEEA), // teal    — 12 o'clock
      iconPath: 'assets/icons/light/heart_beads.svg',
      size: 80,
      leftFrac: 0.52,
      topFrac: 0.11,
    ),
    _BeadConfig(
      color: Color(0xFFFFF59D), // light yellow — 1 o'clock
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 62,
      leftFrac: 0.63,
      topFrac: 0.22,
    ),
    _BeadConfig(
      color: Color(0xFFB39DDB), // lavender — 2 o'clock
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 50,
      leftFrac: 0.82,
      topFrac: 0.38,
    ),

    // ── Inner cluster — 5 small beads scattered at the centre ─────
    _BeadConfig(
      color: Color(0xFFCE93D8), // purple
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 30,
      leftFrac: 0.34,
      topFrac: 0.33,
    ),
    _BeadConfig(
      color: Color(0xFF80DEEA), // teal
      iconPath: 'assets/icons/light/heart_beads.svg',
      size: 38,
      leftFrac: 0.44,
      topFrac: 0.41,
    ),
    _BeadConfig(
      color: Color(0xFFFFCC80), // orange
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 32,
      leftFrac: 0.54,
      topFrac: 0.36,
    ),
    _BeadConfig(
      color: Color(0xFFC5E1A5), // green
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 28,
      leftFrac: 0.47,
      topFrac: 0.49,
    ),
    _BeadConfig(
      color: Color(0xFFB39DDB), // lavender
      iconPath: 'assets/icons/light/plus_beads.svg',
      size: 24,
      leftFrac: 0.60,
      topFrac: 0.44,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SoriDotsBackground(
        child: Stack(
          children: [
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
