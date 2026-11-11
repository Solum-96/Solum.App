// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;

/// The Solum map (spec §6 and §12): tinted OSM tiles, the active area as a
/// dashed olive outline, a draft outline while drawing, pins and the user dot.
///
/// Pubspec dependencies: flutter_map ^8.3.2, latlong2 ^0.10.1.
/// Parameters (FlutterFlow types):
///   stops        List<StopStruct>   (Data Type "Stop", see flutterflow/schema.md)
///   areaPolygon  List<LatLng>       active area corners
///   draftPolygon List<LatLng>       corners while outlining (may be empty)
///   userLocation LatLng?
///   selectedStopId String?
///   onPinTap     Action (stopId String)
///   onMapTap     Action (point LatLng)  — add-pin and outline modes
///   dark         bool                 use the dark map tint
///
/// Full reference implementation: lib/screens/map/solum_map.dart.
class SolumAreaMap extends StatefulWidget {
  const SolumAreaMap({
    super.key,
    this.width,
    this.height,
    required this.stops,
    required this.areaPolygon,
    this.draftPolygon,
    this.userLocation,
    this.selectedStopId,
    this.onPinTap,
    this.onMapTap,
    this.dark = false,
  });

  final double? width;
  final double? height;
  final List<StopStruct> stops;
  final List<LatLng> areaPolygon;
  final List<LatLng>? draftPolygon;
  final LatLng? userLocation;
  final String? selectedStopId;
  final Future Function(String stopId)? onPinTap;
  final Future Function(LatLng point)? onMapTap;
  final bool dark;

  @override
  State<SolumAreaMap> createState() => _SolumAreaMapState();
}

class _SolumAreaMapState extends State<SolumAreaMap> {
  final _controller = MapController();

  static ll.LatLng _c(LatLng p) => ll.LatLng(p.latitude, p.longitude);

  ll.LatLng get _center {
    final pts = widget.areaPolygon.isNotEmpty ? widget.areaPolygon : widget.stops.map((s) => s.location!).toList();
    if (pts.isEmpty) return const ll.LatLng(45.4668, -122.6500); // Sellwood
    final lat = pts.map((p) => p.latitude).reduce((a, b) => a + b) / pts.length;
    final lng = pts.map((p) => p.longitude).reduce((a, b) => a + b) / pts.length;
    return ll.LatLng(lat, lng);
  }

  /// Recolors OSM raster tiles by luminance into the Solum ground/road ramp.
  ColorFilter _tint() {
    final (lo, hi, l0) =
        widget.dark ? (const Color(0xFF1B1F1C), const Color(0xFF3E443D), 0.90) : (const Color(0xFFD6CFC1), const Color(0xFFFAF8F3), 0.82);
    List<double> row(double a, double b) {
      final k = (b - a) / (1 - l0);
      return [k * 0.2126, k * 0.7152, k * 0.0722, 0, a * 255 - k * l0 * 255];
    }

    return ColorFilter.matrix([...row(lo.r, hi.r), ...row(lo.g, hi.g), ...row(lo.b, hi.b), 0, 0, 0, 1, 0]);
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final olive = t.primary;
    final fill = olive.withValues(alpha: widget.dark ? 0.14 : 0.12);
    final draft = (widget.draftPolygon ?? const []).map(_c).toList();
    final pins = widget.stops.where((s) => s.hasLocation()).toList()
      ..sort((a, b) => (a.id == widget.selectedStopId ? 1 : 0) - (b.id == widget.selectedStopId ? 1 : 0));

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FlutterMap(
        mapController: _controller,
        options: MapOptions(
          initialCenter: _center,
          initialZoom: 17.4,
          minZoom: 13,
          maxZoom: 19,
          backgroundColor: widget.dark ? const Color(0xFF1B1F1C) : const Color(0xFFE7DFD0),
          interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
          onTap: (_, p) => widget.onMapTap?.call(LatLng(p.latitude, p.longitude)),
        ),
        children: [
          ColorFiltered(
            colorFilter: _tint(),
            child: TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'app.solum'),
          ),
          PolygonLayer(polygons: [
            if (widget.areaPolygon.length >= 3 && draft.isEmpty)
              Polygon(
                points: widget.areaPolygon.map(_c).toList(),
                color: fill,
                borderColor: olive,
                borderStrokeWidth: 3,
                pattern: StrokePattern.dashed(segments: const [9, 6.5]),
              ),
            if (draft.length >= 3) Polygon(points: draft, color: fill),
          ]),
          if (draft.length >= 2)
            PolylineLayer(polylines: [
              Polyline(points: [...draft, if (draft.length >= 3) draft.first], color: olive, strokeWidth: 3),
            ]),
          MarkerLayer(markers: [
            for (final s in pins)
              Marker(
                point: _c(s.location!),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => widget.onPinTap?.call(s.id),
                  child: SolumMapPin(state: s.state, selected: s.id == widget.selectedStopId),
                ),
              ),
            if (widget.userLocation != null)
              Marker(
                point: _c(widget.userLocation!),
                width: 40,
                height: 40,
                child: Center(
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: olive.withValues(alpha: 0.22), spreadRadius: 7)],
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(color: Color(0xFF1F2421), shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
            for (final p in draft)
              Marker(
                point: p,
                width: 16,
                height: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: t.secondaryBackground,
                    shape: BoxShape.circle,
                    border: Border.all(color: olive, width: 3),
                  ),
                ),
              ),
          ]),
          // Required attribution.
          const Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('© OpenStreetMap contributors', style: TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }
}
