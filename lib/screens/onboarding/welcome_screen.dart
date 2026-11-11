import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/solum_store.dart';
import '../../theme/solum_theme.dart';
import '../../widgets/solum_components.dart';
import '../../widgets/solum_logo.dart';

/// 1. Welcome: three animated brand slabs, lockup, headline, two buttons.
/// All loops stop when the OS asks for reduced motion.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<SolumStore>();
    return OnboardingScaffold(
      gap: 28,
      children: [
        const Expanded(child: WelcomeSlabs()),
        const _RiseIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SolumLockup(height: 28),
              SizedBox(height: 14),
              _WelcomeText(),
            ],
          ),
        ),
        Column(
          children: [
            SolumButton(label: 'Get started', fullWidth: true, onPressed: () => store.goTo(OnboardingStep.how)),
            const SizedBox(height: 8),
            SolumButton(
              label: 'I already have an account',
              variant: SolumButtonVariant.secondary,
              fullWidth: true,
              onPressed: store.startSignIn,
            ),
          ],
        ),
      ],
    );
  }
}

class _WelcomeText extends StatelessWidget {
  const _WelcomeText();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Solid ground for solo sellers.', style: SolumText.welcome.copyWith(color: context.ink)),
            const SizedBox(height: 14),
            Text('Outline your area, see what you have covered, and keep every follow-up in your pocket.',
                style: SolumText.body.copyWith(color: context.inkMuted)),
          ],
        ),
      );
}

/// Shared onboarding layout: safe-area padding 16 sides, 44 bottom.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({super.key, required this.children, this.gap = 24});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, pad.top + 8, 16, math.max(pad.bottom, 10) + 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[if (i > 0) SizedBox(height: gap), children[i]],
          ],
        ),
      ),
    );
  }
}

/// Elapsed-time driver for the welcome animations. Frozen when the platform
/// requests reduced motion.
mixin _Clock<T extends StatefulWidget> on State<T>, SingleTickerProviderStateMixin<T> {
  final time = ValueNotifier<double>(0);
  late final Ticker _ticker = createTicker((d) => time.value = d.inMicroseconds / 1e6);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce) {
      if (_ticker.isActive) _ticker.stop();
      time.value = 10; // intros finished, loops at rest
    } else if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    time.dispose();
    super.dispose();
  }
}

/// The three brand slabs: olive (floating icon tokens + the mark), basalt
/// (pins turning olive one by one) and sandstone (marching area outline).
class WelcomeSlabs extends StatefulWidget {
  const WelcomeSlabs({super.key});

  @override
  State<WelcomeSlabs> createState() => _WelcomeSlabsState();
}

class _WelcomeSlabsState extends State<WelcomeSlabs> with SingleTickerProviderStateMixin, _Clock {
  static const _olive = SolumPalette.olive;
  static const _chalk = SolumPalette.surface;
  static const _basalt = SolumPalette.basalt;
  static const _sol = SolumPalette.sol;
  static const _ease = SolumMotion.ease;

  double _float(double t, double period, double delay) =>
      -8 * (0.5 - 0.5 * math.cos(2 * math.pi * ((t + delay) % period) / period));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: time,
      builder: (context, t, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 13, child: _slab(_olive, _oliveSlab(t))),
          const SizedBox(width: 8),
          Expanded(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 100, child: _slab(_basalt, _basaltSlab(t))),
                const SizedBox(height: 8),
                Expanded(flex: 75, child: _slab(context.sandstone, _sandSlab(t))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slab(Color c, Widget child) => ClipRRect(
        borderRadius: BorderRadius.circular(SolumRadius.lg),
        child: ColoredBox(color: c, child: child),
      );

  Widget _token(IconData icon, Color bg) => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 24, color: _basalt),
      );

  Widget _oliveSlab(double t) {
    final drop = _ease.transform(((t - 0.3) / 0.9).clamp(0.0, 1.0));
    final grow = _ease.transform((t / 0.7).clamp(0.0, 1.0));
    return Stack(
      children: [
        Positioned(left: 24, top: 28 + _float(t, 4.2, 0), child: _token(LucideIcons.map, _chalk)),
        Positioned(right: 22, top: 84 + _float(t, 4.2, 1.4), child: _token(LucideIcons.calendarClock, _sol)),
        Positioned(left: 46, top: 148 + _float(t, 4.2, 2.8), child: _token(LucideIcons.users, _chalk)),
        Positioned(
          left: 28,
          bottom: 40,
          child: SizedBox(
            width: 132,
            child: Column(
              children: [
                Opacity(
                  opacity: drop,
                  child: Transform.translate(
                    offset: Offset(0, -160 * (1 - drop)),
                    child: Container(
                        width: 48, height: 48, decoration: const BoxDecoration(color: _sol, shape: BoxShape.circle)),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Transform.scale(
                    scaleX: grow,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 132,
                      height: 18,
                      decoration: BoxDecoration(color: _chalk, borderRadius: BorderRadius.circular(999)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static const _dots = [(.22, .22), (.50, .16), (.74, .30), (.16, .52), (.64, .60), (.30, .78), (.76, .80)];

  /// sVisit keyframes (7s): white until 18%, pop to 1.3 at 24%, olive 30–88%,
  /// back to white at 100%.
  (Color, double) _visit(double t, double delay) {
    final p = ((t - delay) % 7) / 7;
    if (t < delay) return (Colors.white, 1);
    double scale = 1;
    if (p > .18 && p < .30) scale = p < .24 ? 1 + .3 * (p - .18) / .06 : 1.3 - .3 * (p - .24) / .06;
    Color c;
    if (p <= .18) {
      c = Colors.white;
    } else if (p < .30) {
      c = Color.lerp(Colors.white, _olive, (p - .18) / .12)!;
    } else if (p <= .88) {
      c = _olive;
    } else {
      c = Color.lerp(_olive, Colors.white, (p - .88) / .12)!;
    }
    return (c, scale);
  }

  Widget _basaltSlab(double t) {
    final pulse = (t % 2) / 2;
    return LayoutBuilder(
      builder: (context, c) => Stack(
        children: [
          for (var i = 0; i < _dots.length; i++)
            Positioned(
              left: c.maxWidth * _dots[i].$1,
              top: c.maxHeight * _dots[i].$2,
              child: Builder(builder: (_) {
                final (col, s) = _visit(t, i * 0.7);
                return Transform.scale(
                  scale: s,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                        color: col, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  ),
                );
              }),
            ),
          Positioned(
            left: c.maxWidth * .4,
            top: c.maxHeight * .4,
            child: SizedBox(
              width: 20,
              height: 20,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Transform.scale(
                    scale: 1 + 1.8 * pulse,
                    child: Opacity(
                      opacity: .7 * (1 - pulse),
                      child: Container(decoration: const BoxDecoration(color: _sol, shape: BoxShape.circle)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: _sol, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sandSlab(double t) => Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomPaint(painter: _MarchingOutline(offset: -30 * ((t % 1.4) / 1.4))),
            ),
          ),
          Transform.translate(
            offset: Offset(0, _float(t, 3, 0)),
            child: const Icon(LucideIcons.mapPin, size: 32, color: _basalt),
          ),
        ],
      );
}

class _MarchingOutline extends CustomPainter {
  _MarchingOutline({required this.offset});
  final double offset;
  static const _pts = [Offset(14, 18), Offset(92, 6), Offset(112, 62), Offset(58, 94), Offset(6, 70)];

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 120, sy = size.height / 100;
    final path = Path()..addPolygon([for (final p in _pts) Offset(p.dx * sx, p.dy * sy)], true);
    canvas.drawPath(path, Paint()..color = SolumPalette.areaFill);
    final paint = Paint()
      ..color = SolumPalette.olive
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round;
    for (final m in path.computeMetrics()) {
      var d = -((-offset) % 15);
      while (d < m.length) {
        final a = math.max(0.0, d), b = math.min(m.length, d + 9);
        if (b > a) canvas.drawPath(m.extractPath(a, b), paint);
        d += 15;
      }
    }
  }

  @override
  bool shouldRepaint(_MarchingOutline old) => old.offset != offset;
}

/// Fades text up 14px over 600 ms after a 200 ms delay.
class _RiseIn extends StatefulWidget {
  const _RiseIn({required this.child});
  final Widget child;

  @override
  State<_RiseIn> createState() => _RiseInState();
}

class _RiseInState extends State<_RiseIn> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _c.value = 1;
    } else if (!_c.isAnimating && _c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          final v = SolumMotion.ease.transform(((_c.value * 800 - 200) / 600).clamp(0.0, 1.0));
          return Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 14 * (1 - v)), child: child));
        },
        child: widget.child,
      );
}
