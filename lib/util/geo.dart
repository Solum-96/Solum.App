import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

/// Ray-casting point-in-polygon on lat/lng (fine at neighborhood scale).
bool pointInPolygon(LatLng p, List<LatLng> poly) {
  var inside = false;
  for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {
    final yi = poly[i].latitude, yj = poly[j].latitude;
    final xi = poly[i].longitude, xj = poly[j].longitude;
    if ((yi > p.latitude) != (yj > p.latitude) && p.longitude < (xj - xi) * (p.latitude - yi) / (yj - yi) + xi) {
      inside = !inside;
    }
  }
  return inside;
}

LatLng centroid(List<LatLng> pts) {
  var lat = 0.0, lng = 0.0;
  for (final p in pts) {
    lat += p.latitude;
    lng += p.longitude;
  }
  return LatLng(lat / pts.length, lng / pts.length);
}

/// Approximate ground distance in meters (equirectangular; good under ~10 km).
double metersBetween(LatLng a, LatLng b) {
  const r = 6371000.0;
  final x = (b.longitude - a.longitude) * math.pi / 180 * math.cos((a.latitude + b.latitude) * math.pi / 360);
  final y = (b.latitude - a.latitude) * math.pi / 180;
  return math.sqrt(x * x + y * y) * r;
}

/// Converts the design prototype's flat map units (1 unit ≈ 0.81 m, Sellwood
/// extract) to WGS84. Used for seed data only; see tool/gen_sellwood_data.py.
LatLng fromPrototypeUnits(double x, double y) =>
    LatLng(-7.295738461342727e-06 * y + 45.47029999690182, 1.0398961595097303e-05 * x - 122.65819767562407);
