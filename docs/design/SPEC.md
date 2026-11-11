# Handoff: Solum mobile app (v2, map layout 1b)

> Design spec from the Claude Design handoff. Paths below are relative to `docs/design/`. Implementation: `lib/` (Flutter) and `flutterflow/` (FlutterFlow kit).

## Overview
Solum is a territory and follow-up app for solo field sellers (door-to-door, real estate prospecting, B2B routes). A seller outlines an area on a map, logs each stop as visited, sets follow-ups for people to see again, and keeps a light CRM. This package covers the full v2 app: onboarding, sign-up, plans/paywall, sample-area walkthrough, the map (layout "1b": slim progress card on top, swipeable stop cards at the bottom), visit logging, follow-ups, contacts, areas, automations, settings and plan limits.

Target: **Flutter** (iOS + Android, one codebase).

## About the design files
The files in `prototype/` are **design references built in HTML**. They show the intended look and behavior. They are not production code. Recreate them in Flutter using idiomatic widgets and state management. Open `prototype/Solum App v2.dc.html` in a browser (serve the folder over a local web server, e.g. `npx serve prototype`) to click through every flow. Append `?start=<state>` to jump to a state (list under "Prototype start states").

## Fidelity
**High fidelity.** Colors, type, spacing, radii, copy and interactions are final for v1, except items marked *placeholder* below. Match them closely.

---

## Design tokens

### Color: light theme (default)
| Token | Hex | Use |
|---|---|---|
| surface (chalk) | `#FAF8F3` | App background |
| surfaceRaised | `#FFFFFF` | Cards, sheets, tab bar |
| sandstone | `#E7DFD0` | Map ground, dividers, input/secondary borders, progress track, segmented control track |
| ink | `#1F2421` | Primary text, unvisited pin ring |
| inkMuted | `#50564F` | Secondary text, inactive icons |
| olive | `#4D5B2E` | Brand, primary buttons, visited pins, progress, selected chip, active tab |
| onOlive | `#FFFFFF` | Text on olive |
| sol | `#E9B949` | Reserved signal: follow-ups only (gold pins, Follow up button, badge dot) |
| onSol | `#1F2421` | Text on sol (never white) |
| solTint | `#FBF0D3` | Follow-up badge background, callouts |
| basalt | `#1F2421` | Dark cards, toasts, Log visit button (does not invert in dark mode) |
| rust | `#9A3412` | Danger (not used yet) |
| scrim | `rgba(31,36,33,0.40)` | Behind modal sheets |
| areaFill | olive at 12% alpha | Outlined area fill |
| areaStroke | olive | Outlined area stroke, 2.4px, dash 7/5 (map units) |

### Color: dark theme
surface `#171A18`, surfaceRaised `#222623`, sandstone `#3A3E38`, ink `#F3F0E8`, inkMuted `#B9BDB6`, olive `#A3B57A`, onOlive `#171A18`, solTint `#3D3420`. Sol, basalt and onSol are unchanged.

### Map colors (derived)
- Ground: sandstone. Roads: surface (chalk). Buildings: ink mixed 9% into ground. Parks/green: olive mixed 16% into ground. Schools: ink 4% into ground. Rail: ink 22% into ground.
- Street labels: 600 13px Plus Jakarta Sans, inkMuted, with a 3px halo in road color.

### Typography: Plus Jakarta Sans (bundled variable font)
| Style | Size/Line | Weight | Tracking |
|---|---|---|---|
| display | 56/56 | 800 | −0.045em |
| title | 26/32 | 800 | −0.02em |
| heading | 20/26 | 700 | −0.01em |
| bodyStrong | 16/22 | 700 | 0 |
| body | 16/24 | 400 | 0 |
| small | 14/20 | 500 | 0 |
| label | 13/16 | 700 | +0.06em, UPPERCASE via style |
| Screen headline (custom) | 30/34 | 800 | −0.03em |
| Welcome headline | 34/38 | 800 | −0.03em |
| Big counts ("37 of 43 visited") | 20/24 | 800 | −0.02em |
Minimum text size is 13px. Sentence case everywhere.

### Spacing, radius, size
- 4px grid: 4, 8, 12, 16, 20, 24, 32, 40, 48.
- Screen margin 16. Sheet padding 20.
- Radius: 10 (badges), 16 (cards, rows, inputs), 24 (sheets, large panels), pill (buttons, chips).
- Touch target ≥ 44. Primary buttons 54 tall, medium 44, small 40. Chips 44.
- Icons 24px, 2px stroke, rounded (Lucide set; use `lucide_icons` Flutter package).
- Pins: unvisited 16px white fill + 3px ink inner ring; visited 16px solid olive; follow-up 18px sol fill + 3px basalt ring. Selected pin: scale 1.35, 3px white outline, drop shadow `0 2 4 rgba(31,36,33,.35)`.

### Elevation
- Flat by default. No shadows on cards on chalk.
- `shadowFloat`: `0 2 8 rgba(31,36,33,.10), 0 1 2 rgba(31,36,33,.08)`, for anything floating over the map.
- `shadowSheet`: `0 -4 24 rgba(31,36,33,.10)`, for bottom sheets.

### Motion
Easing `cubic-bezier(.2,.8,.2,1)` (ease-out). 120ms presses, 200ms toggles, 280ms sheets and pushes, 320ms map pan-to. Press state: scale 0.98 and brightness 0.92. No bounce.

---

## Navigation
Bottom tab bar, 84px tall incl. home indicator, surfaceRaised, 1px top divider. Tabs: **Map** (map), **Follow-ups** (calendar-clock), **Contacts** (users), **Settings** (settings). Active = olive, inactive = inkMuted. Labels 700 13/16. The Follow-ups tab shows a sol badge (20px pill, basalt 800 13px text, 2px raised-surface ring) with today + overdue count.

Contact detail pushes from the right over the tabs (280ms). Sheets slide up over a scrim. Paywall is full-screen modal.

---

## Screens

### 1. Welcome
- Top: 3-panel slab grid (columns 1.3fr/1fr, rows 1fr/0.75fr, 8px gap, 24 radius): olive tall left, basalt top right, sandstone bottom right.
  - Olive: three 52px circular icon tokens (map on chalk, calendar-clock on sol, users on chalk) floating ±8px on a 4.2s loop, staggered. The mark animates in: 132×18 chalk bar grows from left (700ms), 48px sol dot drops onto it (900ms, 300ms delay).
  - Basalt: 7 white 14px dots turn olive one by one (7s loop) to show visiting; one sol dot pulses (2s ring).
  - Sandstone: dashed olive polygon with marching dashes (1.4s loop), map-pin icon floating.
- Below: lockup (28px tall), headline "Solid ground for solo sellers." (34/38), body "Outline your area, see what you have covered, and keep every follow-up in your pocket." Text fades up 600ms.
- Buttons: primary "Get started" → How it works. Secondary "I already have an account" → Sign in.
- Respect reduced-motion: disable all loops.

### 2. How it works
Step dots (1 of 3). Title "How Solum works", sub "Three habits that keep a territory moving." Three white cards (16 radius, 18 padding) with a 44px visual + bodyStrong title + small muted text:
- dashed area tile: "Outline your area" / "Draw the streets you plan to cover and watch the count fill in."
- visited pin: "Mark every stop" / "One tap logs a visit. Olive pins are done."
- follow-up pin: "Follow up on time" / "Gold pins are people to see. Solum reminds you that morning."
Primary "Continue".

### 3. Location
Illustrative mini-map (300px, 24 radius). Title "See the stops around you". Body "Solum uses your location to center the map and show which doors are next." Primary "Allow location" (locate-fixed icon) triggers the OS permission prompt. Secondary "Not now". Both continue to sign-up.

### 4. Create account / Sign in
Same screen, two modes.
- Olive slab with the mark (dot drops, bar grows).
- Title "Create your account" / "Welcome back". Sub "Free to start. No card needed." / "Sign in with the account you used before."
- **Only** two buttons: "Continue with Apple" (basalt, Apple logo) and "Continue with Google" (secondary outlined, Google "G"). No email/password. Use `sign_in_with_apple` and `google_sign_in`.
- Footer "By continuing you agree to the Terms and Privacy Policy."
- Sign-up continues to Plans. Sign-in goes straight to the map.

### 5. Plans (paywall)
Full screen. Mark top-left, close (x) top-right. Headline and sub change with context:
| Context | Headline | Sub |
|---|---|---|
| default / onboarding | Cover more ground | Start free. Upgrade when one area is not enough. |
| contacts limit | Keep adding contacts | Your 50 contacts stay put. Plus makes room for 500. |
| area limit | Outline your next area | Plus covers 5 areas. Pro covers as many as you need. |
| locked automation | Let Solum do the reminding | Free includes one automation. Plus and Pro unlock the rest. |

Billing segmented control (sandstone track, 4px padding, 44px segments, selected = raised + shadowFloat): "Monthly" / "Yearly · save 25%". Default Yearly.

Tier cards (raised, 16 radius, radio left, price right; selected = 2px olive outline, radio 7px olive border):
| Tier | Monthly | Yearly | Description |
|---|---|---|---|
| Pro | $16/mo | $144/yr ($12/mo) | Unlimited areas and contacts, custom automations, CSV export. |
| Plus (default, "Most popular" olive tag) | $8/mo | $72/yr ($6/mo) | 5 areas, 500 contacts, coverage history, every automation. |
| Free | $0 forever | | 1 area, up to 50 contacts, 1 automation. |

CTA "Start 14-day free trial" (paid) or "Continue with Free". Footnote "Free for 14 days, then $72 a year. Cancel anytime." (computed) or "You can upgrade anytime in Settings." *Placeholder: prices and limits are proposals pending business sign-off.* Use RevenueCat or `in_app_purchase`.

### 6. Map (layout 1b)
Full-bleed map behind everything.
- **Top progress card** (top 58, inset 16, raised, 16 radius, 14/16 padding, shadowFloat): label = area name + chevron-down (tap → Your areas sheet); count "37 of 43 visited" (800 20/24); right: sol-tint pill "3 today" (44 tall, sol dot) → Follow-ups tab; progress bar below (8px, sandstone track, olive fill).
  - **Area complete** variant: 44px olive check circle, "Area complete", full bar, then small text "All 43 stops visited. 2 follow-ups still open."
- **Filter chips** below (floating, 44 tall): All / Follow-ups (count) / Not visited (count). Selected = olive fill.
- **Right FAB column** (44px circles, raised, shadowFloat): search, plus (add contact), locate-fixed (center on me). Top 272 (300 when area complete).
- **Stop card carousel** (bottom 100): horizontal snap scroll, 300px cards, 12 gap, 16 side padding. Card: pin, name (bodyStrong), sub line (note for follow-ups, street, or "Not visited"), sol badge with time or "Overdue", 40px tint directions button; row of two 44px buttons "Log visit" (basalt) and "Follow up" (sol). Selected card = 2px olive outline.
  - Order: overdue, today by time, later follow-ups, not visited. Visited stops are hidden from cards under "All".
  - **Sync:** swiping to a card selects its pin and pans the map if the pin is off-screen. Tapping a pin scrolls the carousel to its card. Tapping a visited pin shows a single result card instead.
- User location: 18px white dot, 10px basalt core, 7px olive 22% halo.
- Attribution "© OpenStreetMap contributors" bottom-left above tabs (required).
- Pan by drag. Production should use a real map SDK (see "Map implementation").

### 7. Search (from the map)
Full overlay (surface) with search field + "Cancel". Empty query shows "People to see today". Typing matches **Your contacts** (name + street) and **Addresses** (map address points not already contacts), up to 5 and 6 results. Picking a contact pans to it and shows the result card (Directions + Log visit). Picking an address drops a basalt map-pin marker with "Not in your contacts yet" and buttons Directions + "Add contact". No match: "Nothing matches “{q}” in {area}."

### 8. Directions
Every Directions action opens an iOS-style action sheet: "Get directions to {address}" → Apple Maps / Google Maps / Cancel. The app asks every time. On Android, show a Material bottom sheet with the same two options. Launch via `url_launcher` (`maps.apple.com/?daddr=`, `google.navigation:` / `https://www.google.com/maps/dir/?api=1&destination=`).

### 9. Log visit (sheet)
Title "Log visit · {name}". Outcome chips: Spoke with them / Not home / Not interested / Sale.
- When **Not home** is picked, a sol-tint panel appears with a switch "Remind me to try again Friday" (on by default when the free retry automation is on). Saving with it on turns the stop into a follow-up for Fri 5pm with note "Not home last time. Try again." Toast "Visit logged · retry set for Friday".
- Note (multiline). Checkboxes: "Left a flyer" (on), "Set a follow-up next" (hidden when retry is on; if checked, the Follow up sheet opens after saving).
- Primary "Save visit". Toast "Visit logged · 38 of 43" with Undo.
- If this visit completes the area: toast "{Area} is complete. Good ground covered." and the top card switches to Area complete.

### 10. Follow up (sheet)
"When" chips: Today / Tomorrow / Next week; time chips 9am / 12pm / 5pm / 7pm. "What to say" field (prefilled from existing note). Switch "Remind me that morning". Sol CTA "Set for tomorrow, 5pm" (dynamic). Toast "Follow-up set · …" with Undo.

### 11. Add contact
Three entry points:
1. **Drop a pin:** map + → basalt banner "Add a contact / Tap the map where the stop is". Tapping drops a selected unvisited pin; banner shows the nearest real address ("1579 SE Nehalem St" if within ~25m, else "Near …"). Bottom primary "Add contact here" (disabled until a pin exists) → New contact sheet.
2. **Type the address** ("House not on the map?" pill under the banner, and the + on Contacts tab) → "Add by address" sheet: Name or business, Street address (with up to 3 matching map addresses, tap to snap the pin), Phone. If not snapped, choose "At my location" or "No pin". No-pin contacts show in lists with address "No pin · {street}", stay out of the map and carousel, and open the contact page from search.
3. **Search result** "Add contact".
New contact sheet fields: Name or business (required, error "Add a name so you can find them later"), Address (prefilled), Phone (optional), Status chips Not visited / Visited. Toast "Contact added · {name}" with Undo.

### 12. Outline a new area (Plus/Pro)
Entry: Settings → Areas → "Outline a new area", Your areas sheet, walkthrough step 3, or the trial CTA after the area limit.
- Map in drawing mode: basalt banner "Outline a new area" + hint ("Tap the corners of the streets you will cover · 2 of 3", then "{n} homes inside · tap to add corners") + Cancel.
- Each tap adds a corner (16px white dot, 3px olive ring). The polygon draws in solid olive with live 12% fill once there are 3 or more corners. Dragging still pans.
- Bottom buttons: "Undo" (secondary, undo-2 icon) and "Done" (primary, enabled at 3 or more corners).
- Done → "Name this area" sheet: name field prefilled with the nearest street name; summary tile "{n} homes inside" + "{new} new stops will be added. {m} are already in your contacts." Buttons "Redraw" / "Save area".
- Save creates the area, adds every address inside as a not-visited stop, makes it active, pans to it. Toast "{name} saved · {n} stops added".
- Plus caps at 5 areas (toast pointing to Pro). Pro is unlimited. Free → limit sheet.
- Production: get house points from a geocoding/address dataset (e.g. OpenAddresses, Mapbox, Google Places) using a point-in-polygon query.

### 13. Your areas (sheet)
List of areas (dashed tile, name, "{v} of {t} visited" or "Complete · {t} stops", check on active). Tap to switch the active area and pan to it. Footer "+ Outline a new area".

### 14. Plan limits (sheet)
Free users who hit a limit see a sheet first, never the paywall directly:
- 50 contacts: title "You have 50 contacts", body "Free holds up to 50 contacts. Plus holds 500 and adds 5 areas. Try it free for 14 days." (users icon)
- Second area: title "Free covers one area", body "Sellwood is your one area on Free. Plus lets you outline up to 5, with coverage history for each. Try it free for 14 days." (map icon)
Buttons "Not now" / "See plans" → paywall with matching context. Starting a trial returns the user to what they were doing (add mode or drawing mode).

### 15. Sample-area walkthrough (first run)
Runs on the first map open after sign-up. The map loads a **sample area** (area label "Sample area"). A basalt coach card (top 222, left 16, right 72) shows step label, title, body and a "Skip" link:
1. "Sample area · 1 of 3" / "Tap a gold pin" / "Gold pins are people to see. This sample area shows how Solum works before you add your own." A pulsing sol ring marks the first gold pin. Selecting any stop advances.
2. "Log a visit" / "Tap Log visit on the card below. Pick what happened and save. The pin turns olive." Saving a visit advances.
3. "Now outline your own" / "Tap the corners of the streets you plan to cover. Solum fills in every home inside and clears this sample." + primary "Outline your area".
Drawing in step 3 is allowed on Free (it becomes their one area). Saving **replaces** the sample area and its stops. Toast "{name} is ready · {n} stops to cover". Skip ends the tour and leaves the sample in place.

### 16. Follow-ups tab
Date label ("Tuesday, Nov 10"), headline "3 people to see today" (30/34) or "No one left to see today".
- **Overdue** section (only if any): sol dot + label "Overdue"; list card with a 2px sol inset ring; badges read "Overdue".
- **Today** (sorted by time), **Later this week**.
- Empty today: card "Good ground covered today." / "No one left to see. New follow-ups show up here."
- Sol-tint callout with bell: "Solum reminds you at 8:00 am on days with follow-ups." (or the off-state copy).

### 17. Contacts tab
Title + tint "+" (opens Add by address). Search field "Search name or street". **Sort** segmented control: Status (overdue → today → later → not visited → visited) / A–Z (natural sort) / Recent (by last activity). Label "{n} contacts · 50 on Free" (Free) or "{n} matching". Rows use ContactRow: pin, name, address line, optional follow-up badge.

### 18. Contact detail
Back + "Edit" (ghost, pencil). Pin + status badge ("Today, 4pm", "Overdue since Sat", "Visited", "Not visited"). Title name, muted line "street · phone", email line if set. Secondary small buttons Call / Text / Directions. Sol-tint "What to say" card for follow-ups. "Visits" history card. Bottom bar (raised, 24 top radius, shadowSheet): Log visit / Follow up.

### 19. Edit contact (sheet)
Fields: Name or business (blank = use address), Address (typing shows up to 3 matching map addresses with "move pin here"; picking one moves the pin; hint "The pin will move to this address"), Phone + Email side by side, What to say (multiline). "Save changes". Toast "Changes saved" or "Saved · pin moved to {street}" with Undo.

### 20. Settings
Profile row (52px basalt initial avatar). Plan card:
- Free: basalt card, label "Free plan", "{n} of 50 contacts used", usage bar (olive-light `#A3B57A` on 16% white), "Plus adds 5 areas, 500 contacts and every automation.", primary "Try Plus free for 14 days".
- Paid: "Solum Plus/Pro", "Free trial ends Nov 24", "Active" badge.
Areas list + "Outline a new area". **Automations**:
- "Retry not-home stops / Remind me 3 days later" (free, switch)
- "Text after a visit / Send a short thank-you" (Plus badge on Free → paywall)
- "Weekly coverage summary / Mondays at 8:00 am" (Plus badge on Free → paywall)
Preferences: Dark mode switch, Morning reminder switch. Secondary "Sign out". "Solum 1.0".

### Toasts
Basalt, top 56, inset 16, 16 radius, 500 15/20 white, optional sol "Undo" action. Auto-dismiss 3.5s. Undo restores the previous stops list.

---

## State model (suggested)
- `Stop { id, lat, lng (nullable = no pin), street, name, phone, email, note, state: unvisited|visited|followup, due: overdue|today|week, when, order, history[{date, text}], areaId? }`
- `Area { id, name, polygon[LatLng], isSample }`, `activeAreaId`
- `Plan { tier: free|plus|pro, trialEndsAt }`, limits: free 1 area / 50 contacts / 1 automation; plus 5 / 500 / all; pro unlimited.
- `Automations { retryNotHome (free), textAfterVisit, weeklySummary }`
- UI: selectedStopId, filter, sort, tour step (0–4), drawing draft polygon.
- Coverage = stops inside the active area polygon with state ≠ unvisited / all stops inside.
- Follow-up rollover: at midnight, unhandled "today" items become overdue.
Recommend Riverpod or Bloc, Drift or Isar for offline-first local storage, and background sync later.

## Map implementation
The prototype renders a pre-styled static extract of **OpenStreetMap** for Sellwood, Portland OR (`prototype/solum-map-data.js`; 1 map unit ≈ 0.81m, ×1.3 on screen). For production:
- Use **MapLibre GL** (`maplibre_gl`) or Mapbox with a custom vector style matching the map colors above (ground sandstone, roads chalk, buildings 9% ink, parks 16% olive, labels inkMuted with road halo), or `flutter_map` with a styled vector tile source.
- Draw pins as native symbols or annotations per the pin spec. Draw areas as fill + dashed line layers.
- Keep OSM attribution visible.

### Map palette
| Layer | Light | Dark |
|---|---|---|
| Ground | `#E7DFD0` | `#1B1F1C` |
| Minor roads, trails | `#FAF8F3` | `#2F342F` |
| Major roads | `#FAF8F3` | `#3E443D` |
| Service roads | `#FAF8F3` | `#272B27` |
| Buildings | `#D6CFC1` | `#252A26` |
| Parks / green | `#D3D0B7` | `#252C21` |
| Schools | `#E0D9CA` | `#202421` |
| Rail | `#B8B3A7` | `#3A3E38` |
| Street labels / halo | `#50564F` / `#FAF8F3` | `#B9BDB6` / `#1B1F1C` |
| Area fill | olive `#4D5B2E` @ 12% | olive-dark `#A3B57A` @ 14% |
| Area stroke | `#4D5B2E` | `#A3B57A` |
| Attribution chip | ground @ 85% | ground @ 85% |
| User-location halo | `rgba(77,91,46,.22)` | `rgba(163,181,122,.28)` |
Pins keep their light/dark token values (unvisited fill = surfaceRaised with ink ring; visited = olive; follow-up = sol with basalt ring). Road widths in map units: major 14, minor 9, service 4, trail 3 (dash 4/4), rail 2.

## Assets
- `prototype/assets/` holds the logos: `solum-lockup.svg`, `solum-lockup-reverse.svg`, `solum-mark.svg`, `solum-mark-reverse.svg`. Never retype the wordmark.
- Font: Plus Jakarta Sans variable (`prototype/_ds/.../assets/fonts/` via tokens/fonts.css), OFL.
- Icons: Lucide (map, calendar-clock, users, settings, search, plus, locate-fixed, navigation, check, x, chevron-*, map-pin, pencil, phone, message-square, bell, moon, repeat, calendar-check, keyboard, undo-2, pen-line).
- Apple and Google sign-in marks: use the official SDK buttons or the brand-approved assets.

## Prototype start states
`welcome, how, location, signup, paywall, tour, map, map-log, map-log-retry, map-follow, map-pin, map-add, manual-add, map-search, map-directions, outline, outline-name, area-almost, area-complete, limit-contacts, limit-area, followups, contacts, contact, contact-edit, settings`. Example: `Solum App v2.dc.html?start=tour`. `platform=android` renders the Android frame (used for Play screenshots).

## Screens folder
`screens/` holds 30 PNG captures of the prototype (25 light, 5 dark), numbered in flow order: welcome → plans → walkthrough → map states → sheets → areas and limits → tabs → dark variants. They are for reference only. Exact values come from this README and the prototype. (Captures are scaled to fit, so read sizes from the spec, not the pixels.)

## Files
- `prototype/Solum App v2.dc.html`: the full clickable prototype (markup + logic class at the bottom of the file).
- `prototype/solum-map-data.js`: OSM street, building and address geometry.
- `prototype/_ds/…`: Solum design system tokens (`tokens/*.css`) and component bundle.
- `prototype/ios-frame.jsx`, `prototype/android-frame.js`: device frames (presentation only, do not implement).
- `prototype/Solum Testing Kit.dc.html`: moderated usability test script.
- Flutter theme and tokens: implemented in `lib/theme/solum_theme.dart` (the starter file from the handoff was merged into it).
