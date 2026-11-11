import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/solum_store.dart';
import '../../theme/solum_theme.dart';
import '../../widgets/solum_components.dart';
import 'search_overlay.dart';
import 'solum_map.dart';

/// Height of the bottom tab bar including the home indicator
/// (84 on a phone with a 34px home indicator).
double tabBarHeight(BuildContext context) {
  final b = MediaQuery.paddingOf(context).bottom;
  return b > 0 ? 50 + b : 62;
}

/// 6. Map (layout 1b): full-bleed map, slim progress card, filter chips,
/// FAB column, swipeable stop cards.
class MapTab extends StatelessWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final top = MediaQuery.paddingOf(context).top + 4;
    final bottom = tabBarHeight(context);
    final complete = store.isComplete();
    final overlay = !store.addMode && !store.outlining;
    final coach = SolumStore.coachCopy[store.tour];

    return Stack(
      children: [
        const Positioned.fill(child: SolumMap()),
        Positioned(
          left: 8,
          bottom: bottom + 4,
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: context.mc.attributionBg, borderRadius: BorderRadius.circular(6)),
              child: Text('© OpenStreetMap contributors',
                  style: TextStyle(
                      fontFamily: SolumText.family,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      height: 14 / 11,
                      color: context.mc.label)),
            ),
          ),
        ),
        if (store.addMode) ..._addMode(context, store, top, bottom),
        if (store.outlining) ..._outlineMode(context, store, top, bottom),
        if (overlay) ...[
          Positioned(
            top: top,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProgressCard(),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      for (final (f, label) in const [
                        (MapFilter.all, 'All'),
                        (MapFilter.followUps, 'Follow-ups'),
                        (MapFilter.notVisited, 'Not visited')
                      ]) ...[
                        SolumChip(
                          label: label,
                          floating: true,
                          selected: store.filter == f,
                          count: f == MapFilter.all ? null : store.filterCount(f),
                          onTap: () => store.setFilter(f),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: top + (complete ? 242 : 214),
            child: Column(
              children: [
                SolumIconButton(icon: LucideIcons.search, label: 'Search', onPressed: store.openSearch),
                const SizedBox(height: 10),
                SolumIconButton(icon: LucideIcons.plus, label: 'Add contact', onPressed: store.startAdd),
                const SizedBox(height: 10),
                SolumIconButton(icon: LucideIcons.locateFixed, label: 'Center on me', onPressed: store.centerOnMe),
              ],
            ),
          ),
          if (coach != null && !store.searchOpen)
            Positioned(top: top + 164, left: 16, right: 72, child: CoachCard(step: coach, showCta: store.tour == 3)),
          if (store.result == null && store.cards.isNotEmpty)
            Positioned(left: 0, right: 0, bottom: bottom + 16, child: const StopCardCarousel()),
          if (store.result != null) Positioned(left: 16, right: 16, bottom: bottom + 28, child: const ResultCard()),
        ],
        if (store.searchOpen) Positioned.fill(bottom: bottom, child: const SearchOverlay()),
      ],
    );
  }

  List<Widget> _banner(BuildContext context, double top, String title, String hint, VoidCallback onCancel) => [
        Positioned(
          top: top,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
                color: context.sc.basalt,
                borderRadius: BorderRadius.circular(SolumRadius.md),
                boxShadow: SolumShadows.float),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: SolumText.bodyStrong.copyWith(color: context.sc.onBasalt)),
                      const SizedBox(height: 2),
                      Text(hint, style: SolumText.small.copyWith(color: Colors.white.withValues(alpha: 0.72))),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SolumButton(
                    label: 'Cancel',
                    size: SolumButtonSize.sm,
                    variant: SolumButtonVariant.secondary,
                    onPressed: onCancel),
              ],
            ),
          ),
        ),
      ];

  List<Widget> _addMode(BuildContext context, SolumStore store, double top, double bottom) => [
        ..._banner(context, top, 'Add a contact', store.addModeHint, store.cancelAdd),
        Positioned(
          top: top + 92,
          left: 16,
          child: GestureDetector(
            onTap: store.openManual,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: context.raised,
                  borderRadius: BorderRadius.circular(SolumRadius.pill),
                  boxShadow: SolumShadows.float),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.keyboard, size: 18, color: context.ink),
                  const SizedBox(width: 8),
                  Text('House not on the map? Type the address',
                      style: TextStyle(
                          fontFamily: SolumText.family, fontWeight: FontWeight.w700, fontSize: 14, color: context.ink)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: bottom + 28,
          child: SolumButton(
            label: 'Add contact here',
            icon: LucideIcons.plus,
            fullWidth: true,
            shadow: true,
            onPressed: store.newPin == null ? null : store.confirmPin,
          ),
        ),
      ];

  List<Widget> _outlineMode(BuildContext context, SolumStore store, double top, double bottom) => [
        ..._banner(context, top, 'Outline a new area', store.outlineHint, store.cancelOutline),
        Positioned(
          left: 16,
          right: 16,
          bottom: bottom + 28,
          child: Row(
            children: [
              Expanded(
                child: SolumButton(
                  label: 'Undo',
                  icon: LucideIcons.undo2,
                  variant: SolumButtonVariant.secondary,
                  fullWidth: true,
                  shadow: true,
                  onPressed: store.draft.isEmpty ? null : store.undoCorner,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SolumButton(
                  label: 'Done',
                  icon: LucideIcons.check,
                  fullWidth: true,
                  shadow: true,
                  onPressed: store.draft.length < 3 ? null : store.finishOutline,
                ),
              ),
            ],
          ),
        ),
      ];
}

/// Top progress card: area name (→ Your areas), "37 of 43 visited", today
/// pill (→ Follow-ups), progress bar. Switches to "Area complete".
class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final complete = store.isComplete();
    final v = store.visitedIn(), t = store.totalIn();
    final today = store.todayList.length;
    final open = store.openFollowUps;
    final areaLabel = GestureDetector(
      onTap: store.openAreas,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SolumLabel(store.hasActiveArea ? store.activeArea.name : ''),
          const SizedBox(width: 4),
          Icon(LucideIcons.chevronDown, size: 16, color: context.inkMuted),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          color: context.raised, borderRadius: BorderRadius.circular(SolumRadius.md), boxShadow: SolumShadows.float),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (complete) ...[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: context.olive, shape: BoxShape.circle),
                  child: Icon(LucideIcons.check, size: 24, color: context.onOlive),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    areaLabel,
                    const SizedBox(height: 2),
                    Text(complete ? 'Area complete' : '$v of $t visited',
                        style: SolumText.count.copyWith(color: context.ink)),
                  ],
                ),
              ),
              if (!complete && today > 0)
                GestureDetector(
                  onTap: () => store.setTab(AppTab.followUps),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: context.sc.solTint, borderRadius: BorderRadius.circular(999)),
                    child: Row(
                      children: [
                        const SolDot(size: 10),
                        const SizedBox(width: 8),
                        Text('$today today',
                            style: TextStyle(
                                fontFamily: SolumText.family,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: context.ink)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          SolumProgressBar(value: v, max: t),
          if (complete) ...[
            const SizedBox(height: 10),
            Text(
              'All $t stops visited. ${open > 0 ? '$open ${open == 1 ? 'follow-up' : 'follow-ups'} still open.' : 'No follow-ups open.'}',
              style: SolumText.small.copyWith(color: context.inkMuted),
            ),
          ],
        ],
      ),
    );
  }
}

/// Sol dot with a thin basalt ring (follow-up signal).
class SolDot extends StatelessWidget {
  const SolDot({super.key, this.size = 10});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.sc.sol,
          shape: BoxShape.circle,
          border: Border.all(color: SolumPalette.basalt, width: 1.5, strokeAlign: BorderSide.strokeAlignInside),
        ),
      );
}

/// Basalt walkthrough card.
class CoachCard extends StatelessWidget {
  const CoachCard({super.key, required this.step, required this.showCta});
  final (String, String, String) step;
  final bool showCta;

  @override
  Widget build(BuildContext context) {
    final store = context.read<SolumStore>();
    final muted = Colors.white.withValues(alpha: 0.72);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          color: context.sc.basalt, borderRadius: BorderRadius.circular(SolumRadius.md), boxShadow: SolumShadows.float),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: SolumLabel(step.$1, color: muted)),
              GestureDetector(
                onTap: store.skipTour,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(12, 14, 0, 14),
                  child: Text('Skip',
                      style: TextStyle(
                          fontFamily: SolumText.family,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 1,
                          color: SolumPalette.oliveOnBasalt)),
                ),
              ),
            ],
          ),
          Text(step.$2, style: SolumText.bodyStrong.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(step.$3, style: SolumText.small.copyWith(color: muted)),
          if (showCta) ...[
            const SizedBox(height: 12),
            SolumButton(
              label: 'Outline your area',
              icon: LucideIcons.penLine,
              size: SolumButtonSize.md,
              fullWidth: true,
              onPressed: store.startOutline,
            ),
          ],
        ],
      ),
    );
  }
}

/// Snaps a horizontal list to [itemExtent] steps.
class _SnapPhysics extends ScrollPhysics {
  const _SnapPhysics({required this.itemExtent, super.parent});
  final double itemExtent;

  @override
  _SnapPhysics applyTo(ScrollPhysics? ancestor) => _SnapPhysics(itemExtent: itemExtent, parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    if ((velocity <= 0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = toleranceFor(position);
    var page = position.pixels / itemExtent;
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    final target = (page.roundToDouble() * itemExtent).clamp(position.minScrollExtent, position.maxScrollExtent);
    if ((target - position.pixels).abs() < tolerance.distance) return null;
    return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
  }

  @override
  bool get allowImplicitScrolling => false;
}

/// Swipeable stop cards. Swiping selects the stop (and pans the map if the
/// pin is off-screen); tapping a pin scrolls here.
class StopCardCarousel extends StatefulWidget {
  const StopCardCarousel({super.key});

  @override
  State<StopCardCarousel> createState() => _StopCardCarouselState();
}

class _StopCardCarouselState extends State<StopCardCarousel> {
  static const cardWidth = 300.0, gap = 12.0, extent = cardWidth + gap;
  final _scroll = ScrollController();
  StreamSubscription<int>? _sub;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    final store = context.read<SolumStore>();
    _sub = store.cardScrollRequests.listen((i) async {
      if (!_scroll.hasClients) return;
      _locked = true;
      await _scroll.animateTo((i * extent).clamp(0, _scroll.position.maxScrollExtent),
          duration: SolumMotion.sheet, curve: SolumMotion.ease);
      _locked = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final idx = store.cards.indexWhere((c) => c.id == store.highlightedId);
      if (idx > 0 && _scroll.hasClients) _scroll.jumpTo((idx * extent).clamp(0, _scroll.position.maxScrollExtent));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final cards = store.cards;
    final hi = store.highlightedId;
    return NotificationListener<ScrollEndNotification>(
      onNotification: (_) {
        if (!_locked && _scroll.hasClients) store.onCardSettled((_scroll.offset / extent).round());
        return false;
      },
      child: SizedBox(
        height: 152,
        child: ListView.separated(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          physics: const _SnapPhysics(itemExtent: extent),
          padding: const EdgeInsets.fromLTRB(16, 8, 20, 12),
          clipBehavior: Clip.none,
          itemCount: cards.length,
          separatorBuilder: (_, __) => const SizedBox(width: gap),
          itemBuilder: (context, i) =>
              SizedBox(width: cardWidth, child: StopCard(stop: cards[i], selected: cards[i].id == hi)),
        ),
      ),
    );
  }
}

/// One stop card: pin, name, sub line, badge, directions; Log visit / Follow up.
class StopCard extends StatelessWidget {
  const StopCard({super.key, required this.stop, required this.selected});
  final Stop stop;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final store = context.read<SolumStore>();
    final s = stop;
    final sub = s.isFollowUp ? (s.note.isNotEmpty ? s.note : s.street) : (s.isNamed ? s.street : 'Not visited');
    final badge = SolumStore.badgeText(s);
    return GestureDetector(
      onTap: () => store.select(s.id),
      child: AnimatedContainer(
        duration: SolumMotion.press,
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        decoration: BoxDecoration(
          color: context.raised,
          borderRadius: BorderRadius.circular(SolumRadius.md),
          boxShadow: SolumShadows.float,
          border: Border.all(
              color: selected ? context.olive : Colors.transparent,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SolumMapPin(state: s.state),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => store.openContact(s.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: SolumText.bodyStrong.copyWith(color: context.ink)),
                        const SizedBox(height: 2),
                        Text(sub,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: SolumText.small.copyWith(color: context.inkMuted)),
                      ],
                    ),
                  ),
                ),
                if (badge != null) ...[const SizedBox(width: 12), SolumBadge(badge, tone: BadgeTone.followUp)],
                const SizedBox(width: 12),
                SolumIconButton(
                  icon: LucideIcons.navigation,
                  label: 'Directions',
                  variant: SolumIconButtonVariant.tint,
                  onPressed: () => store.askDirections(s.street),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SolumButton(
                    label: 'Log visit',
                    size: SolumButtonSize.md,
                    variant: SolumButtonVariant.dark,
                    fullWidth: true,
                    onPressed: () => store.openLog(s.id),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SolumButton(
                    label: 'Follow up',
                    size: SolumButtonSize.md,
                    variant: SolumButtonVariant.signal,
                    fullWidth: true,
                    onPressed: () => store.openFollow(s.id),
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

/// Single result card for a search pick or a visited pin.
class ResultCard extends StatelessWidget {
  const ResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final r = store.result!;
    final s = store.stopById(r.stopId);
    final isStop = s != null;
    final name = isStop ? s.name : r.label!;
    final sub = isStop ? (s.isNamed ? s.street : s.listLine) : 'Not in your contacts yet';
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      decoration: BoxDecoration(
          color: context.raised, borderRadius: BorderRadius.circular(SolumRadius.md), boxShadow: SolumShadows.float),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (isStop) SolumMapPin(state: s.state) else Icon(LucideIcons.mapPin, size: 22, color: context.ink),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: isStop ? () => store.openContact(s.id) : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: SolumText.bodyStrong.copyWith(color: context.ink)),
                      const SizedBox(height: 2),
                      Text(sub,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: SolumText.small.copyWith(color: context.inkMuted)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SolumIconButton(
                  icon: LucideIcons.x,
                  label: 'Close',
                  variant: SolumIconButtonVariant.tint,
                  onPressed: store.clearResult),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SolumButton(
                  label: 'Directions',
                  icon: LucideIcons.navigation,
                  size: SolumButtonSize.md,
                  variant: SolumButtonVariant.secondary,
                  fullWidth: true,
                  onPressed: () => store.askDirections(isStop ? s.street : r.label!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: isStop
                    ? SolumButton(
                        label: 'Log visit',
                        size: SolumButtonSize.md,
                        variant: SolumButtonVariant.dark,
                        fullWidth: true,
                        onPressed: () => store.openLog(s.id),
                      )
                    : SolumButton(
                        label: 'Add contact',
                        icon: LucideIcons.plus,
                        size: SolumButtonSize.md,
                        fullWidth: true,
                        onPressed: store.addFromResult,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
