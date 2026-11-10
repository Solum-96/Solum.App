# Solum

**Solid ground for solo sellers.**

Solum is the territory and follow-up app for a team of one: outline an area, see what you've covered, filter pins by follow-up date, and keep a fast phone-first CRM in your pocket.

## Getting started

This repository holds the Flutter app code and brand. Platform folders (`android/`, `ios/`) are not committed yet; generate them once:

```bash
flutter create . --org app.solum --project-name solum --platforms ios,android
flutter pub get
flutter test
flutter run
```

`flutter create .` only adds missing files and keeps the existing `lib/`, `test/` and `pubspec.yaml`. It also adds a sample `test/widget_test.dart` that refers to a `MyApp` class this app doesn't have: delete that file (the real tests are in `test/theme_test.dart`).

## Brand

- Theme: `lib/theme/solum_theme.dart` (light and dark)
- Tokens, logos, fonts and brand book: `brand/`
- Claude Code: `CLAUDE.md` and the `solum-brand` skill in `.claude/skills/`

Core colors: Basalt `#1F2421` · Olive `#4D5B2E` · Sol `#E9B949` · Sandstone `#E7DFD0` · Chalk `#FAF8F3`. Typeface: Plus Jakarta Sans.
