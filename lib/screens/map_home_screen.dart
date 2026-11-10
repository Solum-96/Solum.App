import 'package:flutter/material.dart';

import '../theme/solum_theme.dart';
import '../widgets/solum_logo.dart';

enum PinState { notVisited, visited, followUp }

/// Branded starting point for the map screen, laid out as in the brand book:
/// greeting card, follow-up filters, Outline-area button, and a bottom sheet
/// with area progress, the next contact and the two primary actions.
///
/// The map is a placeholder painter with sample data. Swap [_MapPlaceholder]
/// for a real map widget (google_maps_flutter, flutter_map, ...) and keep the
/// pin colors from [SolumColors].
class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({super.key});

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  static const _filters = ['Today', 'This week', 'Not visited'];
  String _filter = 'Today';
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final solum = SolumColors.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _MapPlaceholder()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(SolumSpace.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _GreetingCard(peopleToday: 3),
                  const SizedBox(height: SolumSpace.s2 + 2),
                  Wrap(
                    spacing: SolumSpace.s2,
                    runSpacing: SolumSpace.s2,
                    children: [
                      for (final f in _filters)
                        ChoiceChip(
                          label: Text(f),
                          selected: _filter == f,
                          onSelected: (_) => setState(() => _filter = f),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: SolumSpace.s4,
            bottom: 330,
            child: FloatingActionButton.large(
              onPressed: () {},
              tooltip: 'Outline a new area',
              child: const Icon(Icons.draw_outlined, size: 30),
            ),
          ),
          const Align(alignment: Alignment.bottomCenter, child: _AreaSheet()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Contacts'),
          NavigationDestination(icon: Icon(Icons.event_outlined), selectedIcon: Icon(Icons.event), label: 'Follow-ups'),
        ],
      ),
      backgroundColor: solum.sandstone,
    );
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.peopleToday});

  final int peopleToday;

  @override
  Widget build(BuildContext context) {
    final solum = SolumColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: SolumSpace.s4, vertical: 14),
      decoration: BoxDecoration(
        color: solum.basalt,
        borderRadius: BorderRadius.circular(SolumRadius.md + 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning', style: SolumText.small.copyWith(color: const Color(0xFFD3D6D2))),
                const SizedBox(height: 2),
                Text(
                  '$peopleToday people to see today',
                  style: SolumText.heading.copyWith(color: solum.onBasalt, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SolumMark(size: 34, onDark: true),
        ],
      ),
    );
  }
}

class _AreaSheet extends StatelessWidget {
  const _AreaSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final solum = SolumColors.of(context);
    const visited = 29, total = 41, followUps = 7;

    return Material(
      color: theme.colorScheme.surfaceContainerLowest,
      elevation: 8,
      shadowColor: const Color(0x331F2421),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(SolumRadius.lg)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(SolumSpace.s5, 10, SolumSpace.s5, SolumSpace.s4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(color: solum.sandstone, borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(height: SolumSpace.s4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('WESTGATE', style: theme.textTheme.labelMedium),
                      const SizedBox(height: SolumSpace.s1),
                      Text('$visited of $total visited', style: theme.textTheme.headlineSmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: solum.solTint,
                    borderRadius: BorderRadius.circular(SolumRadius.sm),
                  ),
                  child: Text('$followUps follow-ups', style: SolumText.label.copyWith(letterSpacing: 0, color: theme.colorScheme.onSurface)),
                ),
              ],
            ),
            const SizedBox(height: SolumSpace.s4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(value: visited / total),
            ),
            const SizedBox(height: SolumSpace.s4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(SolumRadius.md),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: solum.sol,
                    foregroundColor: solum.onSol,
                    child: const Text('RK', style: SolumText.bodyStrong),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ray Kim · Kim Auto Body', style: theme.textTheme.titleMedium),
                        Text('Follow up 10:30 · asked for pricing', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SolumSpace.s4),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: solum.basalt, foregroundColor: solum.onBasalt),
                    onPressed: () {},
                    child: const Text('Log visit'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: solum.sol, foregroundColor: solum.onSol),
                    onPressed: () {},
                    child: const Text('Follow up'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Sample streets, an outlined area and pins in the Solum map language.
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MapPainter(SolumColors.of(context), Theme.of(context).colorScheme.surface));
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter(this.c, this.street);

  final SolumColors c;
  final Color street;

  static const _pins = <(double, double, PinState)>[
    (0.31, 0.26, PinState.visited),
    (0.40, 0.25, PinState.visited),
    (0.46, 0.28, PinState.visited),
    (0.32, 0.33, PinState.followUp),
    (0.42, 0.35, PinState.visited),
    (0.62, 0.27, PinState.notVisited),
    (0.71, 0.31, PinState.notVisited),
    (0.63, 0.46, PinState.followUp),
    (0.33, 0.48, PinState.notVisited),
    (0.73, 0.49, PinState.notVisited),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final road = Paint()
      ..color = street
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;
    for (final y in [0.20, 0.38, 0.56]) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * (y - 0.02)), road);
    }
    for (final x in [0.16, 0.52, 0.86]) {
      canvas.drawLine(Offset(w * x, 0), Offset(w * (x + 0.04), h), road);
    }

    final area = Path()
      ..moveTo(w * 0.25, h * 0.22)
      ..lineTo(w * 0.51, h * 0.21)
      ..lineTo(w * 0.52, h * 0.37)
      ..lineTo(w * 0.26, h * 0.38)
      ..close();
    canvas.drawPath(area, Paint()..color = c.areaFill);
    canvas.drawPath(
      area,
      Paint()
        ..color = c.areaStroke
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    for (final (x, y, state) in _pins) {
      final center = Offset(w * x, h * y);
      switch (state) {
        case PinState.visited:
          canvas.drawCircle(center, 8, Paint()..color = c.pinVisited);
        case PinState.notVisited:
          canvas.drawCircle(center, 7, Paint()..color = c.pinNotVisited);
          canvas.drawCircle(center, 7, Paint()..color = c.pinRing..style = PaintingStyle.stroke..strokeWidth = 3);
        case PinState.followUp:
          canvas.drawCircle(center, 9, Paint()..color = c.sol);
          canvas.drawCircle(center, 9, Paint()..color = c.pinRing..style = PaintingStyle.stroke..strokeWidth = 3);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => old.c != c || old.street != street;
}
