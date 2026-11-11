import 'package:flutter_test/flutter_test.dart';
import 'package:solum/data/models.dart';
import 'package:solum/data/seed.dart';
import 'package:solum/state/solum_store.dart';
import 'package:solum/util/geo.dart';

SolumStore _store([String start = 'map']) => SolumStore(now: DateTime(2026, 11, 10), start: start);

void main() {
  group('seed + coverage', () {
    test('Sellwood starts at 37 of 43 visited with 49 contacts', () {
      final s = _store();
      expect(s.stops.length, 49);
      expect(s.totalIn(), 43);
      expect(s.visitedIn(), 37);
      expect(s.todayList.map((x) => x.name), ['Grace Whitfield', 'Maria Lopez', 'Tom & Priya Nguyen']);
      expect(s.overdueList.single.name, 'Carla Mendes');
      expect(s.followUpBadge, 4);
      expect(s.todayLabel, 'Tuesday, Nov 10');
    });

    test('cards: overdue, today by time, later, not visited; visited hidden under All', () {
      final s = _store();
      final c = s.cards;
      expect(c.first.name, 'Carla Mendes');
      expect(c[1].name, 'Grace Whitfield');
      expect(c.where((x) => x.state == StopState.visited), isEmpty);
      s.setFilter(MapFilter.notVisited);
      expect(s.cards.every((x) => x.state == StopState.unvisited), isTrue);
      expect(s.filterCount(MapFilter.followUps), 5);
    });

    test('prototype unit conversion lands in Sellwood', () {
      final p = fromPrototypeUnits(786, 477);
      expect(p.latitude, closeTo(45.4668, 0.001));
      expect(p.longitude, closeTo(-122.6500, 0.001));
    });
  });

  group('log visit', () {
    test('saving a visit marks it visited and toasts the count', () {
      final s = _store();
      s.openLog(5);
      s.saveLog();
      expect(s.stopById(5)!.state, StopState.visited);
      expect(s.visitedIn(), 38);
      expect(s.toast!.text, 'Visit logged · 38 of 43');
      expect(s.toast!.undo, isTrue);
      s.undo();
      expect(s.stopById(5)!.state, StopState.unvisited);
    });

    test('not home + retry turns the stop into a Friday follow-up', () {
      final s = _store();
      s.openLog(6);
      s.log.outcome = 'Not home';
      s.saveLog();
      final st = s.stopById(6)!;
      expect(st.state, StopState.followUp);
      expect(st.when, 'Fri, 5pm');
      expect(st.note, 'Not home last time. Try again.');
      expect(s.toast!.text, 'Visit logged · retry set for Friday');
    });

    test('"Set a follow-up next" opens the follow-up sheet', () {
      final s = _store();
      s.openLog(5);
      s.log.followAfter = true;
      s.saveLog();
      expect(s.sheet, SheetKind.followUp);
    });

    test('logging the last stop completes the area', () {
      final s = _store('area-almost');
      expect(s.isComplete(), isFalse);
      s.openLog(5);
      s.saveLog();
      expect(s.isComplete(), isTrue);
      expect(s.toast!.text, 'Sellwood is complete. Good ground covered.');
    });
  });

  test('follow up: today 7pm sorts after 6pm', () {
    final s = _store();
    s.openFollow(5);
    s.follow
      ..day = 'Today'
      ..time = '7pm';
    expect(s.followCta, 'Set for today, 7pm');
    s.saveFollow();
    expect(s.todayList.last.id, 5);
    expect(s.toast!.text, 'Follow-up set · Today, 7pm');
  });

  group('add contact', () {
    test('drop a pin uses the nearest real address', () {
      final s = _store('map-pin');
      expect(s.addModeHint, '1579 SE Nehalem St');
      s.confirmPin();
      expect(s.sheet, SheetKind.newContact);
      s.saveAdd();
      expect(s.add.touched, isTrue, reason: 'name is required');
      s.add.name = 'Rosa Delgado';
      s.saveAdd();
      expect(s.stops.length, 50);
      expect(s.toast!.text, 'Contact added · 50 of 50 on Free');
    });

    test('51st contact on Free opens the limit sheet', () {
      final s = _store('limit-contacts');
      s.closeSheet();
      s.startAdd();
      expect(s.sheet, SheetKind.limit);
      expect(s.limitKind, LimitKind.contacts);
      s.seePlans();
      expect(s.showPaywall, isTrue);
      expect(SolumStore.paywallCopy(s.paywallContext).$1, 'Keep adding contacts');
    });

    test('add by address without a pin stays off the map', () {
      final s = _store();
      s.openManual();
      s.manual
        ..name = 'Rosa'
        ..address = '9999 SE Nowhere St'
        ..pin = ManualPin.none;
      s.saveManual();
      final r = s.stops.last;
      expect(r.hasPin, isFalse);
      expect(r.listLine, 'No pin · 9999 SE Nowhere St');
      expect(s.mapStops.contains(r), isFalse);
    });

    test('address suggestions snap the pin', () {
      final s = _store();
      s.openManual();
      s.manual.address = '1606 SE Spo';
      expect(s.manualSuggestions, isNotEmpty);
      expect(s.manualSuggestions.first.street, contains('SE Spokane St'));
    });
  });

  group('areas', () {
    test('Free users hit the one-area limit', () {
      final s = _store();
      s.startOutline();
      expect(s.sheet, SheetKind.limit);
      expect(s.limitKind, LimitKind.area);
    });

    test('Plus outlines a new area and adds every home inside', () {
      final s = _store('outline');
      expect(s.outlining, isTrue);
      s.tapMap(Seed.southDraft[3]);
      expect(s.draftHomes.length, greaterThan(20));
      s.finishOutline();
      expect(s.sheet, SheetKind.nameArea);
      expect(s.areaName, isNotEmpty);
      final before = s.stops.length;
      s.saveArea();
      expect(s.areas.length, 2);
      expect(s.activeArea.name, isNot('Sellwood'));
      expect(s.stops.length, greaterThan(before));
      expect(s.toast!.text, contains('stops added'));
      expect(s.visitedIn(), 0);
    });
  });

  group('walkthrough', () {
    test('tap a gold pin → log a visit → outline replaces the sample', () {
      final s = _store('tour');
      expect(s.tour, 1);
      expect(s.activeArea.name, 'Sample area');
      expect(s.coachPin!.name, 'Grace Whitfield');
      expect(s.cards.first.name, 'Grace Whitfield');
      s.select(s.coachPin!.id);
      expect(s.tour, 2);
      s.openLog(3);
      s.saveLog();
      expect(s.tour, 3);
      s.startOutline();
      expect(s.outlining, isTrue);
      for (final p in Seed.southDraft) {
        s.tapMap(p);
      }
      s.finishOutline();
      s.saveArea();
      expect(s.areas.length, 1);
      expect(s.sample, isFalse);
      expect(s.stops.every((x) => x.state == StopState.unvisited), isTrue);
      expect(s.toast!.text, contains('is ready'));
    });
  });

  test('search matches contacts and addresses not yet contacts', () {
    final s = _store('map-search');
    expect(s.searchStops().map((x) => x.name), contains('Maria Lopez'));
    final known = s.stops.map((x) => x.street).toSet();
    expect(s.searchAddresses().every((a) => !known.contains(a.street)), isTrue);
    s.pickAddress(s.searchAddresses().first);
    expect(s.result!.isStop, isFalse);
  });

  test('paywall: trial from onboarding starts the walkthrough', () async {
    final s = _store('paywall');
    expect(s.paywallFootnote, r'Free for 14 days, then $72 a year. Cancel anytime.');
    s.setBilling(Billing.monthly);
    expect(s.paywallFootnote, r'Free for 14 days, then $8 a month. Cancel anytime.');
    await s.endPaywall(startTrial: true);
    expect(s.plan, PlanTier.plus);
    expect(s.tour, 1);
  });

  test('edit contact moves the pin to a picked address', () {
    final s = _store('contact-edit');
    final e = s.edit!;
    e.street = '1569 SE Nehal';
    final sug = s.editSuggestions;
    expect(sug, isNotEmpty);
    e
      ..street = sug.first.street
      ..snap = sug.first;
    s.saveEdit();
    expect(s.stopById(1)!.street, sug.first.street);
    expect(s.toast!.text, startsWith('Saved · pin moved to'));
  });

  test('contacts sort A–Z is natural', () {
    expect(compareNatural('1505 SE Miller St', '1515 SE Miller St'), lessThan(0));
    expect(compareNatural('Stop 2', 'Stop 10'), lessThan(0));
  });
}
