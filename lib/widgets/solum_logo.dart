import 'package:flutter/material.dart';

import '../theme/solum_theme.dart';

/// The Solum mark: a sol dot resting on a ground bar.
/// Drawn in code so it needs no image package. Proportions match
/// brand/logos/solum-mark-full-color.svg (100-unit box).
class SolumMark extends StatelessWidget {
  const SolumMark({super.key, this.size = 32, this.onDark = false});

  final double size;

  /// Use on basalt or other dark grounds: the bar turns white.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final s = size / 100;
    final bar = onDark ? SolumPalette.onBasalt : Theme.of(context).colorScheme.onSurface;
    return Semantics(
      label: 'Solum',
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned(
              left: 32 * s,
              top: 22 * s,
              child: Container(
                width: 36 * s,
                height: 36 * s,
                decoration: const BoxDecoration(color: SolumPalette.sol, shape: BoxShape.circle),
              ),
            ),
            Positioned(
              left: 14 * s,
              top: 66 * s,
              child: Container(
                width: 72 * s,
                height: 14 * s,
                decoration: BoxDecoration(color: bar, borderRadius: BorderRadius.circular(7 * s)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mark plus the "solum" wordmark set in Plus Jakarta Sans ExtraBold.
/// For print and marketing use the outlined SVGs in brand/logos/.
class SolumLogo extends StatelessWidget {
  const SolumLogo({super.key, this.height = 32, this.onDark = false});

  final double height;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final color = onDark ? SolumPalette.onBasalt : Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SolumMark(size: height * 1.1, onDark: onDark),
        SizedBox(width: height * 0.15),
        Text(
          'solum',
          style: TextStyle(
            fontFamily: SolumText.family,
            fontWeight: FontWeight.w800,
            fontSize: height,
            height: 1,
            letterSpacing: -0.045 * height,
            color: color,
          ),
        ),
      ],
    );
  }
}
