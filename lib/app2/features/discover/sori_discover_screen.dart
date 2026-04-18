import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keychain_ble/app2/core/widgets/sori_dots_background.dart';
import 'package:keychain_ble/features/ble/model/ble_connection_status.dart';
import 'package:keychain_ble/features/ble/provider/ble_connection_notifier.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sort options
// ─────────────────────────────────────────────────────────────────────────────

enum _SortOption { defaultOrder, byColor, shuffle }

// ─────────────────────────────────────────────────────────────────────────────
// Spiral bead visuals — module-level so sort can reorder them
// ─────────────────────────────────────────────────────────────────────────────

const _kLoopBeads = [
  (color: Color(0xFFCE93D8), icon: 'assets/icons/light/star_beads.svg'),
  (color: Color(0xFF80DEEA), icon: 'assets/icons/light/heart_beads.svg'),
  (color: Color(0xFFA5D6A7), icon: 'assets/icons/light/star_beads.svg'),
  (color: Color(0xFFFFF176), icon: 'assets/icons/light/plus_beads.svg'),
  (color: Color(0xFFFFCC80), icon: 'assets/icons/light/plus_beads.svg'),
  (color: Color(0xFFF48FB1), icon: 'assets/icons/light/heart_beads.svg'),
  (color: Color(0xFF90CAF9), icon: 'assets/icons/light/heart_beads.svg'),
  (color: Color(0xFFEF9A9A), icon: 'assets/icons/light/heart_beads.svg'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Named bead definitions — shared by orbit view and carousel
// ─────────────────────────────────────────────────────────────────────────────

class _BeadDef {
  final int id;
  final Color color;
  final String colorName;
  final String iconPath;

  const _BeadDef({
    required this.id,
    required this.color,
    required this.colorName,
    required this.iconPath,
  });
}

const _kBeads = [
  _BeadDef(
    id: 0,
    color: Color(0xFFEF9A9A),
    colorName: 'PINK',
    iconPath: 'assets/icons/light/heart_beads.svg',
  ),
  _BeadDef(
    id: 1,
    color: Color(0xFFCE93D8),
    colorName: 'PURPLE',
    iconPath: 'assets/icons/light/plus_beads.svg',
  ),
  _BeadDef(
    id: 2,
    color: Color(0xFF90CAF9),
    colorName: 'BLUE',
    iconPath: 'assets/icons/light/heart_beads.svg',
  ),
  _BeadDef(
    id: 3,
    color: Color(0xFFFFCC80),
    colorName: 'ORANGE',
    iconPath: 'assets/icons/light/plus_beads.svg',
  ),
  _BeadDef(
    id: 4,
    color: Color(0xFFA5D6A7),
    colorName: 'GREEN',
    iconPath: 'assets/icons/light/star_beads.svg',
  ),
];


// ─────────────────────────────────────────────────────────────────────────────
// Screen root
// ─────────────────────────────────────────────────────────────────────────────

class SoriDiscoverScreen extends ConsumerStatefulWidget {
  const SoriDiscoverScreen({super.key});

  @override
  ConsumerState<SoriDiscoverScreen> createState() =>
      _SoriDiscoverScreenState();
}

class _SoriDiscoverScreenState extends ConsumerState<SoriDiscoverScreen>
    with TickerProviderStateMixin {
  // Drives continuous orbital motion (0 → 1, repeating)
  late final AnimationController _orbitCtrl;

  // Drives the fade between orbit view and carousel view
  late final AnimationController _modeCtrl;

  // Snaps the spiral to the nearest bead after a swipe ends
  late final AnimationController _snapCtrl;
  double _swipeOffset = 0.0;
  double _snapFrom = 0.0;
  double _snapTo = 0.0;
  int _pendingCarouselIndex = 0;

  bool _carouselMode = false;
  late final PageController _pageCtrl;
  int _currentPage = 0;

  _SortOption _sortOption = _SortOption.defaultOrder;
  List<({Color color, String icon})> _shuffledBeads =
      List.from(_kLoopBeads);

  List<({Color color, String icon})> get _displayBeads {
    switch (_sortOption) {
      case _SortOption.defaultOrder:
        return _kLoopBeads;
      case _SortOption.byColor:
        return List.from(_kLoopBeads)
          ..sort((a, b) =>
              HSVColor.fromColor(a.color).hue
                  .compareTo(HSVColor.fromColor(b.color).hue));
      case _SortOption.shuffle:
        return _shuffledBeads;
    }
  }

  void _onSortSelected(_SortOption option) {
    setState(() {
      _sortOption = option;
      if (option == _SortOption.shuffle) {
        _shuffledBeads = List.from(_kLoopBeads)..shuffle();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _modeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _snapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..addListener(_onSnapTick);

    _pageCtrl = PageController(viewportFraction: 0.72);
    _pageCtrl.addListener(() {
      final p = _pageCtrl.page?.round() ?? 0;
      if (p != _currentPage) setState(() => _currentPage = p);
    });
  }

  @override
  void dispose() {
    _orbitCtrl.dispose();
    _modeCtrl.dispose();
    _snapCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _onSnapTick() {
    final v = Curves.easeOutCubic.transform(_snapCtrl.value);
    setState(() => _swipeOffset = _snapFrom + (_snapTo - _snapFrom) * v);
  }

  void _onSpiralDragUpdate(DragUpdateDetails d) {
    // ~320 px drag = full phase cycle (8 beads pass the front)
    setState(() => _swipeOffset -= d.delta.dx / 320.0);
  }

  void _onSpiralDragEnd(DragEndDetails _) {
    const frontPhase = 0.88;
    const count = 8;
    final t = _orbitCtrl.value;

    double bestDiff = double.infinity;
    int bestIndex = 0;
    double bestOffset = _swipeOffset;

    for (int i = 0; i < count; i++) {
      final phase = ((i / count) + t + _swipeOffset) % 1.0;
      var diff = (phase - frontPhase).abs();
      if (diff > 0.5) diff = 1.0 - diff;
      if (diff < bestDiff) {
        bestDiff = diff;
        bestIndex = i;
        var delta = frontPhase - phase;
        if (delta > 0.5) delta -= 1.0;
        if (delta < -0.5) delta += 1.0;
        bestOffset = _swipeOffset + delta;
      }
    }

    _snapFrom = _swipeOffset;
    _snapTo = bestOffset;
    _pendingCarouselIndex = bestIndex % _kBeads.length;
    _snapCtrl.forward(from: 0).then((_) {
      if (mounted) _enterCarousel(_pendingCarouselIndex);
    });
  }

  void _enterCarousel(int index) {
    setState(() {
      _carouselMode = true;
      _currentPage = index;
    });
    _modeCtrl.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageCtrl.hasClients) _pageCtrl.jumpToPage(index);
    });
  }

  void _exitCarousel() {
    _modeCtrl.reverse().then((_) {
      if (mounted) setState(() => _carouselMode = false);
    });
  }

  void _sendInfuse(_BeadDef bead) {
    final state = ref.read(bleConnectionNotifierProvider);
    if (state is BleConnected) {
      final cmd = 'INFUSE:ORB${bead.id}:COLOR:${bead.colorName}';
      ref.read(bleConnectionNotifierProvider.notifier).sendCommand(cmd);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    final isConnected =
        ref.watch(bleConnectionNotifierProvider) is BleConnected;

    final orbitFade = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _modeCtrl, curve: Curves.easeIn));
    final carouselFade = CurvedAnimation(
      parent: _modeCtrl,
      curve: Curves.easeOut,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SoriDotsBackground(
        child: Stack(
          children: [
            // ── Orbit view ──────────────────────────────────────────────
            GestureDetector(
              onHorizontalDragUpdate:
                  _carouselMode ? null : _onSpiralDragUpdate,
              onHorizontalDragEnd: _carouselMode ? null : _onSpiralDragEnd,
              child: FadeTransition(
                opacity: orbitFade,
                child: IgnorePointer(
                  ignoring: _carouselMode,
                  child: _LoopView(
                    orbitCtrl: _orbitCtrl,
                    swipeOffset: _swipeOffset,
                    beads: _displayBeads,
                    onBeadTap: _enterCarousel,
                  ),
                ),
              ),
            ),

            // ── Carousel view ───────────────────────────────────────────
            if (_carouselMode)
              FadeTransition(
                opacity: carouselFade,
                child: _CarouselView(
                  pageCtrl: _pageCtrl,
                  currentPage: _currentPage,
                  isConnected: isConnected,
                  onBack: _exitCarousel,
                  onInfuse: _sendInfuse,
                ),
              ),

            // ── Header ──────────────────────────────────────────────────
            Positioned(
              top: topPad + 20,
              left: 24,
              child: _Header(
                carouselMode: _carouselMode,
                onBack: _exitCarousel,
                sortOption: _sortOption,
                onSortSelected: _onSortSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Spiral coil loop view
// 8 beads travel along an Archimedean spiral projected onto a tilted plane.
// Each bead advances outward (inner→outer) and wraps back to centre, giving a
// continuous coil-flowing effect.  Depth = spiral phase → bigger + more opaque
// at the outer/front end, tiny + faint near the centre.
// ─────────────────────────────────────────────────────────────────────────────

class _LoopView extends StatelessWidget {
  const _LoopView({
    required this.orbitCtrl,
    required this.swipeOffset,
    required this.beads,
    required this.onBeadTap,
  });

  final AnimationController orbitCtrl;
  final double swipeOffset;
  final List<({Color color, String icon})> beads;
  final void Function(int index) onBeadTap;

  // Spiral makes this many full turns from centre to outer edge
  static const _turns = 2.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final cx = w / 2;
        final cy = h * 0.50;

        final rMin = w * 0.04;

        const count = 8;
        const baseSize = 112.0;

        return AnimatedBuilder(
          animation: orbitCtrl,
          builder: (_, _) {
            final t = orbitCtrl.value;

            // Breathing: rMax pulses slowly (one breath every ~20 s)
            final breath = math.sin(t * 2 * math.pi * 1.5);
            final rMax = w * (0.38 + 0.03 * breath);

            // Tilt wobble: coil rocks gently in perspective (~43 s cycle)
            final tilt = 0.44 + 0.07 * math.sin(t * 2 * math.pi * 0.7);

            // Each bead sits at an evenly spaced slot on the spiral.
            // As t increases the whole coil rotates, advancing every bead
            // outward.  Phase wraps 0→1 continuously.
            final items = List.generate(count, (i) {
              final phase = ((i / count) + t + swipeOffset) % 1.0; // 0..1 along spiral

              // Ease phase for radius: quadratic — beads accelerate outward
              final easedPhase = phase * phase;

              // Angular position: spiral sweeps _turns full circles
              final angle = phase * _turns * 2 * math.pi;

              // Radius grows with eased phase (clusters near centre, spreads out)
              final r = rMin + (rMax - rMin) * easedPhase;

              // Project onto tilted plane: compress y for perspective depth
              final x = cx + r * math.cos(angle);
              final y = cy + r * math.sin(angle) * tilt;

              // Front = outer (phase ≈ 1): larger, fully opaque.
              // Fade in/out at both ends so the wrap-around is invisible.
              final scale = 0.28 + phase * 0.72; // 0.28 → 1.0
              const fadeIn = 0.15;
              const fadeOut = 0.85;
              final fadeFactor = phase < fadeIn
                  ? phase / fadeIn
                  : phase > fadeOut
                      ? (1.0 - phase) / (1.0 - fadeOut)
                      : 1.0;
              final opacity = (0.35 + phase * 0.65) * fadeFactor;

              return (index: i, x: x, y: y, scale: scale, opacity: opacity);
            });

            // Paint back (small) → front (large) for correct z-order
            final sorted = [...items]..sort((a, b) => a.scale.compareTo(b.scale));

            return Stack(
              children: sorted.map((item) {
                final bead = beads[item.index];
                final size = baseSize * item.scale;
                return Positioned(
                  left: item.x - size / 2,
                  top: item.y - size / 2,
                  child: GestureDetector(
                    onTap: () => onBeadTap(item.index % _kBeads.length),
                    child: Opacity(
                      opacity: item.opacity,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: bead.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: bead.color
                                  .withValues(alpha: 0.4 * item.scale),
                              blurRadius: size * 0.22,
                              offset: Offset(0, size * 0.08),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(size * 0.22),
                        child: SvgPicture.asset(
                          bead.icon,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF2D2D2D),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carousel view
// ─────────────────────────────────────────────────────────────────────────────

class _CarouselView extends StatelessWidget {
  const _CarouselView({
    required this.pageCtrl,
    required this.currentPage,
    required this.isConnected,
    required this.onBack,
    required this.onInfuse,
  });

  final PageController pageCtrl;
  final int currentPage;
  final bool isConnected;
  final VoidCallback onBack;
  final void Function(_BeadDef bead) onInfuse;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Column(
      children: [
        SizedBox(height: topPad + 56),

        // ── Page view ──────────────────────────────────────────────────
        SizedBox(
          height: size.width * 0.65,
          child: PageView.builder(
            controller: pageCtrl,
            itemCount: _kBeads.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: pageCtrl,
                builder: (_, _) {
                  double page = 0;
                  if (pageCtrl.hasClients && pageCtrl.position.haveDimensions) {
                    page = pageCtrl.page ?? index.toDouble();
                  } else {
                    page = index.toDouble();
                  }
                  final distance = (page - index).abs();
                  final scale = (1 - distance * 0.18).clamp(0.7, 1.0);
                  final opacity = (1 - distance * 0.45).clamp(0.3, 1.0);

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: _CarouselBead(bead: _kBeads[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // ── Data packet card ───────────────────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: _DataPacketCard(
            key: ValueKey(currentPage),
            bead: _kBeads[currentPage],
            isConnected: isConnected,
            onInfuse: () => onInfuse(_kBeads[currentPage]),
          ),
        ),

        const Spacer(),

        // ── Bottom action bar ──────────────────────────────────────────
        Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: bottomPad + 16,
          ),
          child: _BottomActionBar(
            bead: _kBeads[currentPage],
            isConnected: isConnected,
            onBack: onBack,
            onInfuse: () => onInfuse(_kBeads[currentPage]),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carousel bead — large glowing circle with icon
// ─────────────────────────────────────────────────────────────────────────────

class _CarouselBead extends StatelessWidget {
  const _CarouselBead({required this.bead});

  final _BeadDef bead;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final beadSize = size.width * 0.56;

    return Center(
      child: Container(
        width: beadSize,
        height: beadSize,
        decoration: BoxDecoration(
          color: bead.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bead.color.withValues(alpha: 0.55),
              blurRadius: 40,
              spreadRadius: 4,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: EdgeInsets.all(beadSize * 0.22),
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
// Data packet card
// ─────────────────────────────────────────────────────────────────────────────

class _DataPacketCard extends StatelessWidget {
  const _DataPacketCard({
    super.key,
    required this.bead,
    required this.isConnected,
    required this.onInfuse,
  });

  final _BeadDef bead;
  final bool isConnected;
  final VoidCallback onInfuse;

  String get _command => 'INFUSE:ORB${bead.id}:COLOR:${bead.colorName}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bead name + id row
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
                  bead.colorName,
                  style: const TextStyle(
                    fontFamily: 'Punto',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'ORB ${bead.id}',
                    style: const TextStyle(
                      fontFamily: 'Punto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF757575),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 12),

            // Data packet preview
            Text(
              'Data Packet',
              style: TextStyle(
                fontFamily: 'Punto',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _command,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFF7B61FF),
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Field rows
            _FieldRow(label: 'id', value: '${bead.id}', color: bead.color),
            const SizedBox(height: 4),
            _FieldRow(
              label: 'color',
              value: bead.colorName,
              color: bead.color,
            ),
            const SizedBox(height: 4),
            _FieldRow(
              label: 'status',
              value: isConnected ? 'READY' : 'NOT CONNECTED',
              color: isConnected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFF44336),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: Color(0xFFBDBDBD),
            ),
          ),
        ),
        const Text(
          '→  ',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            color: Color(0xFFE0E0E0),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom action bar
// ─────────────────────────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.bead,
    required this.isConnected,
    required this.onBack,
    required this.onInfuse,
  });

  final _BeadDef bead;
  final bool isConnected;
  final VoidCallback onBack;
  final VoidCallback onInfuse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Back
          _ActionButton(
            icon: Icons.arrow_back_rounded,
            label: 'Back',
            color: const Color(0xFF9E9E9E),
            onTap: onBack,
          ),

          // Infuse — primary action
          _ActionButton(
            icon: Icons.bolt_rounded,
            label: 'Infuse',
            color: isConnected ? const Color(0xFF7B61FF) : const Color(0xFFBDBDBD),
            filled: true,
            fillColor: isConnected
                ? bead.color.withValues(alpha: 0.15)
                : const Color(0xFFF5F5F5),
            onTap: isConnected ? onInfuse : null,
          ),

          // BLE status
          _ActionButton(
            icon: isConnected
                ? Icons.bluetooth_connected
                : Icons.bluetooth_disabled,
            label: isConnected ? 'Live' : 'Offline',
            color: isConnected
                ? const Color(0xFF4CAF50)
                : const Color(0xFFBDBDBD),
            onTap: null,
          ),

          // Info
          _ActionButton(
            icon: Icons.info_outline_rounded,
            label: 'Info',
            color: const Color(0xFF9E9E9E),
            onTap: () => _showPacketInfo(context),
          ),
        ],
      ),
    );
  }

  void _showPacketInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Infuse Command',
          style: TextStyle(fontFamily: 'Punto', fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sending this packet to the device will change the selected orb color:',
              style: TextStyle(fontFamily: 'Punto', fontSize: 13, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'INFUSE:ORB${bead.id}:COLOR:${bead.colorName}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Color(0xFF7B61FF),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(fontFamily: 'Punto')),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.filled = false,
    this.fillColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final Color? fillColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: filled
                  ? (fillColor ?? color.withValues(alpha: 0.1))
                  : const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(16),
              border: filled
                  ? Border.all(color: color.withValues(alpha: 0.3), width: 1.5)
                  : null,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Punto',
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.carouselMode,
    required this.onBack,
    required this.sortOption,
    required this.onSortSelected,
  });

  final bool carouselMode;
  final VoidCallback onBack;
  final _SortOption sortOption;
  final void Function(_SortOption) onSortSelected;

  static const _labels = {
    _SortOption.defaultOrder: 'Default',
    _SortOption.byColor: 'By Color',
    _SortOption.shuffle: 'Shuffle',
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: carouselMode
          ? const SizedBox.shrink(key: ValueKey('hidden'))
          : Column(
              key: const ValueKey('title'),
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
                PopupMenuButton<_SortOption>(
                  onSelected: onSortSelected,
                  offset: const Offset(0, 30),
                  color: Colors.white,
                  elevation: 12,
                  shadowColor: const Color(0x22CDB8E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Color(0xFFEDE7F6),
                      width: 1,
                    ),
                  ),
                  itemBuilder: (_) => _SortOption.values
                      .map(
                        (o) => PopupMenuItem(
                          value: o,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: sortOption == o
                                  ? const Color(0xFFF3EEFF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  sortOption == o
                                      ? Icons.check_circle_rounded
                                      : Icons.circle_outlined,
                                  size: 15,
                                  color: sortOption == o
                                      ? const Color(0xFFAB8FD8)
                                      : const Color(0xFFD4C5EC),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _labels[o]!,
                                  style: TextStyle(
                                    fontFamily: 'Punto',
                                    fontSize: 13,
                                    fontWeight: sortOption == o
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: sortOption == o
                                        ? const Color(0xFF7B5EA7)
                                        : const Color(0xFF9E9E9E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EEFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _labels[sortOption]!,
                          style: const TextStyle(
                            fontFamily: 'Punto',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFAB8FD8),
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFFAB8FD8),
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

