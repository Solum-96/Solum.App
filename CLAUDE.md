# Solum

Solum is a utility-first Flutter mobile app for solo field sellers (solo entrepreneurs, door-to-door marketers, B2B field and route agents). Core jobs:

1. Tap a button, outline an area on the map, and see whether it has been covered.
2. Filter map pins by follow-up date.
3. A lightning-fast CRM built for one hand on a phone screen.

Priced like a personal productivity app ($9–14/month). No team hierarchies, rep GPS tracking or bloated pipelines: that is the enterprise problem Solum exists to avoid. Keep features small, fast and one-thumb friendly.

## Project layout

The v2 app (design handoff in `docs/design/`) is implemented in `lib/`. Read `AGENTS.md` for the full code map, conventions and commands.

- `lib/main.dart` — app entry; `SolumStore` via provider; `SOLUM_START` / web `?start=` jumps to a screen state.
- `lib/state/solum_store.dart` — all app state and flows (port of the prototype's logic class).
- `lib/theme/solum_theme.dart` — `SolumPalette`, `SolumColors` and `SolumMapColors` (ThemeExtensions), `SolumText`, `SolumSpace`, `SolumRadius`, `SolumSize`, `SolumShadows`, `SolumMotion`.
- `lib/widgets/` — design-system components (`solum_components.dart`), logos (`solum_logo.dart`).
- `lib/screens/` — onboarding, map tab, tabs, contact detail, sheets, app shell.
- `docs/design/` — design spec (`SPEC.md`), screen captures, clickable prototype, design chats.
- `flutterflow/` — FlutterFlow kit: theme values, data schema, custom code, page guide.
- `brand/` — brand source files: `tokens/tokens.json` (canonical values), web/TS token exports, `logos/` (SVG), `fonts/` (Plus Jakarta Sans, OFL), `brand-book.md`.

Commands: `flutter pub get`, `flutter analyze`, `flutter test`, `flutter run`.

## Brand

All UI, copy and assets follow the Solum brand. Load the `solum-brand` skill (`.claude/skills/solum-brand/`) before building or reviewing any screen, page or copy.

Non-negotiables:
- Never hard-code a color in a widget. Use `Theme.of(context).colorScheme` (primary = olive) or `SolumColors.of(context)` (sol, basalt, pins). `sol` marks follow-ups only; text on `sol` is always `onSol` (dark).
- If a brand value changes, update `brand/tokens/tokens.json` first, then `lib/theme/solum_theme.dart` and the other exports in `brand/tokens/`.
- Plus Jakarta Sans is the only typeface (declared in `pubspec.yaml`); use `SolumText` or the theme's `textTheme`.
- Touch targets at least 44px; primary actions are 54px pills.
- Product copy: verbs first, numbers before nouns, sentence case, no emoji or exclamation marks. Say "visited", "area", "contact"; never "canvass", "knocked" or "rep".
