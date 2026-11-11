// FlutterFlow → Custom Code → Custom Functions.
// Paste each function into its own Custom Function (same name, same
// arguments). Custom functions must be pure: no packages beyond dart:math and
// FlutterFlow's generated types. Mirrors lib/state/solum_store.dart.
//
// Argument types in FlutterFlow:
//   LatLng = FlutterFlow's built-in LatLng (latitude / longitude).
//   StopStruct = the "Stop" Data Type from flutterflow/schema.md.

import 'dart:math' as math;

import '/flutter_flow/lat_lng.dart';
// import '/backend/schema/structs/index.dart'; // FlutterFlow adds this for StopStruct.

/// Ray-casting point-in-polygon. Used for coverage and "homes inside".
bool pointInPolygon(LatLng point, List<LatLng> polygon) {
  var inside = false;
  for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final yi = polygon[i].latitude, yj = polygon[j].latitude;
    final xi = polygon[i].longitude, xj = polygon[j].longitude;
    if ((yi > point.latitude) != (yj > point.latitude) &&
        point.longitude < (xj - xi) * (point.latitude - yi) / (yj - yi) + xi) {
      inside = !inside;
    }
  }
  return inside;
}

/// Sort key: overdue -1, today by hour, later 50+, not visited 500, visited 900.
int stopRank(String state, String? due, int order) {
  if (state == 'followUp') {
    if (due == 'overdue') return -1;
    if (due == 'today') return order;
    return 50 + order;
  }
  return state == 'unvisited' ? 500 : 900;
}

/// "37 of 43 visited" — count of stops inside [area] that are not unvisited.
int visitedInArea(List<StopStruct> stops, List<LatLng> area) => stops
    .where((s) => s.hasLocation() && pointInPolygon(s.location!, area) && s.state != 'unvisited')
    .length;

int totalInArea(List<StopStruct> stops, List<LatLng> area) =>
    stops.where((s) => s.hasLocation() && pointInPolygon(s.location!, area)).length;

/// Stop cards for the map carousel: filter, hide visited under "All", sort by rank.
List<StopStruct> stopCards(List<StopStruct> stops, String filter) {
  final l = stops.where((s) {
    if (!s.hasLocation()) return false;
    if (filter == 'followUps') return s.state == 'followUp';
    if (filter == 'notVisited') return s.state == 'unvisited';
    return s.state != 'visited';
  }).toList();
  l.sort((a, b) => stopRank(a.state, a.due, a.order) - stopRank(b.state, b.due, b.order));
  return l;
}

/// Badge text: "Overdue", "4pm", "Thu, 10am" or null.
String? followUpBadge(String state, String? due, String? when) =>
    state != 'followUp' ? null : (due == 'overdue' ? 'Overdue' : when);

/// Contact page status badge.
String statusLabel(String state, String? due, String? when) {
  if (state == 'followUp') {
    if (due == 'overdue') return 'Overdue since $when';
    if (due == 'today') return 'Today, $when';
    return when ?? '';
  }
  return state == 'visited' ? 'Visited' : 'Not visited';
}

/// Follow-up sheet CTA: "Set for tomorrow, 5pm".
String followUpCta(String day, String time) => 'Set for ${day.toLowerCase()}, $time';

/// "3 people to see today" / "No one left to see today".
String todayHeadline(int count) =>
    count == 0 ? 'No one left to see today' : '$count ${count == 1 ? 'person' : 'people'} to see today';

/// Paywall footnote.
String paywallFootnote(String tier, bool yearly) {
  if (tier == 'free') return 'You can upgrade anytime in Settings.';
  final price = {'plus': yearly ? 72 : 8, 'pro': yearly ? 144 : 16}[tier];
  return 'Free for 14 days, then \$$price a ${yearly ? 'year' : 'month'}. Cancel anytime.';
}

/// Ground distance in meters (for "nearest address within 25 m").
double metersBetween(LatLng a, LatLng b) {
  final x = (b.longitude - a.longitude) * math.pi / 180 * math.cos((a.latitude + b.latitude) * math.pi / 360);
  final y = (b.latitude - a.latitude) * math.pi / 180;
  return math.sqrt(x * x + y * y) * 6371000;
}
