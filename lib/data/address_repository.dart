import 'package:latlong2/latlong.dart';

import '../util/geo.dart';
import 'models.dart';
import 'sellwood_addresses.dart';

/// Street addresses: nearest-address lookup, search and "homes inside an
/// outline". The bundled implementation reads the Sellwood OSM extract.
/// Production: back this with a geocoder / address dataset (OpenAddresses,
/// Mapbox, Google Places) using a point-in-polygon query.
abstract class AddressRepository {
  /// "1579 SE Nehalem St" when within ~25 m, else "Near 1579 SE Nehalem St".
  String nearestLabel(LatLng p);

  /// Nearest address and its distance in meters, or null if none.
  (MapAddress, double)? nearest(LatLng p);

  /// Every address whose tokens all appear in [query] (case-insensitive).
  List<MapAddress> search(String query, {int limit = 6});

  /// Unique addresses inside [polygon]. Empty for fewer than 3 corners.
  List<MapAddress> inside(List<LatLng> polygon);

  /// Place name used for "Nothing matches … in {place}" and address subtitles.
  String get placeName;
}

class LocalAddressRepository implements AddressRepository {
  LocalAddressRepository([List<MapAddress>? addresses]) : _all = addresses ?? sellwoodAddresses;

  final List<MapAddress> _all;

  @override
  String get placeName => 'Sellwood, Portland';

  @override
  (MapAddress, double)? nearest(LatLng p) {
    MapAddress? best;
    var d = double.infinity;
    for (final a in _all) {
      final dd = metersBetween(p, a.point);
      if (dd < d) {
        d = dd;
        best = a;
      }
    }
    return best == null ? null : (best, d);
  }

  @override
  String nearestLabel(LatLng p) {
    final n = nearest(p);
    if (n == null) return '';
    return n.$2 < 25 ? n.$1.street : 'Near ${n.$1.street}';
  }

  @override
  List<MapAddress> search(String query, {int limit = 6}) {
    final toks = tokens(query);
    if (toks.isEmpty) return const [];
    return _all.where((a) => matchesAll(a.street, toks)).take(limit).toList();
  }

  @override
  List<MapAddress> inside(List<LatLng> polygon) {
    if (polygon.length < 3) return const [];
    return _all.where((a) => pointInPolygon(a.point, polygon)).toList();
  }
}

List<String> tokens(String q) => q.trim().toLowerCase().split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

bool matchesAll(String text, List<String> toks) {
  final t = text.toLowerCase();
  return toks.every(t.contains);
}

/// "1544 SE Miller St" → "SE Miller St".
String streetName(String address) => address.replaceFirst(RegExp(r'^\d+[A-Za-z]?\s+'), '');
