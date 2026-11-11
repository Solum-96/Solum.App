# Sign-in setup (Apple, Google, Supabase)

Solum signs sellers in with **Sign in with Apple** (iOS) and **Google** (iOS and
Android), then exchanges the provider's ID token for a **Supabase** session
(`signInWithIdToken`). Supabase stores and refreshes the session, so the app
reopens on the map. Code: `lib/services/supabase_auth_service.dart`,
configuration: `lib/services/auth_config.dart`.

The code and native project settings are in the repo. The console steps below
create the credentials and have to be done by an account owner.

Bundle ID / application ID on both platforms: **`app.solum`**.
Supabase project: **Solum Project** (`ewblcrqyealyvryzjvte`).

## 1. Apple (iOS)

1. Apple Developer → Certificates, IDs & Profiles → Identifiers → `app.solum`
   → enable **Sign in with Apple**.
2. Xcode: open `ios/Runner.xcworkspace`, select your Team under Signing &
   Capabilities. The capability is already declared in
   `ios/Runner/Runner.entitlements`.
3. Supabase Dashboard → Authentication → Sign In / Providers → **Apple** →
   enable, and add `app.solum` under **Client IDs**. (The secret key fields are
   only for the web OAuth flow, which Solum does not use.)

Apple shares the seller's name only on the very first sign-in; the app saves it
to the Supabase profile (`full_name`) at that moment.

## 2. Google (iOS and Android)

In Google Cloud Console → Google Auth Platform (same project for all three):

1. **Branding / Audience**: set the app name, support email, privacy policy and
   terms links; publish to production when ready.
2. **Clients → Create client**, three times:
   - **Web application** — this is the `GOOGLE_WEB_CLIENT_ID`. No redirect URIs
     needed for native sign-in.
   - **iOS** — bundle ID `app.solum`. This is the `GOOGLE_IOS_CLIENT_ID`.
   - **Android** — package `app.solum` and the SHA-1 of your signing key.
     Add one client per key: debug (`cd android && ./gradlew signingReport`),
     upload key, and the Play App Signing key from Play Console.
3. iOS URL scheme: put the **reversed** iOS client ID in
   `ios/Flutter/GoogleSignIn.xcconfig`, e.g.
   `GOOGLE_REVERSED_CLIENT_ID = com.googleusercontent.apps.1234-abcd`.
4. Supabase Dashboard → Authentication → Sign In / Providers → **Google** →
   enable; under **Client IDs** add the Web and iOS client IDs, comma
   separated (web first); turn on **Skip nonce check** (needed for iOS).

## 3. Build with the client IDs

```bash
flutter run \
  --dart-define=GOOGLE_WEB_CLIENT_ID=<web>.apps.googleusercontent.com \
  --dart-define=GOOGLE_IOS_CLIENT_ID=<ios>.apps.googleusercontent.com
```

Or keep them in a JSON file (not secret, but per environment) and pass
`--dart-define-from-file=env/prod.json`. Client IDs are public identifiers.

`SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` default to Solum Project and can
be overridden the same way (e.g. a staging project).

## Modes

| How the app starts | Auth used |
|---|---|
| `flutter run` (iOS/Android) | Real: Supabase + Apple/Google |
| `--dart-define=SOLUM_DEMO_AUTH=true` | Demo (signs in as "Dana Ortiz", no network) |
| Any start state (`SOLUM_START=…` or web `?start=`) | Demo |
| Web build | Demo (native sign-in only) |
| `flutter test` | Fakes (`test/auth_test.dart`) |

## Behavior

- **Sign-up** (Get started → … → Continue with Google/Apple) goes to Plans.
  **Sign-in** (I already have an account) goes straight to the map.
- Closing the Apple/Google sheet leaves the seller on the screen, no message.
- Any other failure shows the toast "Sign-in did not finish. Check your
  connection and try again." and logs the detail with `debugPrint`.
- Android shows only **Continue with Google**; iOS shows both buttons.
- A saved session skips onboarding on launch. **Sign out** (Settings) ends the
  Supabase session and signs out of Google.

## Before shipping

- Turn on row-level security for every table you add; the publishable key is
  public by design.
- Supabase → Authentication → URL Configuration: no changes needed for native
  ID-token sign-in.
- App Store review: Sign in with Apple must be offered on iOS because Google
  sign-in is offered (it is).
