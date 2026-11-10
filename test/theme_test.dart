import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solum/main.dart';
import 'package:solum/theme/solum_theme.dart';

void main() {
  test('light theme uses Solum brand colors', () {
    final theme = solumLightTheme();
    expect(theme.colorScheme.primary, SolumPalette.olive);
    expect(theme.colorScheme.secondary, SolumPalette.sol);
    expect(theme.colorScheme.onSecondary, SolumPalette.onSol);
    expect(theme.scaffoldBackgroundColor, SolumPalette.surface);
    expect(theme.extension<SolumColors>(), isNotNull);
  });

  test('basalt and sol stay the same in dark mode', () {
    final dark = solumDarkTheme().extension<SolumColors>()!;
    expect(dark.basalt, SolumPalette.basalt);
    expect(dark.sol, SolumPalette.sol);
  });

  testWidgets('home screen renders the primary actions', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SolumApp());
    expect(find.text('Log visit'), findsOneWidget);
    expect(find.text('Follow up'), findsOneWidget);
    expect(find.text('29 of 41 visited'), findsOneWidget);
  });
}
