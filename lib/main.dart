import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

import 'screens/app_shell.dart';
import 'services/auth_config.dart';
import 'services/services.dart';
import 'services/supabase_auth_service.dart';
import 'state/solum_store.dart';
import 'theme/solum_theme.dart';

/// Optional start state, like the prototype's `?start=`:
/// `flutter run --dart-define=SOLUM_START=map-log`, or on web
/// `http://localhost:8080/?start=map-log&dark=1`. See [SolumStore.startStates].
const _start = String.fromEnvironment('SOLUM_START');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final q = Uri.base.queryParameters;
  final start = _start.isNotEmpty ? _start : q['start'];

  // Real sign-in (Supabase + Apple/Google) unless demo mode is requested or the
  // app is opened on a start state for testing.
  final demo = AuthConfig.demoAuth || kIsWeb || (start != null && start.isNotEmpty) || !AuthConfig.hasSupabase;
  AuthService auth = DemoAuthService();
  if (!demo) {
    await Supabase.initialize(url: AuthConfig.supabaseUrl, publishableKey: AuthConfig.supabasePublishableKey);
    auth = SupabaseAuthService();
  }

  final store = SolumStore(auth: auth, start: start);
  if (q['dark'] == '1') store.setThemeMode(ThemeMode.dark);
  await store.restoreSession();
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
