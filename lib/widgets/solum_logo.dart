import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

/// The official lockup SVG (brand/logos). Full color on light grounds,
/// reverse (white bar and wordmark) in dark mode or on basalt.
class SolumLockup extends StatelessWidget {
  const SolumLockup({super.key, this.height = 28, this.reverse});

  final double height;

  /// Defaults to reverse in dark mode.
  final bool? reverse;

  @override
  Widget build(BuildContext context) {
    final rev = reverse ?? Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      rev ? 'brand/logos/solum-horizontal-reverse.svg' : 'brand/logos/solum-horizontal-full-color.svg',
      height: height,
      semanticsLabel: 'Solum',
    );
  }
}

/// The official mark SVG (sol dot on the ground bar).
class SolumMarkLogo extends StatelessWidget {
  const SolumMarkLogo({super.key, this.height = 32, this.reverse});

  final double height;
  final bool? reverse;

  @override
  Widget build(BuildContext context) {
    final rev = reverse ?? Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      rev ? 'brand/logos/solum-mark-reverse.svg' : 'brand/logos/solum-mark-full-color.svg',
      height: height,
      semanticsLabel: 'Solum',
    );
  }
}
