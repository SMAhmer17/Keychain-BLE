import 'dart:math' as math;
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

  void _openBead(BuildContext context, BraceletBead bead) {
    Navigator.of(context).push(_BeadDetailRoute(bead: bead));
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(24, topPad + 20, 24, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _ScreenHeader(),
                const SizedBox(height: 30),
                const _StatsSection(orisToday: 2, totalOris: 10),
                const SizedBox(height: 50),
                _BeadList(
                  beads: _beads,
                  onBeadTap: (bead) => _openBead(context, bead),
                ),
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
        fontSize: 26,
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
  const _StatsSection({required this.orisToday, required this.totalOris});

  final int orisToday;
  final int totalOris;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _StatCard(
              label: 'oris collected\ntoday',
              value: orisToday.toString(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(label: 'total oris', value: totalOris.toString()),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat card
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
          BoxShadow(color: Color(0x06000000), blurRadius: 4, spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Punto',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF928CA2),
              letterSpacing: 0.2,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 18),
            color: Colors.black38.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              // fontFamily: 'Punto',
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB8A9D9),
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
  const _BeadList({required this.beads, required this.onBeadTap});

  final List<BraceletBead> beads;
  final void Function(BraceletBead) onBeadTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < beads.length; i++)
          _BeadListItem(
            bead: beads[i],
            isFirst: i == 0,
            onTap: () => onBeadTap(beads[i]),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bead list item (with timeline connector)
// ─────────────────────────────────────────────────────────────────────────────

class _BeadListItem extends StatelessWidget {
  const _BeadListItem({
    required this.bead,
    required this.isFirst,
    required this.onTap,
  });

  final BraceletBead bead;
  final bool isFirst;
  final VoidCallback onTap;

  static const double _beadSize = 58.0;
  static const double _itemHeight = 100.0;

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
                // Line runs full height; starts at bead centre for first item
                // so nothing appears above the first bead.
                Positioned(
                  top: isFirst ? _beadSize / 2 : 0,
                  bottom: 0,
                  left: _beadSize / 2 - 1,
                  child: Container(
                    width: 2,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFE1E1), Color(0xFFBAF2FF)],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: _BeadCircle(bead: bead, size: _beadSize),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5A5A6E),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          bead.artist,
          style: const TextStyle(
            fontFamily: 'Punto',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9E9AB0),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bead.from,
          style: const TextStyle(
            fontFamily: 'Punto',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Color(0xFFBDBAC7),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Spiral route transition
// ─────────────────────────────────────────────────────────────────────────────

class _BeadDetailRoute extends PageRouteBuilder<void> {
  _BeadDetailRoute({required BraceletBead bead})
    : super(
        pageBuilder: (_, _, _) => _BeadDetailPage(bead: bead),
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          // Scale up from zero + rotate half a turn → gives the spiral-in feel
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: curved,
              child: RotationTransition(
                turns: Tween<double>(begin: 0.5, end: 0.0).animate(curved),
                child: child,
              ),
            ),
          );
        },
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Bead detail page
// ─────────────────────────────────────────────────────────────────────────────

class _BeadDetailPage extends StatefulWidget {
  const _BeadDetailPage({required this.bead});

  final BraceletBead bead;

  @override
  State<_BeadDetailPage> createState() => _BeadDetailPageState();
}

class _BeadDetailPageState extends State<_BeadDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _contentCtrl;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _contentFade = CurvedAnimation(
      parent: _contentCtrl,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentCtrl,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );
    _contentCtrl.forward();
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bead = widget.bead;
    final size = MediaQuery.sizeOf(context);
    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final orbSize = size.width * 0.58;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Soft colour wash behind the orb ───────────────────────────
          Positioned(
            top: -orbSize * 0.3,
            left: size.width / 2 - orbSize * 0.8,
            child: Container(
              width: orbSize * 1.6,
              height: orbSize * 1.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    bead.color.withValues(alpha: 0.35),
                    bead.color.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // ── Main content ──────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: topPad + 24),

              // Back button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: bead.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: bead.color
                            .withValues(alpha: 1)
                            .withBlue((bead.color.b * 0.6).round()),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Orb ───────────────────────────────────────────────────
              _SpinningOrb(bead: bead, size: orbSize),

              const SizedBox(height: 36),

              // ── Info card ─────────────────────────────────────────────
              FadeTransition(
                opacity: _contentFade,
                child: SlideTransition(
                  position: _contentSlide,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _DetailCard(bead: bead),
                  ),
                ),
              ),

              const Spacer(),

              // ── Bottom pill ───────────────────────────────────────────
              FadeTransition(
                opacity: _contentFade,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: bottomPad + 16,
                  ),
                  child: _BottomPill(bead: bead),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Slowly rotating orb on the detail page
// ─────────────────────────────────────────────────────────────────────────────

class _SpinningOrb extends StatefulWidget {
  const _SpinningOrb({required this.bead, required this.size});

  final BraceletBead bead;
  final double size;

  @override
  State<_SpinningOrb> createState() => _SpinningOrbState();
}

class _SpinningOrbState extends State<_SpinningOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bead = widget.bead;
    final size = widget.size;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) =>
          Transform.rotate(angle: _ctrl.value * 2 * math.pi, child: child),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bead.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bead.color.withValues(alpha: 0.5),
              blurRadius: 40,
              spreadRadius: 4,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: EdgeInsets.all(size * 0.22),
        child: SvgPicture.asset(
          bead.iconPath,
          colorFilter: const ColorFilter.mode(
            Color(0xFF2D2D2D),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail info card
// ─────────────────────────────────────────────────────────────────────────────

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.bead});

  final BraceletBead bead;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: bead.color.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          const BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: bead.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                bead.title,
                style: const TextStyle(
                  fontFamily: 'Punto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            bead.artist,
            style: const TextStyle(
              fontFamily: 'Punto',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF0F0F0), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                size: 14,
                color: Color(0xFFCDB8E8),
              ),
              const SizedBox(width: 6),
              Text(
                bead.from,
                style: const TextStyle(
                  fontFamily: 'Punto',
                  fontSize: 13,
                  color: Color(0xFFBDBAC7),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom action pill
// ─────────────────────────────────────────────────────────────────────────────

class _BottomPill extends StatelessWidget {
  const _BottomPill({required this.bead});

  final BraceletBead bead;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: bead.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: bead.color.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bolt_rounded, color: bead.color, size: 20),
          const SizedBox(width: 8),
          Text(
            'Infuse to Bracelet',
            style: TextStyle(
              fontFamily: 'Punto',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: bead.color
                  .withBlue((bead.color.b * 0.5).round())
                  .withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
