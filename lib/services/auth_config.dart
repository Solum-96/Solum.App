/// Auth and backend configuration, overridable at build time:
///
/// ```bash
/// flutter run \
///   --dart-define=GOOGLE_WEB_CLIENT_ID=xxxx.apps.googleusercontent.com \
///   --dart-define=GOOGLE_IOS_CLIENT_ID=yyyy.apps.googleusercontent.com
/// ```
///
/// The Supabase URL and publishable key are public by design (they ship in
/// every client); data is protected by row-level security, not by hiding them.
/// Setup steps: docs/auth-setup.md.
abstract final class AuthConfig {
  /// Supabase project "Solum Project".
  static const supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://ewblcrqyealyvryzjvte.supabase.co');
  static const supabasePublishableKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY',
      defaultValue: 'sb_publishable_6Vhga66IYM_k_pG4qnIM7w_ArG8a4BJ');

  /// Web OAuth client ID. Google issues the ID token for this audience; on
  /// Android it is required (`serverClientId`). Also listed in Supabase →
  /// Auth → Providers → Google → Client IDs.
  static const googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  /// iOS OAuth client ID (bundle ID app.solum). Its reversed form goes in
  /// ios/Flutter/GoogleSignIn.xcconfig.
  static const googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

  /// Set `--dart-define=SOLUM_DEMO_AUTH=true` to skip real sign-in (screenshots,
  /// usability tests on simulators without accounts).
  static const demoAuth = bool.fromEnvironment('SOLUM_DEMO_AUTH');

  static bool get hasSupabase => supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;
}
