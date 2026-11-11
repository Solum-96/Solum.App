import 'package:flutter_test/flutter_test.dart';
import 'package:solum/theme/solum_theme.dart';

void main() {
  test('light theme uses Solum brand colors', () {
    final theme = solumLightTheme();
    expect(theme.colorScheme.primary, SolumPalette.olive);
    expect(theme.colorScheme.secondary, SolumPalette.sol);
    expect(theme.colorScheme.onSecondary, SolumPalette.onSol);
    expect(theme.scaffoldBackgroundColor, SolumPalette.surface);
    expect(theme.extension<SolumColors>(), isNotNull);
    expect(theme.extension<SolumMapColors>(), SolumMapColors.light);
  });

  test('basalt and sol stay the same in dark mode', () {
    final dark = solumDarkTheme().extension<SolumColors>()!;
    expect(dark.basalt, SolumPalette.basalt);
    expect(dark.sol, SolumPalette.sol);
    expect(solumDarkTheme().extension<SolumMapColors>(), SolumMapColors.dark);
  });
}
