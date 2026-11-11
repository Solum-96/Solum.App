import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/app_shell.dart';
import 'state/solum_store.dart';
import 'theme/solum_theme.dart';

/// Optional start state, like the prototype's `?start=`:
/// `flutter run --dart-define=SOLUM_START=map-log`, or on web
/// `http://localhost:8080/?start=map-log&dark=1`. See [SolumStore.startStates].
const _start = String.fromEnvironment('SOLUM_START');

void main() {
  final q = Uri.base.queryParameters;
  final store = SolumStore(start: _start.isNotEmpty ? _start : q['start']);
  if (q['dark'] == '1') store.setThemeMode(ThemeMode.dark);
  runApp(SolumApp(store: store));
}

class SolumApp extends StatelessWidget {
  const SolumApp({super.key, required this.store});

  final SolumStore store;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SolumStore>.value(
      value: store,
      child: Selector<SolumStore, ThemeMode>(
        selector: (_, s) => s.themeMode,
        builder: (context, mode, _) => MaterialApp(
          title: 'Solum',
          debugShowCheckedModeBanner: false,
          theme: solumLightTheme(),
          darkTheme: solumDarkTheme(),
          themeMode: mode,
          home: const SolumRoot(),
        ),
      ),
    );
  }
}
