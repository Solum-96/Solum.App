import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solum/main.dart';
import 'package:solum/screens/map/solum_map.dart';
import 'package:solum/state/solum_store.dart';

bool _fontsLoaded = false;

/// Real brand font so text wraps as on a device (the default test font
/// renders every glyph as a square).
Future<void> _loadFonts() async {
  if (_fontsLoaded) return;
  final loader = FontLoader('PlusJakartaSans');
  for (final w in ['Regular', 'Medium', 'Bold', 'ExtraBold']) {
    loader.addFont(rootBundle.load('brand/fonts/PlusJakartaSans-$w.ttf'));
  }
  await loader.load();
  _fontsLoaded = true;
}

Future<SolumStore> _pump(WidgetTester tester, String start) async {
  SolumMapConfig.showTiles = false; // no network in tests
  await _loadFonts();
  tester.view.physicalSize = const Size(402, 874);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final store = SolumStore(start: start, now: DateTime(2026, 11, 10));
  await tester.pumpWidget(MediaQuery(
    data: const MediaQueryData(
        size: Size(402, 874), padding: EdgeInsets.only(top: 54, bottom: 34), disableAnimations: true),
    child: SolumApp(store: store),
  ));
  await tester.pump(const Duration(milliseconds: 400));
  return store;
}

void main() {
  testWidgets('welcome shows the headline and both actions', (tester) async {
    await _pump(tester, 'welcome');
    expect(find.text('Solid ground for solo sellers.'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('How Solum works'), findsOneWidget);
  });

  testWidgets('map shows progress, chips and stop cards', (tester) async {
    await _pump(tester, 'map');
    expect(find.text('37 of 43 visited'), findsOneWidget);
    expect(find.text('3 today'), findsOneWidget);
    expect(find.text('Carla Mendes'), findsOneWidget);
    expect(find.text('Log visit'), findsWidgets);
    expect(find.text('Follow up'), findsWidgets);
    expect(find.text('© OpenStreetMap contributors'), findsOneWidget);
  });

  testWidgets('log visit sheet saves and toasts', (tester) async {
    final store = await _pump(tester, 'map-log');
    expect(find.text('Log visit · Grace Whitfield'), findsOneWidget);
    await tester.tap(find.text('Save visit'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(store.stopById(3)!.state.name, 'visited');
    // A follow-up already counts as covered, so the count stays at 37.
    expect(find.text('Visit logged · 37 of 43'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('tabs render', (tester) async {
    for (final (start, text) in const [
      ('followups', '3 people to see today'),
      ('contacts', '49 CONTACTS · 50 ON FREE'),
      ('settings', '49 of 50 contacts used'),
      ('contact', 'Maria Lopez'),
      ('paywall', 'Cover more ground'),
      ('limit-area', 'Free covers one area'),
      ('outline-name', 'Name this area'),
      ('manual-add', 'Add by address'),
      ('tour', 'Tap a gold pin'),
      ('area-complete', 'Area complete'),
    ]) {
      await _pump(tester, start);
      expect(find.text(text), findsWidgets, reason: start);
      expect(tester.takeException(), isNull, reason: 'layout error in $start');
    }
  });

  testWidgets('dark mode renders the map', (tester) async {
    final store = await _pump(tester, 'map');
    store.setThemeMode(ThemeMode.dark);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('37 of 43 visited'), findsOneWidget);
  });
}
