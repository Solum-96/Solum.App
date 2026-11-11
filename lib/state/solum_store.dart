import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../data/address_repository.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../services/services.dart';
import '../theme/solum_theme.dart';
import '../util/geo.dart';

enum OnboardingStep { welcome, how, location, auth, plans, done }

enum AuthMode { signUp, signIn }

enum AppTab { map, followUps, contacts, settings }

enum SheetKind { logVisit, followUp, newContact, addByAddress, editContact, nameArea, areas, limit }

enum MapFilter { all, followUps, notVisited }

enum ContactSort { status, az, recent }

enum LimitKind { contacts, area }

enum PaywallContext { standard, contacts, area, automation }

/// Camera request for the map. [force] pans even when the point is on screen.
/// [screenY] places the point at that y (logical px from the top) instead of
/// the default upper-middle of the map.
@immutable
class PanRequest {
  const PanRequest(this.target, {this.force = false, this.screenY});
  final LatLng target;
  final bool force;
  final double? screenY;
}

/// Picked from search or a visited pin: shown as a single result card.
@immutable
class MapResult {
  const MapResult.stop(int this.stopId, this.point) : label = null;
  const MapResult.address(String this.label, this.point) : stopId = null;
  final int? stopId;
  final String? label;
  final LatLng point;
  bool get isStop => stopId != null;
}

@immutable
class ToastMessage {
  const ToastMessage(this.text, {this.undo = false, required this.serial});
  final String text;
  final bool undo;
  final int serial;
}

/// Log visit sheet form.
class LogForm {
  String outcome = 'Spoke with them';
  String note = '';
  bool flyer = true;
  bool followAfter = false;
  bool retry = true;
  static const outcomes = ['Spoke with them', 'Not home', 'Not interested', 'Sale'];
}

/// Follow up sheet form.
class FollowForm {
  String day = 'Tomorrow';
  String time = '5pm';
  String note = '';
  bool remind = true;
  static const days = ['Today', 'Tomorrow', 'Next week'];
  static const times = ['9am', '12pm', '5pm', '7pm'];
}

/// New contact sheet (from a dropped pin or a search result).
class AddForm {
  String name = '';
  String address = '';
  String phone = '';
  StopState status = StopState.unvisited;
  bool touched = false;
}

enum ManualPin { here, none }

/// Add by address sheet.
class ManualForm {
  String name = '';
  String address = '';
  String phone = '';
  ManualPin pin = ManualPin.here;
  MapAddress? snap;
  bool touched = false;
}

/// Edit contact sheet.
class EditForm {
  EditForm(Stop s)
      : id = s.id,
        name = s.isNamed ? s.name : '',
        street = s.street,
        phone = s.phone,
        email = s.email,
        note = s.note;
  final int id;
  String name, street, phone, email, note;
  MapAddress? snap;
}

/// The whole app state and its actions, in one ChangeNotifier.
///
/// Mirrors the logic class of the design prototype
/// (docs/design/prototype/Solum App v2.dc.html) so behavior can be checked
/// against it line by line. Persistence is in-memory for now; swap the stop
/// and area lists for a repository (Drift/Isar or Supabase) without changing
/// the widgets.
class SolumStore extends ChangeNotifier {
  SolumStore({
    AddressRepository? addresses,
    AuthService? auth,
    PurchaseService? purchases,
    LocationService? location,
    DateTime? now,
    String? start,
  })  : addresses = addresses ?? LocalAddressRepository(),
        auth = auth ?? DemoAuthService(),
        purchases = purchases ?? DemoPurchaseService(),
        location = location ?? DemoLocationService(Seed.me),
        now = now ?? DateTime.now() {
    _reset();
    if (start != null && start.isNotEmpty) applyStart(start);
  }

  final AddressRepository addresses;
  final AuthService auth;
  final PurchaseService purchases;
  final LocationService location;
  final DateTime now;

  // ---------------------------------------------------------------- state
  OnboardingStep step = OnboardingStep.welcome;
  AuthMode authMode = AuthMode.signUp;
  SolumUser user = const SolumUser(name: 'Dana Ortiz', email: 'dana.ortiz@mail.com');
  AppTab tab = AppTab.map;
  ThemeMode themeMode = ThemeMode.system;

  List<Stop> stops = [];
  List<Area> areas = [];
  String activeAreaId = '';
  LatLng me = Seed.me;

  int? selectedId;
  MapFilter filter = MapFilter.all;
  MapResult? result;

  SheetKind? sheet;
  int? sheetStopId;
  LimitKind limitKind = LimitKind.contacts;

  int? contactId;
  bool contactOpen = false;

  bool paywallOpen = false;
  PaywallContext paywallContext = PaywallContext.standard;
  PlanTier plan = PlanTier.free;
  PlanTier planChoice = PlanTier.plus;
  Billing billing = Billing.yearly;
  DateTime? trialEndsAt;

  bool addMode = false;
  LatLng? newPin;
  bool outlining = false;
  List<LatLng> draft = [];
  String areaName = '';
  bool areaNameTouched = false;

  bool searchOpen = false;
  String query = '';
  String contactSearch = '';
  ContactSort sort = ContactSort.status;

  /// Address waiting for "Apple Maps / Google Maps".
  String? directionsTarget;

  bool autoRetry = true, autoText = false, autoWeekly = false;
  bool morningReminder = true;

  /// Walkthrough step: 0 off, 1 tap a gold pin, 2 log a visit,
  /// 3 outline your own, 4 drawing during the tour.
  int tour = 0;
  bool get sample => areas.any((a) => a.isSample);

  LogForm log = LogForm();
  FollowForm follow = FollowForm();
  AddForm add = AddForm();
  ManualForm manual = ManualForm();
  EditForm? edit;

  ToastMessage? toast;
  int _toastSerial = 0;
  Timer? _toastTimer;
  List<Stop>? _undoStops;

  final _pan = StreamController<PanRequest>.broadcast();
  final _cardScroll = StreamController<int>.broadcast();

  /// Map camera requests (consumed by SolumMap).
  Stream<PanRequest> get panRequests => _pan.stream;

  /// Carousel index requests after a pin tap (consumed by StopCardCarousel).
  Stream<int> get cardScrollRequests => _cardScroll.stream;

  /// Where the map starts.
  LatLng initialCenter = Seed.center;
  double? initialScreenY;

  void _reset() {
    step = OnboardingStep.welcome;
    authMode = AuthMode.signUp;
    tab = AppTab.map;
    stops = Seed.stops();
    areas = [Seed.sellwood];
    activeAreaId = Seed.sellwood.id;
    selectedId = null;
    filter = MapFilter.all;
    result = null;
    sheet = null;
    contactOpen = false;
    contactId = null;
    paywallOpen = false;
    plan = PlanTier.free;
    planChoice = PlanTier.plus;
    billing = Billing.yearly;
    addMode = false;
    newPin = null;
    outlining = false;
    draft = [];
    searchOpen = false;
    query = '';
    contactSearch = '';
    sort = ContactSort.status;
    directionsTarget = null;
    tour = 0;
    initialCenter = Seed.center;
    initialScreenY = null;
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    _pan.close();
    _cardScroll.close();
    super.dispose();
  }

  void _set(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  // ------------------------------------------------------------ derived
  Area get activeArea => areas.firstWhere((a) => a.id == activeAreaId, orElse: () => areas.first);
  bool get hasActiveArea => areas.isNotEmpty;

  bool inArea(Stop s, [Area? a]) => s.position != null && pointInPolygon(s.position!, (a ?? activeArea).polygon);
  int visitedIn([Area? a, List<Stop>? list]) =>
      (list ?? stops).where((s) => inArea(s, a) && s.state != StopState.unvisited).length;
  int totalIn([Area? a, List<Stop>? list]) => (list ?? stops).where((s) => inArea(s, a)).length;
  bool isComplete([List<Stop>? list]) {
    final t = totalIn(null, list);
    return t > 0 && visitedIn(null, list) == t;
  }

  Stop? stopById(int? id) {
    if (id == null) return null;
    for (final s in stops) {
      if (s.id == id) return s;
    }
    return null;
  }

  static int rank(Stop s) => switch (s.state) {
        StopState.followUp => switch (s.due) {
            FollowUpDue.overdue => -1,
            FollowUpDue.today => s.order,
            _ => 50 + s.order,
          },
        StopState.unvisited => 500,
        StopState.visited => 900,
      };

  static const _daysAgo = {'Today': 0, 'Mon': 1, 'Sun': 2, 'Sat': 3, 'Fri': 4, 'Thu': 5, 'Wed': 6, 'Tue': 7};
  static int recency(Stop s) => s.addedByUser
      ? -1
      : s.history.isNotEmpty
          ? (_daysAgo[s.history.first.day] ?? 8)
          : 99;

  List<Stop> get todayList =>
      stops.where((s) => s.isFollowUp && s.due == FollowUpDue.today).toList()..sort((a, b) => a.order - b.order);
  List<Stop> get weekList => stops.where((s) => s.isFollowUp && s.due == FollowUpDue.week).toList();
  List<Stop> get overdueList => stops.where((s) => s.isFollowUp && s.due == FollowUpDue.overdue).toList();
  int get openFollowUps => stops.where((s) => s.isFollowUp).length;

  /// Follow-ups tab badge: today + overdue.
  int get followUpBadge => todayList.length + overdueList.length;

  int filterCount(MapFilter f) => switch (f) {
        MapFilter.all => stops.length,
        MapFilter.followUps => stops.where((s) => s.state == StopState.followUp).length,
        MapFilter.notVisited => stops.where((s) => s.state == StopState.unvisited).length,
      };

  bool _passes(Stop s) => switch (filter) {
        MapFilter.all => true,
        MapFilter.followUps => s.state == StopState.followUp,
        MapFilter.notVisited => s.state == StopState.unvisited,
      };

  /// Pins on the map for the current filter.
  List<Stop> get mapStops => stops.where((s) => s.hasPin && _passes(s)).toList();

  /// Stop cards: overdue, today by time, later, not visited. Visited stops are
  /// hidden under "All".
  List<Stop> get cards {
    final l = stops
        .where((s) => s.hasPin && _passes(s) && (s.state != StopState.visited || filter != MapFilter.all))
        .toList();
    l.sort((a, b) => rank(a) - rank(b));
    return l;
  }

  /// The card and pin shown as selected.
  int? get highlightedId {
    if (result?.stopId != null) return result!.stopId;
    final c = cards;
    if (selectedId != null && stopById(selectedId) != null) return selectedId;
    return c.isEmpty ? null : c.first.id;
  }

  List<Stop> get contactsSorted {
    final q = contactSearch.trim().toLowerCase();
    final l = stops.toList()..sort(_sorter(sort));
    return q.isEmpty ? l : l.where((s) => '${s.name} ${s.street}'.toLowerCase().contains(q)).toList();
  }

  static Comparator<Stop> _sorter(ContactSort s) => switch (s) {
        ContactSort.status => (a, b) => rank(a) - rank(b),
        ContactSort.az => (a, b) => compareNatural(a.name, b.name),
        ContactSort.recent => (a, b) {
            final r = recency(a) - recency(b);
            return r != 0 ? r : rank(a) - rank(b);
          },
      };

  String get contactsLabel => contactSearch.trim().isNotEmpty
      ? '${contactsSorted.length} matching'
      : '${stops.length} contacts${plan == PlanTier.free ? ' · ${PlanLimits.freeContacts} on Free' : ''}';

  List<Stop> searchStops() {
    final t = tokens(query);
    if (t.isEmpty) return const [];
    final sorted = stops.toList()..sort((a, b) => rank(a) - rank(b));
    return sorted.where((s) => matchesAll('${s.name} ${s.street}', t)).take(5).toList();
  }

  List<MapAddress> searchAddresses() {
    final known = stops.map((s) => s.street).toSet();
    return addresses.search(query, limit: 400).where((a) => !known.contains(a.street)).take(6).toList();
  }

  List<MapAddress> suggestionsFor(String text, {bool skip = false, bool excludeExact = false}) {
    final t = text.trim().toLowerCase();
    if (skip || t.length < 3) return const [];
    return addresses
        .search(text, limit: 20)
        .where((a) => !excludeExact || a.street.toLowerCase() != t)
        .take(3)
        .toList();
  }

  List<MapAddress> get draftHomes {
    final seen = <String>{};
    return addresses.inside(draft).where((a) => seen.add(a.street)).toList();
  }

  int get draftNewCount {
    if (sample) return draftHomes.length;
    final known = stops.map((s) => s.street).toSet();
    return draftHomes.where((a) => !known.contains(a.street)).length;
  }

  bool get atContactLimit => plan == PlanTier.free && stops.length >= PlanLimits.freeContacts;

  String get todayLabel {
    const wd = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const mo = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${wd[now.weekday - 1]}, ${mo[now.month - 1]} ${now.day}';
  }

  String get trialEndLabel {
    final d = trialEndsAt ?? now.add(const Duration(days: 14));
    const mo = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${mo[d.month - 1]} ${d.day}';
  }

  static String dueLabel(Stop s) => switch (s.due) {
        FollowUpDue.overdue => 'Overdue since ${s.when}',
        FollowUpDue.today => 'Today, ${s.when}',
        _ => s.when ?? '',
      };

  /// Badge text on cards and rows.
  static String? badgeText(Stop s) => s.isFollowUp ? (s.due == FollowUpDue.overdue ? 'Overdue' : s.when) : null;

  // ------------------------------------------------------------- toasts
  void showToast(String text, {bool undo = false}) {
    _toastTimer?.cancel();
    toast = ToastMessage(text, undo: undo, serial: ++_toastSerial);
    _toastTimer = Timer(SolumMotion.toast, () => _set(() => toast = null));
    notifyListeners();
  }

  void dismissToast() => _set(() => toast = null);

  void undo() {
    if (_undoStops != null) stops = _undoStops!;
    _undoStops = null;
    toast = null;
    notifyListeners();
  }

  void _snapshot() => _undoStops = stops;

  void _updateStop(int id, Stop Function(Stop) fn) {
    _snapshot();
    stops = [for (final s in stops) s.id == id ? fn(s) : s];
  }

  void _panTo(LatLng p, {bool force = false, double? screenY}) =>
      _pan.add(PanRequest(p, force: force, screenY: screenY));

  // --------------------------------------------------------- onboarding
  void goTo(OnboardingStep s) => _set(() => step = s);
  void startSignUp() => _set(() {
        step = OnboardingStep.auth;
        authMode = AuthMode.signUp;
      });
  void startSignIn() => _set(() {
        step = OnboardingStep.auth;
        authMode = AuthMode.signIn;
      });
  void authBack() => goTo(authMode == AuthMode.signIn ? OnboardingStep.welcome : OnboardingStep.location);

  Future<void> allowLocation() async {
    final ok = await location.requestPermission();
    if (ok) me = await location.current();
    startSignUp();
  }

  Future<void> signInWith(AuthProvider p) async {
    user = await auth.signIn(p);
    if (authMode == AuthMode.signIn) {
      _set(() => step = OnboardingStep.done);
      showToast('Welcome back, ${user.firstName}');
    } else {
      _set(() {
        step = OnboardingStep.plans;
        planChoice = PlanTier.plus;
        paywallContext = PaywallContext.standard;
      });
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    final mode = themeMode;
    _reset();
    themeMode = mode;
    notifyListeners();
  }

  // ------------------------------------------------------------ paywall
  bool get showPaywall => step == OnboardingStep.plans || paywallOpen;

  void openPaywall([PaywallContext ctx = PaywallContext.standard]) => _set(() {
        paywallOpen = true;
        planChoice = PlanTier.plus;
        paywallContext = ctx;
      });

  void choosePlan(PlanTier t) => _set(() => planChoice = t);
  void setBilling(Billing b) => _set(() => billing = b);

  Future<void> endPaywall({required bool startTrial}) async {
    final onboarding = step == OnboardingStep.plans;
    final ctx = paywallContext;
    if (startTrial && planChoice != PlanTier.free) {
      trialEndsAt = await purchases.startTrial(planChoice, billing);
    }
    final newPlan = startTrial ? planChoice : plan;
    _set(() {
      step = OnboardingStep.done;
      paywallOpen = false;
      plan = newPlan;
      if (onboarding) _startTour();
    });
    if (startTrial && planChoice != PlanTier.free) {
      showToast('${planChoice == PlanTier.plus ? 'Plus' : 'Pro'} trial started · ends $trialEndLabel');
    } else if (onboarding) {
      showToast('Welcome to Solum, ${user.firstName}');
    }
    if (startTrial && ctx == PaywallContext.contacts) {
      _set(() {
        tab = AppTab.map;
        addMode = true;
        newPin = null;
        selectedId = null;
      });
    }
    if (startTrial && ctx == PaywallContext.area) {
      _set(() {
        tab = AppTab.map;
        outlining = true;
        draft = [];
        selectedId = null;
      });
    }
  }

  String get paywallCtaLabel => planChoice != PlanTier.free ? 'Start 14-day free trial' : 'Continue with Free';
  String get paywallFootnote {
    if (planChoice == PlanTier.free) return 'You can upgrade anytime in Settings.';
    final o = PlanOffer.all.firstWhere((p) => p.tier == planChoice);
    return billing == Billing.yearly
        ? 'Free for 14 days, then \$${o.yearly} a year. Cancel anytime.'
        : 'Free for 14 days, then \$${o.monthly} a month. Cancel anytime.';
  }

  static (String, String) paywallCopy(PaywallContext c) => switch (c) {
        PaywallContext.contacts => ('Keep adding contacts', 'Your 50 contacts stay put. Plus makes room for 500.'),
        PaywallContext.area => ('Outline your next area', 'Plus covers 5 areas. Pro covers as many as you need.'),
        PaywallContext.automation => (
            'Let Solum do the reminding',
            'Free includes one automation. Plus and Pro unlock the rest.'
          ),
        PaywallContext.standard => ('Cover more ground', 'Start free. Upgrade when one area is not enough.'),
      };

  // --------------------------------------------------------------- tour
  void _startTour() {
    final sampleArea = Seed.sellwood.copyWith(name: 'Sample area', isSample: true);
    tab = AppTab.map;
    tour = 1;
    areas = [sampleArea];
    activeAreaId = sampleArea.id;
    filter = MapFilter.all;
    selectedId = null;
    stops = Seed.stops().where((s) => s.position != null && pointInPolygon(s.position!, sampleArea.polygon)).toList();
    initialCenter = fromPrototypeUnits(800, 371);
    initialScreenY = 470;
    _panTo(initialCenter, force: true, screenY: 470);
  }

  void skipTour() => _set(() => tour = 0);

  /// The pulsing gold pin in tour step 1.
  Stop? get coachPin {
    if (tour != 1) return null;
    for (final s in todayList) {
      if (s.hasPin && inArea(s)) return s;
    }
    return null;
  }

  static const coachCopy = {
    1: (
      'Sample area · 1 of 3',
      'Tap a gold pin',
      'Gold pins are people to see. This sample area shows how Solum works before you add your own.'
    ),
    2: (
      'Sample area · 2 of 3',
      'Log a visit',
      'Tap Log visit on the card below. Pick what happened and save. The pin turns olive.'
    ),
    3: (
      'Sample area · 3 of 3',
      'Now outline your own',
      'Tap the corners of the streets you plan to cover. Solum fills in every home inside and clears this sample.'
    ),
  };

  // ----------------------------------------------------------- navigation
  void setTab(AppTab t) => _set(() {
        tab = t;
        addMode = false;
        outlining = false;
        draft = [];
        contactOpen = false;
        searchOpen = false;
      });

  void setThemeMode(ThemeMode m) => _set(() => themeMode = m);

  void openContact(int id) => _set(() {
        contactId = id;
        contactOpen = true;
      });
  void closeContact() => _set(() => contactOpen = false);

  // ---------------------------------------------------------------- map
  void setFilter(MapFilter f) => _set(() {
        filter = f;
        selectedId = null;
        result = null;
      });

  /// Swiping the carousel to [index].
  void onCardSettled(int index) {
    final c = cards;
    if (index < 0 || index >= c.length) return;
    final s = c[index];
    if (s.id == selectedId) return;
    _set(() => selectedId = s.id);
    _panTo(s.position!);
  }

  /// Tapping a stop card or a pin.
  void select(int id) {
    final s = stopById(id);
    _set(() {
      selectedId = id;
      result = null;
      if (tour == 1) tour = 2;
    });
    if (s?.position != null) _panTo(s!.position!);
    final idx = cards.indexWhere((c) => c.id == id);
    if (idx >= 0) _cardScroll.add(idx);
  }

  void tapPin(int id) {
    if (addMode) return;
    final s = stopById(id);
    if (s == null) return;
    if (s.state == StopState.visited && filter == MapFilter.all) {
      _set(() {
        result = MapResult.stop(id, s.position!);
        selectedId = id;
      });
      return;
    }
    select(id);
  }

  void tapMap(LatLng p) {
    if (outlining) {
      _set(() => draft = [...draft, p]);
    } else if (addMode) {
      _set(() => newPin = p);
    }
  }

  void centerOnMe() => _panTo(me, force: true);
  void clearResult() => _set(() => result = null);

  // ------------------------------------------------------------- search
  void openSearch() => _set(() {
        searchOpen = true;
        query = '';
      });
  void closeSearch() => _set(() {
        searchOpen = false;
        query = '';
      });
  void setQuery(String q) => _set(() => query = q);

  void pickStop(int id) {
    final s = stopById(id);
    if (s == null) return;
    if (s.position == null) {
      _set(() {
        searchOpen = false;
        query = '';
      });
      openContact(id);
      return;
    }
    _set(() {
      searchOpen = false;
      query = '';
      filter = MapFilter.all;
      selectedId = id;
      result = MapResult.stop(id, s.position!);
    });
    _panTo(s.position!, force: true);
  }

  void pickAddress(MapAddress a) {
    _set(() {
      searchOpen = false;
      query = '';
      selectedId = null;
      result = MapResult.address(a.street, a.point);
    });
    _panTo(a.point, force: true);
  }

  // --------------------------------------------------------- directions
  void askDirections(String address) => _set(() => directionsTarget = address);
  void closeDirections() => _set(() => directionsTarget = null);

  Future<void> openDirections(MapsApp app, {bool android = false}) async {
    final target = directionsTarget;
    _set(() => directionsTarget = null);
    if (target == null) return;
    showToast(app == MapsApp.apple ? 'Opening Apple Maps' : 'Opening Google Maps');
    await Directions.open(app, '$target, Portland, OR', android: android);
  }

  // ------------------------------------------------------------- sheets
  void closeSheet() => _set(() => sheet = null);

  void openLog(int id) => _set(() {
        sheet = SheetKind.logVisit;
        sheetStopId = id;
        log = LogForm()..retry = autoRetry;
      });

  void openFollow(int id) => _set(() {
        final s = stopById(id);
        sheet = SheetKind.followUp;
        sheetStopId = id;
        follow = FollowForm()..note = s?.note ?? '';
      });

  void openLimit(LimitKind k) => _set(() {
        sheet = SheetKind.limit;
        limitKind = k;
        addMode = false;
      });

  void seePlans() {
    final ctx = limitKind == LimitKind.area ? PaywallContext.area : PaywallContext.contacts;
    _set(() => sheet = null);
    openPaywall(ctx);
  }

  /// Rebuild after a form field changes.
  void touch() => notifyListeners();

  String get sheetTitle {
    final s = stopById(sheetStopId);
    return switch (sheet) {
      SheetKind.editContact => 'Edit contact',
      SheetKind.nameArea => 'Name this area',
      SheetKind.areas => 'Your areas',
      SheetKind.addByAddress => 'Add by address',
      SheetKind.newContact => 'New contact',
      SheetKind.limit => limitKind == LimitKind.area ? 'Free covers one area' : 'You have 50 contacts',
      SheetKind.logVisit => 'Log visit${s != null ? ' · ${s.name}' : ''}',
      SheetKind.followUp => 'Follow up${s != null ? ' · ${s.name}' : ''}',
      null => '',
    };
  }

  // ---------------------------------------------------------- log visit
  void saveLog() {
    final id = sheetStopId;
    final s = stopById(id);
    if (s == null) return;
    final l = log;
    final wasComplete = isComplete();
    final retry = l.outcome == 'Not home' && l.retry;
    final text = l.outcome + (l.flyer ? ' · left a flyer' : '') + (l.note.isNotEmpty ? ' · ${l.note}' : '');
    final history = [VisitEntry('Today', text), ...s.history];
    final next = retry
        ? s.copyWith(
            state: StopState.followUp,
            due: FollowUpDue.week,
            when: 'Fri, 5pm',
            order: 100,
            note: l.note.isNotEmpty ? l.note : 'Not home last time. Try again.',
            history: history)
        : s.copyWith(
            state: StopState.visited,
            clearDue: true,
            statusLine: 'Visited today · ${l.outcome.toLowerCase()}',
            history: history);
    _updateStop(s.id, (_) => next);
    selectedId = null;
    if (tour == 2) tour = 3;
    if (l.followAfter && !retry) {
      sheet = SheetKind.followUp;
      follow = FollowForm()..note = l.note;
    } else {
      sheet = null;
    }
    notifyListeners();
    if (!wasComplete && isComplete()) {
      showToast('${activeArea.name} is complete. Good ground covered.', undo: true);
    } else if (retry) {
      showToast('Visit logged · retry set for Friday', undo: true);
    } else {
      showToast('Visit logged · ${visitedIn()} of ${totalIn()}', undo: true);
    }
  }

  // ---------------------------------------------------------- follow up
  String get followCta => 'Set for ${follow.day.toLowerCase()}, ${follow.time}';

  void saveFollow() {
    final id = sheetStopId;
    if (id == null) return;
    final f = follow;
    final today = f.day == 'Today';
    final when = today ? f.time : '${f.day}, ${f.time}';
    final hour = int.parse(f.time.replaceAll(RegExp(r'\D'), ''));
    final order = today ? hour + (f.time.contains('pm') && hour != 12 ? 12 : 0) : 100;
    _updateStop(
        id,
        (s) => s.copyWith(
            state: StopState.followUp,
            due: today ? FollowUpDue.today : FollowUpDue.week,
            when: when,
            order: order,
            note: f.note.isNotEmpty ? f.note : s.note));
    sheet = null;
    notifyListeners();
    showToast('Follow-up set · ${today ? 'Today, ${f.time}' : when}', undo: true);
  }

  // -------------------------------------------------------- add contact
  void startAdd() {
    if (atContactLimit) {
      _set(() {
        tab = AppTab.map;
        searchOpen = false;
      });
      openLimit(LimitKind.contacts);
      return;
    }
    _set(() {
      tab = AppTab.map;
      addMode = true;
      newPin = null;
      selectedId = null;
      result = null;
      searchOpen = false;
      contactOpen = false;
    });
  }

  void cancelAdd() => _set(() {
        addMode = false;
        newPin = null;
      });

  String get addModeHint => newPin != null ? addresses.nearestLabel(newPin!) : 'Tap the map where the stop is';

  void confirmPin() {
    if (newPin == null) return;
    _set(() {
      addMode = false;
      add = AddForm()..address = addresses.nearestLabel(newPin!);
      sheet = SheetKind.newContact;
      sheetStopId = null;
    });
  }

  void addFromResult() {
    final r = result;
    if (r == null || r.isStop) return;
    if (atContactLimit) {
      openLimit(LimitKind.contacts);
      return;
    }
    _set(() {
      newPin = r.point;
      add = AddForm()..address = r.label!;
      sheet = SheetKind.newContact;
      sheetStopId = null;
    });
  }

  int _newId() => DateTime.now().microsecondsSinceEpoch;

  void saveAdd() {
    final a = add;
    if (a.name.trim().isEmpty) {
      _set(() => a.touched = true);
      return;
    }
    final pos = newPin ?? Seed.center;
    final street = a.address.isNotEmpty ? a.address : addresses.nearestLabel(pos);
    final s = Stop(
      id: _newId(),
      position: pos,
      street: street,
      name: a.name.trim(),
      phone: a.phone,
      state: a.status,
      history: a.status == StopState.visited ? const [VisitEntry('Today', 'Visited')] : const [],
      addedByUser: true,
    );
    final n = stops.length + 1;
    _snapshot();
    _set(() {
      stops = [...stops, s];
      addMode = false;
      newPin = null;
      result = null;
      selectedId = s.id;
      tab = AppTab.map;
      sheet = null;
    });
    showToast(
        plan == PlanTier.free && n >= PlanLimits.freeContacts - 1
            ? 'Contact added · $n of 50 on Free'
            : 'Contact added · ${s.name}',
        undo: true);
  }

  void openManual() {
    if (atContactLimit) {
      openLimit(LimitKind.contacts);
      return;
    }
    _set(() {
      addMode = false;
      newPin = null;
      manual = ManualForm();
      sheet = SheetKind.addByAddress;
    });
  }

  List<MapAddress> get manualSuggestions => manual.snap == null ? suggestionsFor(manual.address) : const [];

  void saveManual() {
    final m = manual;
    if (m.name.trim().isEmpty || m.address.trim().isEmpty) {
      _set(() => m.touched = true);
      return;
    }
    final LatLng? pos =
        m.snap?.point ?? (m.pin == ManualPin.here ? LatLng(me.latitude - 0.00004, me.longitude + 0.00006) : null);
    final s = Stop(
      id: _newId(),
      position: pos,
      street: m.address.trim(),
      name: m.name.trim(),
      phone: m.phone,
      state: StopState.unvisited,
      addedByUser: true,
    );
    _snapshot();
    _set(() {
      stops = [...stops, s];
      selectedId = pos == null ? null : s.id;
      sheet = null;
    });
    if (pos != null && tab == AppTab.map) _panTo(pos);
    showToast('Contact added · ${s.name}${pos == null ? ' · no pin' : ''}', undo: true);
  }

  // ------------------------------------------------------- edit contact
  void openEdit(int id) {
    final s = stopById(id);
    if (s == null) return;
    _set(() {
      edit = EditForm(s);
      sheet = SheetKind.editContact;
    });
  }

  List<MapAddress> get editSuggestions =>
      edit == null ? const [] : suggestionsFor(edit!.street, skip: edit!.snap != null, excludeExact: true);

  void saveEdit() {
    final e = edit;
    if (e == null) return;
    final street = e.street.trim();
    if (street.isEmpty) return;
    _updateStop(
        e.id,
        (s) => s.copyWith(
              name: e.name.trim().isEmpty ? street : e.name.trim(),
              street: street,
              phone: e.phone.trim(),
              email: e.email.trim(),
              note: e.note.trim(),
              position: e.snap?.point,
            ));
    sheet = null;
    notifyListeners();
    showToast(e.snap != null ? 'Saved · pin moved to $street' : 'Changes saved', undo: true);
  }

  // -------------------------------------------------------------- areas
  void openAreas() => _set(() => sheet = SheetKind.areas);

  void startOutline() {
    if (plan == PlanTier.free && !sample) {
      openLimit(LimitKind.area);
      return;
    }
    if (plan == PlanTier.plus && areas.length >= PlanLimits.plusAreas) {
      showToast('Plus covers 5 areas. Pro covers as many as you need.');
      return;
    }
    _set(() {
      sheet = null;
      tab = AppTab.map;
      outlining = true;
      draft = [];
      addMode = false;
      result = null;
      searchOpen = false;
      contactOpen = false;
      selectedId = null;
      tour = tour > 0 ? 4 : 0;
    });
  }

  void cancelOutline() => _set(() {
        outlining = false;
        draft = [];
        if (tour == 4) tour = 3;
      });

  void undoCorner() {
    if (draft.isEmpty) return;
    _set(() => draft = draft.sublist(0, draft.length - 1));
  }

  String get outlineHint => draft.length < 3
      ? 'Tap the corners of the streets you will cover${draft.isNotEmpty ? ' · ${draft.length} of 3' : ''}'
      : '${draftHomes.length} homes inside · tap to add corners';

  void finishOutline() {
    if (draft.length < 3) return;
    final c = centroid(draft);
    final n = addresses.nearest(c);
    _set(() {
      outlining = false;
      sheet = SheetKind.nameArea;
      areaName = n != null ? streetName(n.$1.street) : 'Area ${areas.length + 1}';
      areaNameTouched = false;
    });
  }

  void redrawArea() => _set(() {
        sheet = null;
        outlining = true;
        draft = [];
      });

  String get draftHomesLine {
    final total = draftHomes.length, fresh = draftNewCount;
    return '$fresh new stops will be added. ${total - fresh > 0 ? '${total - fresh} are already in your contacts.' : 'Every pin starts as not visited.'}';
  }

  void saveArea() {
    final name = areaName.trim();
    if (name.isEmpty) {
      _set(() => areaNameTouched = true);
      return;
    }
    final wasSample = sample;
    final known = wasSample ? <String>{} : stops.map((s) => s.street).toSet();
    final cap = plan == PlanTier.free ? PlanLimits.freeContacts : 200;
    final homes = draftHomes.where((a) => !known.contains(a.street)).take(cap).toList();
    final base = _newId();
    final added = [
      for (var i = 0; i < homes.length; i++)
        Stop(
            id: base + i,
            position: homes[i].point,
            street: homes[i].street,
            name: homes[i].street,
            state: StopState.unvisited),
    ];
    final area = Area(id: 'a$base', name: name, polygon: draft);
    final center = centroid(draft);
    _undoStops = null;
    _set(() {
      areas = wasSample ? [area] : [...areas, area];
      activeAreaId = area.id;
      stops = wasSample ? added : [...stops, ...added];
      tour = 0;
      draft = [];
      outlining = false;
      filter = MapFilter.all;
      selectedId = null;
      sheet = null;
    });
    _panTo(center, force: true);
    showToast(
        wasSample ? '$name is ready · ${added.length} stops to cover' : '$name saved · ${added.length} stops added');
  }

  void pickArea(String id) {
    final a = areas.firstWhere((x) => x.id == id);
    _set(() {
      sheet = null;
      activeAreaId = id;
      tab = AppTab.map;
      selectedId = null;
      result = null;
    });
    _panTo(centroid(a.polygon), force: true);
  }

  String areaSubtitle(Area a) {
    final v = visitedIn(a), t = totalIn(a);
    return t > 0 && v == t ? 'Complete · $t stops' : '$v of $t visited';
  }

  // ---------------------------------------------------------- settings
  void setAutomation(String key, bool on) => _set(() {
        switch (key) {
          case 'retry':
            autoRetry = on;
          case 'text':
            autoText = on;
          case 'weekly':
            autoWeekly = on;
        }
      });

  void setMorningReminder(bool on) => _set(() => morningReminder = on);

  // -------------------------------------------------------- start states
  /// Jumps to a named state, like the prototype's `?start=`.
  /// Pass with `--dart-define=SOLUM_START=map-log`. See [startStates].
  static const startStates = [
    'welcome', 'how', 'location', 'signup', 'paywall', 'tour', 'map', 'map-log', 'map-log-retry', 'map-follow', //
    'map-pin', 'map-add', 'manual-add', 'map-search', 'map-directions', 'outline', 'outline-name', 'area-almost', //
    'area-complete', 'limit-contacts', 'limit-area', 'followups', 'contacts', 'contact', 'contact-edit', 'settings',
  ];

  void applyStart(String st) {
    _reset();
    const onboarding = {
      'welcome': OnboardingStep.welcome,
      'how': OnboardingStep.how,
      'location': OnboardingStep.location,
      'signup': OnboardingStep.auth,
      'paywall': OnboardingStep.plans,
    };
    step = onboarding[st] ?? OnboardingStep.done;
    LatLng south() => fromPrototypeUnits(786, 700);
    switch (st) {
      case 'tour':
        _startTour();
      case 'map-log':
        sheet = SheetKind.logVisit;
        sheetStopId = 3;
        selectedId = 3;
      case 'map-log-retry':
        sheet = SheetKind.logVisit;
        sheetStopId = 5;
        selectedId = 5;
        log = LogForm()..outcome = 'Not home';
      case 'map-follow':
        sheet = SheetKind.followUp;
        sheetStopId = 1;
        selectedId = 1;
        follow = FollowForm()..note = 'Bring the quote';
      case 'map-pin':
        addMode = true;
        newPin = Seed.nehalemPin;
      case 'map-add':
        newPin = Seed.nehalemPin;
        add = AddForm()..address = addresses.nearestLabel(Seed.nehalemPin);
        sheet = SheetKind.newContact;
      case 'map-search':
        searchOpen = true;
        query = 'miller';
      case 'map-directions':
        selectedId = 1;
        directionsTarget = '1544 SE Miller St';
      case 'area-almost' || 'area-complete':
        stops = [
          for (final s in stops)
            s.state == StopState.unvisited && (st == 'area-complete' || s.id != 5)
                ? s.copyWith(
                    state: StopState.visited,
                    statusLine: 'Visited today · not home',
                    history: const [VisitEntry('Today', 'Not home')])
                : s
        ];
        if (st == 'area-almost') selectedId = 5;
      case 'limit-contacts':
        stops = [...stops, Seed.fiftieth()];
        sheet = SheetKind.limit;
        limitKind = LimitKind.contacts;
      case 'limit-area':
        tab = AppTab.settings;
        sheet = SheetKind.limit;
        limitKind = LimitKind.area;
      case 'outline':
        plan = PlanTier.plus;
        outlining = true;
        draft = Seed.southDraft.sublist(0, 3);
        initialCenter = south();
      case 'outline-name':
        plan = PlanTier.plus;
        draft = Seed.southDraft;
        sheet = SheetKind.nameArea;
        areaName = 'SE Spokane St';
        initialCenter = south();
      case 'manual-add':
        tab = AppTab.contacts;
        sheet = SheetKind.addByAddress;
        manual = ManualForm()
          ..name = 'Rosa Delgado'
          ..address = '1620 SE Spo';
      case 'contact-edit':
        contactId = 1;
        contactOpen = true;
        edit = EditForm(stopById(1)!);
        sheet = SheetKind.editContact;
      case 'contact':
        contactId = 1;
        contactOpen = true;
      case 'followups':
        tab = AppTab.followUps;
      case 'contacts':
        tab = AppTab.contacts;
      case 'settings':
        tab = AppTab.settings;
    }
    if (selectedId != null && st != 'tour') initialCenter = stopById(selectedId)?.position ?? initialCenter;
    notifyListeners();
  }
}

/// Natural sort: "1505 SE Miller" < "1515 SE Miller", "Stop 2" < "Stop 10".
int compareNatural(String a, String b) {
  final re = RegExp(r'(\d+|\D+)');
  final pa = re.allMatches(a.toLowerCase()).map((m) => m.group(0)!).toList();
  final pb = re.allMatches(b.toLowerCase()).map((m) => m.group(0)!).toList();
  for (var i = 0; i < pa.length && i < pb.length; i++) {
    final na = int.tryParse(pa[i]), nb = int.tryParse(pb[i]);
    final c = (na != null && nb != null) ? na.compareTo(nb) : pa[i].compareTo(pb[i]);
    if (c != 0) return c;
  }
  return pa.length - pb.length;
}
