import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

/// Where a stop stands. Drives the pin, sort order and copy.
enum StopState { unvisited, visited, followUp }

/// When a follow-up is due. Rolls over at midnight: unhandled [today]
/// becomes [overdue].
enum FollowUpDue { overdue, today, week }

enum PlanTier { free, plus, pro }

enum Billing { monthly, yearly }

/// One line of a stop's visit history ("Tue · Spoke with them").
@immutable
class VisitEntry {
  const VisitEntry(this.day, this.text);

  /// Short day label: "Today", "Mon", ... Production stores a DateTime.
  final String day;
  final String text;
}

/// A contact or address the seller plans to visit. "Stop" and "contact" are
/// the same record: a stop with a name is shown as a contact.
@immutable
class Stop {
  const Stop({
    required this.id,
    required this.street,
    required this.name,
    required this.state,
    this.position,
    this.phone = '',
    this.email = '',
    this.note = '',
    this.due,
    this.when,
    this.order = 0,
    this.history = const [],
    this.statusLine,
    this.addedByUser = false,
  });

  final int id;

  /// Null = "No pin": the contact stays out of the map and carousel.
  final LatLng? position;
  final String street;

  /// Equal to [street] when the seller has not named the contact.
  final String name;
  final String phone;
  final String email;

  /// "What to say" next time.
  final String note;
  final StopState state;
  final FollowUpDue? due;

  /// Follow-up time label: "4pm", "Thu, 10am", "Sat" (overdue since).
  final String? when;

  /// Sort key inside a due bucket (hour of day for today, 100 for later).
  final int order;
  final List<VisitEntry> history;

  /// Secondary line for unnamed visited stops ("Visited Mon · not home").
  final String? statusLine;

  /// Added in this session; sorts first under "Recent".
  final bool addedByUser;

  bool get hasPin => position != null;
  bool get isNamed => name != street;
  bool get isFollowUp => state == StopState.followUp;

  /// The address line shown in lists (ContactRow).
  String get listLine {
    if (position == null) return 'No pin · $street';
    if (state == StopState.followUp) return street;
    if (isNamed) return street;
    if (state == StopState.unvisited) return 'Not visited';
    return statusLine ?? street;
  }

  Stop copyWith({
    LatLng? position,
    bool clearPosition = false,
    String? street,
    String? name,
    String? phone,
    String? email,
    String? note,
    StopState? state,
    FollowUpDue? due,
    bool clearDue = false,
    String? when,
    int? order,
    List<VisitEntry>? history,
    String? statusLine,
  }) {
    return Stop(
      id: id,
      position: clearPosition ? null : (position ?? this.position),
      street: street ?? this.street,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      note: note ?? this.note,
      state: state ?? this.state,
      due: clearDue ? null : (due ?? this.due),
      when: clearDue ? null : (when ?? this.when),
      order: order ?? this.order,
      history: history ?? this.history,
      statusLine: statusLine ?? this.statusLine,
      addedByUser: addedByUser,
    );
  }
}

/// An outlined territory.
@immutable
class Area {
  const Area({required this.id, required this.name, required this.polygon, this.isSample = false});

  final String id;
  final String name;
  final List<LatLng> polygon;

  /// The first-run walkthrough's sample area; replaced by the seller's own.
  final bool isSample;

  Area copyWith({String? name, bool? isSample}) =>
      Area(id: id, name: name ?? this.name, polygon: polygon, isSample: isSample ?? this.isSample);
}

/// A street address from the map's address dataset.
@immutable
class MapAddress {
  const MapAddress(this.street, this.lat, this.lng);

  final String street;
  final double lat;
  final double lng;

  LatLng get point => LatLng(lat, lng);
}

/// A paid or free plan as shown on the paywall.
/// Prices and limits are proposals pending business sign-off.
@immutable
class PlanOffer {
  const PlanOffer({
    required this.tier,
    required this.name,
    required this.description,
    this.monthly = 0,
    this.yearly = 0,
    this.popular = false,
  });

  final PlanTier tier;
  final String name;
  final String description;
  final int monthly;
  final int yearly;
  final bool popular;

  static const all = [
    PlanOffer(
      tier: PlanTier.pro,
      name: 'Pro',
      monthly: 16,
      yearly: 144,
      description: 'Unlimited areas and contacts, custom automations, CSV export.',
    ),
    PlanOffer(
      tier: PlanTier.plus,
      name: 'Plus',
      monthly: 8,
      yearly: 72,
      popular: true,
      description: '5 areas, 500 contacts, coverage history, every automation.',
    ),
    PlanOffer(tier: PlanTier.free, name: 'Free', description: '1 area, up to 50 contacts, 1 automation.'),
  ];
}

/// Plan limits. Free: 1 area / 50 contacts / 1 automation.
abstract final class PlanLimits {
  static const freeContacts = 50;
  static const plusContacts = 500;
  static const plusAreas = 5;

  static int? areas(PlanTier t) => switch (t) { PlanTier.free => 1, PlanTier.plus => plusAreas, PlanTier.pro => null };
  static int? contacts(PlanTier t) =>
      switch (t) { PlanTier.free => freeContacts, PlanTier.plus => plusContacts, PlanTier.pro => null };
}
