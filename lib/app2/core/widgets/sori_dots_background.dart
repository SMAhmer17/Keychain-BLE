import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keychain_ble/core/extensions/size_extensions.dart';

/// Wraps [child] with the three background dot decorations used across screens:
/// top-right, bottom-left, and bottom-right.
class SoriDotsBackground extends StatelessWidget {
  const SoriDotsBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-right dots
        Positioned(
          top: .15.sh,
          right: 0,
          child: SvgPicture.asset(
            'assets/icons/light/center_dots.svg',
            width: 250,
            height: 217,
          ),
        ),
        // Bottom-left dots
        Positioned(
          bottom: .15.sh,
          left: 0,
          child: SvgPicture.asset(
            'assets/icons/light/bottom_left_dots.svg',
            width: 185,
            height: 139,
          ),
        ),
        // Bottom-right dots
        Positioned(
          bottom: 0,
          right: 0,
          child: SvgPicture.asset(
            'assets/icons/light/bottom_right_dots.svg',
            width: 155,
            height: 132,
          ),
        ),
        // Screen content
        child,
      ],
    );
  }
}
