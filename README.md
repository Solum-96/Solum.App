# Solum

**Solid ground for solo sellers.**

Solum is the territory and follow-up app for a team of one: outline an area, see what you've covered, filter pins by follow-up date, and keep a fast phone-first CRM in your pocket.

## Getting started

This repository holds the Flutter app, the iOS and Android projects (bundle ID `app.solum`) and the brand.

```bash
flutter pub get
flutter test
flutter run
```

Sign-in uses Supabase with Apple and Google; complete the console steps in `docs/auth-setup.md` and pass the Google client IDs as dart-defines. Without them, run with `--dart-define=SOLUM_DEMO_AUTH=true`.

## What's here

- **`lib/`** — the full Solum v2 app in Flutter: onboarding, Apple/Google sign-up, plans, sample-area walkthrough, the map (progress card, filter chips, swipeable stop cards), log visit, follow-ups, add contact (drop a pin or type an address), outline a new area, search, directions, contacts, contact detail and edit, settings, plan limits, dark mode. Runs on local demo data (Sellwood, Portland).
- **`flutterflow/`** — kit for building the same app in FlutterFlow (theme, data schema, custom widgets/actions/functions, page guide and agent prompts).
- **`docs/design/`** — the design handoff: spec, 30 screen captures, the clickable HTML prototype and the design conversations.
- **`AGENTS.md`** — code map and rules for coding agents.

Open any state directly: `flutter run --dart-define=SOLUM_START=map-log` (list in `AGENTS.md`).

## Brand

- Theme: `lib/theme/solum_theme.dart` (light and dark)
- Tokens, logos, fonts and brand book: `brand/`
- Claude Code: `CLAUDE.md` and the `solum-brand` skill in `.claude/skills/`

Core colors: Basalt `#1F2421` · Olive `#4D5B2E` · Sol `#E9B949` · Sandstone `#E7DFD0` · Chalk `#FAF8F3`. Typeface: Plus Jakarta Sans.
