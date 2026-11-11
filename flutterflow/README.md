# Solum × FlutterFlow kit

Everything needed to build the Solum v2 design inside a FlutterFlow project, by
hand or with the FlutterFlow agent. Read this together with:

- `docs/design/SPEC.md` — the design spec (every screen, token and copy string)
- `docs/design/screens/` — 30 reference captures, numbered in flow order
- `lib/` — a complete Flutter reference implementation of the same app

## How FlutterFlow and this repo fit together

FlutterFlow does **not** import an existing Flutter codebase into its visual
editor. Its GitHub integration pushes *from* FlutterFlow *to* GitHub (to a
`flutterflow` branch). Code comes *into* FlutterFlow only as Custom Code
(widgets, actions, functions) and via theme/data settings.

So this repo has two parallel deliverables:

| Path | What it is | How to use it |
|---|---|---|
| `lib/` | Full Flutter app (all 20 screens, local demo data) | `flutter run`; reference for behavior and pixel values |
| `flutterflow/` | Theme values, data schema, custom code | Paste into a FlutterFlow project; build pages there |

If you connect the FlutterFlow project to this repo, point it at a **separate
branch** (FlutterFlow's default `flutterflow` branch) so FlutterFlow's pushes
never overwrite `main`'s hand-written `lib/`.

## 1. Project setup

1. Create a FlutterFlow project named **Solum**. Platforms: iOS and Android.
2. **Settings → App Details**: package `app.solum`.
3. **Settings → Fonts → Custom fonts**: upload `brand/fonts/PlusJakartaSans-{Regular,Medium,Bold,ExtraBold}.ttf`
   as family **Plus Jakarta Sans** (400/500/700/800). Use it for every text style.
4. **Settings → Dependencies** (Custom Code → pubspec): add
   `flutter_map: ^8.3.2`, `latlong2: ^0.10.1`, `url_launcher: ^6.3.3`.
5. **Theme** (light and dark): enter the values from `theme.json`
   (mapping below). Turn on dark mode support; the in-app Settings switch sets it.

### Theme slot mapping

| FlutterFlow slot | Solum token | Light | Dark |
|---|---|---|---|
| Primary | olive | `#4D5B2E` | `#A3B57A` |
| Secondary | sol (follow-ups only) | `#E9B949` | `#E9B949` |
| Tertiary | basalt (never inverts) | `#1F2421` | `#1F2421` |
| Alternate | sandstone | `#E7DFD0` | `#3A3E38` |
| Primary Text | ink | `#1F2421` | `#F3F0E8` |
| Secondary Text | inkMuted | `#50564F` | `#B9BDB6` |
| Primary Background | surface (chalk) | `#FAF8F3` | `#171A18` |
| Secondary Background | surfaceRaised | `#FFFFFF` | `#222623` |
| Info | onOlive | `#FFFFFF` | `#171A18` |
| Error | rust | `#9A3412` | `#9A3412` |
| custom `solTint` | follow-up badge bg | `#FBF0D3` | `#3D3420` |
| custom `onSol` | text on sol | `#1F2421` | `#1F2421` |
| custom `scrim` | behind sheets | `#661F2421` | `#661F2421` |

Typography (Theme → Typography), all Plus Jakarta Sans:

| FF style | Solum style | Size/line | Weight | Tracking |
|---|---|---|---|---|
| Display Large | display | 56/56 | 800 | −2.5 |
| Headline Large | welcome headline | 34/38 | 800 | −1.0 |
| Headline Medium | screen headline | 30/34 | 800 | −0.9 |
| Headline Small | title | 26/32 | 800 | −0.5 |
| Title Large | heading | 20/26 | 700 | −0.2 |
| Title Medium | count ("37 of 43 visited") | 20/24 | 800 | −0.4 |
| Title Small | bodyStrong | 16/22 | 700 | 0 |
| Body Large | body | 16/24 | 400 | 0 |
| Body Medium | small | 14/20 | 500 | 0 |
| Label Medium | label (UPPERCASE text) | 13/16 | 700 | +0.8 |

Minimum text size 13. Sentence case everywhere. Buttons are pills: 54 tall
(primary), 44 (medium); chips 44; icon buttons 44 circles.

## 2. Data types and app state

Create the Data Types and App State in `schema.md` exactly as written (names
and field types matter: the custom code reads them).

## 3. Custom code

Paste each file under **Custom Code** with the same name:

| File | Kind | Notes |
|---|---|---|
| `custom_code/widgets/solum_map_pin.dart` | Widget `SolumMapPin` | params: `state` String, `selected` bool |
| `custom_code/widgets/solum_area_map.dart` | Widget `SolumAreaMap` | the map; see the header comment for params and actions |
| `custom_code/widgets/solum_progress_card.dart` | Widget `SolumProgressCard` | map top card |
| `custom_code/actions/open_directions.dart` | Action `openDirections` | `address` String, `app` String (`apple`/`google`) |
| `custom_code/functions/solum_functions.dart` | Functions | one Custom Function per top-level function |

These files do not compile outside FlutterFlow (they import FlutterFlow's
generated `/flutter_flow/...` files), so `flutter analyze` skips this folder.

## 4. Pages to build

Build pages in this order; each row points to its spec section and the Flutter
reference file. Use components for the stop card, contact row, chips and
sheets so they can be reused.

| Page / component | Spec § | Reference |
|---|---|---|
| Welcome | 1 | `lib/screens/onboarding/welcome_screen.dart` |
| HowItWorks, Location, Auth (Apple/Google only), Paywall | 2–5 | `lib/screens/onboarding/onboarding_screens.dart` |
| Map (tab) + StopCard + ResultCard + CoachCard | 6, 15 | `lib/screens/map/map_tab.dart` |
| Search overlay | 7 | `lib/screens/map/search_overlay.dart` |
| Directions chooser | 8 | `lib/screens/app_shell.dart` (`_DirectionsChooser`) |
| Sheets: Log visit, Follow up, New contact, Add by address, Edit contact, Name area, Your areas, Plan limit | 9–14, 19 | `lib/screens/sheets.dart` |
| Follow-ups tab, Contacts tab, Settings tab | 16, 17, 20 | `lib/screens/tabs.dart` |
| Contact detail | 18 | `lib/screens/contact_detail.dart` |

Business rules (sorting, limits, toasts, walkthrough steps, undo) live in
`lib/state/solum_store.dart`; port them to FlutterFlow actions one to one.

## 5. Prompts for the FlutterFlow agent

The agent works best one page at a time with exact values. Templates:

> Build the page **Follow-ups** from `docs/design/SPEC.md` §16. Background Primary
> Background, 16px side padding. Header: Label Medium "TUESDAY, NOV 10" (from
> current date), then Headline Medium `todayHeadline(count)`. Sections Overdue
> (sol dot + label, list card with 2px Secondary inner border), Today, Later this
> week, each a Secondary Background card radius 16 with ContactRow components.
> Bottom callout: solTint card radius 16, bell icon, Body Medium text.

> Create component **StopCard** (300 wide, radius 16, Secondary Background,
> shadow 0 2 8 #1F24211A): row = SolumMapPin, name (Title Small) + sub line
> (Body Medium, Secondary Text), follow-up badge (solTint, radius 10, 26 tall,
> 13/700), 44 circle Alternate directions button; second row two 44-tall pills
> "Log visit" (Tertiary bg, white text) and "Follow up" (Secondary bg, onSol text).

Keep the copy exactly as the spec writes it: verbs first, numbers before nouns,
no exclamation marks.
