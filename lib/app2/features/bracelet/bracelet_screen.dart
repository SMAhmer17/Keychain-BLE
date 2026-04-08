import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class BraceletBead {
  final Color color;
  final String iconPath;
  final String title;
  final String artist;
  final String from;

  const BraceletBead({
    required this.color,
    required this.iconPath,
    required this.title,
    required this.artist,
    required this.from,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class BraceletScreen extends StatelessWidget {
  const BraceletScreen({super.key});

  static const _beads = [
    BraceletBead(
      color: Color(0xFF90CAF9),
      iconPath: 'assets/icons/light/heart_beads.svg',
      title: 'Blade Bird',
      artist: 'Oklou',
      from: 'From BrandtyMelvie',
    ),
    BraceletBead(
      color: Color(0xFFF48FB1),
      iconPath: 'assets/icons/light/heart_beads.svg',
      title: 'How to Pretend',
      artist: 'Lucy Bedroque',
      from: 'From MeepKa04',
    ),
    BraceletBead(
      color: Color(0xFFFFF176),
      iconPath: 'assets/icons/light/plus_beads.svg',
      title: 'Stateside',
      artist: 'PinkPantheress',
      from: 'From Skikori',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20, topPad + 24, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _ScreenHeader(),
                  const SizedBox(height: 24),
                  const _StatsSection(
                    braceletCount: 5,
                    charmsCount: 2,
                    totalBeads: 23,
                  ),
                  const SizedBox(height: 32),
                  _BeadList(beads: _beads),
                ]),
              ),
            ),
          ],
        ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen header
// ─────────────────────────────────────────────────────────────────────────────

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'my bracelet',
      style: TextStyle(
        fontFamily: 'Punto',
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: Color(0xFFCDB8E8),
        letterSpacing: 0.5,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats section
// ─────────────────────────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  const _StatsSection({
    required this.braceletCount,
    required this.charmsCount,
    required this.totalBeads,
  });

  final int braceletCount;
  final int charmsCount;
  final int totalBeads;

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.sizeOf(context).width - 40; // subtract horizontal padding

    return Column(
      children: [
        // Large card: centered, ~58% of available width
        Center(
          child: SizedBox(
            width: screenWidth * 0.5,
            child: _StatCard(
              label: 'my bracelet',
              value: braceletCount.toString(),
              isLarge: true,
            ),
          ),
        ),
        const SizedBox(height: 22),
        // Small cards: full width split equally
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'charms',
                value: charmsCount.toString(),
                isLarge: false,
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: _StatCard(
                label: 'total beads',
                value: totalBeads.toString(),
                isLarge: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat card
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.isLarge,
  });

  final String label;
  final String value;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: isLarge ? 24 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: const Color(0x40000000),
            // color: Colors.black38,
            blurRadius: 4.8,
            spreadRadius: -.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Punto',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF928CA2),
              // color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(
            color: Color.fromARGB(31, 0, 0, 0),
            // thickness: ,
            height: 1,
            indent: 30,
            endIndent: 30,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Punto',
              fontSize: 48,

              fontWeight: FontWeight.w700,
              color: const Color(0xFFB8A9D9),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bead list (timeline)
// ─────────────────────────────────────────────────────────────────────────────

class _BeadList extends StatelessWidget {
  const _BeadList({required this.beads});

  final List<BraceletBead> beads;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < beads.length; i++)
          _BeadListItem(bead: beads[i], isLast: i == beads.length - 1),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bead list item (with timeline connector)
// ─────────────────────────────────────────────────────────────────────────────

class _BeadListItem extends StatelessWidget {
  const _BeadListItem({required this.bead, required this.isLast});

  final BraceletBead bead;
  final bool isLast;

  static const double _beadSize = 60.0;
  static const double _itemHeight = 110.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _itemHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bead + connector line
          SizedBox(
            width: _beadSize,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Vertical line below bead
                if (!isLast)
                  Positioned(
                    top: _beadSize,
                    bottom: 0,
                    left: _beadSize / 2 - 1,
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            bead.color.withValues(alpha: 0.6),
                            bead.color.withValues(alpha: 0.15),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Bead circle
                _BeadCircle(bead: bead, size: _beadSize),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Text info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _BeadInfo(bead: bead),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bead circle
// ─────────────────────────────────────────────────────────────────────────────

class _BeadCircle extends StatelessWidget {
  const _BeadCircle({required this.bead, required this.size});

  final BraceletBead bead;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bead.color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: bead.color.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.22),
      child: SvgPicture.asset(
        bead.iconPath,
        colorFilter: const ColorFilter.mode(Color(0xFF2D2D2D), BlendMode.srcIn),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bead info text block
// ─────────────────────────────────────────────────────────────────────────────

class _BeadInfo extends StatelessWidget {
  const _BeadInfo({required this.bead});

  final BraceletBead bead;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bead.title,
          style: const TextStyle(
            fontFamily: 'Punto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          bead.artist,
          style: const TextStyle(
            fontFamily: 'Punto',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bead.from,
          style: const TextStyle(
            fontFamily: 'Punto',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFFBDBAC7),
          ),
        ),
      ],
    );
  }
}
