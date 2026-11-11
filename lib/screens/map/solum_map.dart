import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/solum_store.dart';
import '../../theme/solum_theme.dart';
import '../../widgets/solum_components.dart';
import '../onboarding/onboarding_screens.dart' show UserLocationDot;

/// Map configuration. Override the tile source at build time:
/// `--dart-define=SOLUM_TILE_URL=https://.../{z}/{x}/{y}.png`.
///
/// The default OpenStreetMap raster tiles are tinted toward the Solum map
/// palette with [SolumTileTint]. For the exact palette, point this at a
/// custom style (MapTiler/Stadia raster, or switch to MapLibre with a vector
/// style built from docs/design/SPEC.md "Map palette").
abstract final class SolumMapConfig {
  static const tileUrl =
      String.fromEnvironment('SOLUM_TILE_URL', defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png');
  static const userAgentPackage = 'app.solum';

  /// ≈ the prototype's scale (1 px ≈ 0.62 m at Sellwood).
  static const initialZoom = 17.4;
  static const minZoom = 13.0;
  static const maxZoom = 19.0;

  /// Turned off in widget tests (no network).
  static bool showTiles = true;
}

/// Recolors raster tiles by luminance into the Solum ground/road ramp.
/// Light: luminance 0.82 → building, 1.0 → chalk road.
/// Dark: luminance 0.90 → ground, 1.0 → major road.
abstract final class SolumTileTint {
  static ColorFilter forBrightness(Brightness b) => b == Brightness.dark
      ? _ramp(const Color(0xFF1B1F1C), const Color(0xFF3E443D), 0.90, 1.0)
      : _ramp(const Color(0xFFD6CFC1), const Color(0xFFFAF8F3), 0.82, 1.0);

  static ColorFilter _ramp(Color lo, Color hi, double l0, double l1) {
    const wr = 0.2126, wg = 0.7152, wb = 0.0722;
    List<double> row(double a, double b) {
      // out = a + (l - l0) / (l1 - l0) * (b - a), with l in 0..1 and out in 0..255.
      final k = (b - a) / (l1 - l0);
      return [k * wr, k * wg, k * wb, 0, a * 255 - k * l0 * 255];
    }

    return ColorFilter.matrix([
      ...row(lo.r, hi.r),
      ...row(lo.g, hi.g),
      ...row(lo.b, hi.b),
      0,
      0,
      0,
      1,
      0,
    ]);
  }
}

/// The full-bleed map: tiles, areas, draft outline, pins, user location.
class SolumMap extends StatefulWidget {
  const SolumMap({super.key});

  @override
  State<SolumMap> createState() => _SolumMapState();
}

class _SolumMapState extends State<SolumMap> with TickerProviderStateMixin {
  final _controller = MapController();
  StreamSubscription<PanRequest>? _sub;
  AnimationController? _anim;
  bool _ready = false;
  PanRequest? _pending;

  @override
  void initState() {
    super.initState();
    _sub = context.read<SolumStore>().panRequests.listen(_onPan);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _anim?.dispose();
    super.dispose();
  }

  void _onPan(PanRequest r) {
    if (!_ready) {
      _pending = r;
      return;
    }
    final cam = _controller.camera;
    final size = cam.nonRotatedSize;
    if (!r.force) {
      final p = cam.latLngToScreenOffset(r.target);
      if (p.dx > 40 && p.dx < size.width - 40 && p.dy > 250 && p.dy < size.height - 274) return;
    }
    // Place the target at x = center, y = screenY (default: upper middle,
    // clear of the stop cards).
    final y = r.screenY ?? size.height * 0.49;
    final targetPx = cam.projectAtZoom(r.target, cam.zoom);
    final center = cam.unprojectAtZoom(targetPx + Offset(0, size.height / 2 - y), cam.zoom);
    _animateTo(center);
  }

  void _animateTo(LatLng to) {
    final from = _controller.camera.center;
    _anim?.dispose();
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce) {
      _controller.move(to, _controller.camera.zoom);
      return;
    }
    final c = _anim = AnimationController(vsync: this, duration: SolumMotion.pan);
    final curve = CurvedAnimation(parent: c, curve: SolumMotion.ease);
    c.addListener(() {
      final t = curve.value;
      _controller.move(
        LatLng(from.latitude + (to.latitude - from.latitude) * t, from.longitude + (to.longitude - from.longitude) * t),
        _controller.camera.zoom,
      );
    });
    c.forward();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final mc = context.mc;
    final sc = context.sc;
    final olive = context.olive;
    final hi = store.highlightedId;
    final pins = store.mapStops..sort((a, b) => (a.id == hi ? 1 : 0) - (b.id == hi ? 1 : 0));
    final active = store.hasActiveArea ? store.activeArea : null;
    final dashed = StrokePattern.dashed(segments: const [9, 6.5]);

    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: store.initialCenter,
        initialZoom: SolumMapConfig.initialZoom,
        minZoom: SolumMapConfig.minZoom,
        maxZoom: SolumMapConfig.maxZoom,
        backgroundColor: mc.ground,
        interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
        onTap: (_, p) => store.tapMap(p),
        onMapReady: () {
          _ready = true;
          if (store.initialScreenY != null) {
            _onPan(PanRequest(store.initialCenter, force: true, screenY: store.initialScreenY));
          }
          if (_pending != null) _onPan(_pending!);
          _pending = null;
        },
      ),
      children: [
        if (SolumMapConfig.showTiles)
          ColorFiltered(
            colorFilter: SolumTileTint.forBrightness(Theme.of(context).brightness),
            child: TileLayer(
              urlTemplate: SolumMapConfig.tileUrl,
              userAgentPackageName: SolumMapConfig.userAgentPackage,
              maxZoom: SolumMapConfig.maxZoom,
            ),
          ),
        PolygonLayer(
          polygons: [
            for (final a in store.areas)
              if (a.id != active?.id || store.outlining)
                Polygon(
                  points: a.polygon,
                  color: mc.areaFill.withValues(alpha: mc.areaFill.a * 0.55),
                  borderColor: sc.areaStroke.withValues(alpha: 0.55),
                  borderStrokeWidth: 2.6,
                  pattern: dashed,
                ),
            if (active != null && !store.outlining)
              Polygon(
                  points: active.polygon,
                  color: mc.areaFill,
                  borderColor: sc.areaStroke,
                  borderStrokeWidth: 3,
                  pattern: dashed),
            if (store.draft.length >= 3) Polygon(points: store.draft, color: mc.areaFill),
          ],
        ),
        if (store.draft.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: [...store.draft, if (store.draft.length >= 3) store.draft.first],
                color: sc.areaStroke,
                strokeWidth: 3,
                strokeJoin: StrokeJoin.round,
                strokeCap: StrokeCap.round,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (store.coachPin != null)
              Marker(point: store.coachPin!.position!, width: 64, height: 64, child: const _Pulse(size: 22)),
            for (final s in pins)
              Marker(
                point: s.position!,
                width: 40,
                height: 40,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => store.tapPin(s.id),
                  child: Center(child: SolumMapPin(state: s.state, selected: s.id == hi && !store.addMode)),
                ),
              ),
            Marker(point: store.me, width: 40, height: 40, child: Center(child: UserLocationDot(halo: mc.meHalo))),
            if (store.newPin != null && (store.addMode || store.sheet == SheetKind.newContact))
              Marker(
                point: store.newPin!,
                width: 40,
                height: 40,
                child: const Center(child: SolumMapPin(state: StopState.unvisited, selected: true)),
              ),
            if (store.outlining)
              for (final p in store.draft)
                Marker(
                  point: p,
                  width: 16,
                  height: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.raised,
                      shape: BoxShape.circle,
                      border: Border.all(color: olive, width: 3),
                    ),
                  ),
                ),
            if (store.result != null && !store.result!.isStop)
              Marker(
                point: store.result!.point,
                width: 36,
                height: 36,
                alignment: Alignment.topCenter,
                child: Icon(LucideIcons.mapPin, size: 36, color: context.ink, shadows: const [
                  Shadow(color: Color(0x4D1F2421), blurRadius: 3, offset: Offset(0, 2)),
                ]),
              ),
          ],
        ),
      ],
    );
  }
}

/// Pulsing sol ring marking the first gold pin during the walkthrough.
class _Pulse extends StatefulWidget {
  const _Pulse({required this.size});
  final double size;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!(MediaQuery.maybeDisableAnimationsOf(context) ?? false)) _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => Center(
            child: Transform.scale(
              scale: 1 + 1.8 * _c.value,
              child: Opacity(
                opacity: 0.7 * (1 - _c.value),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(color: context.sc.sol, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ),
      );
}
