# Solum

**Solid ground for solo sellers.**

Solum is a utility-first mobile app for people who sell in the field on their own: solo entrepreneurs, door-to-door marketers, B2B route and field agents, home-services pros, real estate prospectors. Outline an area, see what you've covered, filter pins by follow-up date, and keep a fast, phone-first CRM in your pocket, priced like a personal productivity app ($9–14/month), not an enterprise contract.

This document is the brand book. Every color, type style and spacing value named here lives in `tokens.json`.

---

## 1. Brand foundation

**The name.** *Solum* (SO-lum) is Latin for "ground, foundation." It quietly echoes *solo*, the exact customer. Ground is where the work happens; foundation is what the app gives you.

**The problem we exist to solve.** Most field-sales tools are built for managers tracking 50+ reps: GPS tracking, team hierarchies, bloated pipelines, enterprise pricing. The person actually doing the work gets none of the benefit and all of the overhead.

**Positioning.** The territory and follow-up app for a team of one.

**Vision.** Every independent field seller has the same edge as the biggest sales teams, without the overhead.

**Mission.** Give solo field sellers the fastest way to know where they've been, who to see next, and what to say when they get there, all from one hand on a phone.

**Values**
- **Fast over full.** If it takes more than one tap mid-walk, it's too slow.
- **Yours, not your boss's.** No surveillance, no hierarchy. Your data, your ground.
- **Honest pricing.** Priced like a tool, not a contract.
- **Built for the curb.** Readable in sunlight, usable with one thumb, between stops.

**The story to tell.** Not "Uber for sales" (Solum isn't a marketplace). Closer to what a fitness tracker did for running: a personal tool that makes your own effort visible, builds a habit, and is cheap enough to just try.

---

## 2. Voice

Calm, assured, quietly premium. Solum speaks like a trusted mentor: steady, encouraging, never loud, never corporate.

| Do | Don't |
| --- | --- |
| "Good ground covered today." | "Crushing it!! 🔥" |
| "3 people to see today." | "You have 3 pending follow-up tasks." |
| "Log visit" · "Follow up" | "Submit interaction record" |
| "visited", "area", "stop", "contact" | "canvass", "knocked", "rep", "leverage" |

Rules: verbs first on buttons; numbers before nouns in summaries ("29 of 41 visited"); sentence case everywhere; no exclamation marks in product UI; no emoji.

**Taglines.** Primary: *Solid ground for solo sellers.* Alternates: *Know your ground.* · *Cover ground. Close more.*

---

## 3. Logo

The mark is one point resting on solid ground: the solo seller, standing firm. The dot is always `sol`; the bar takes `ink` on light grounds and `on-basalt` (white) on `basalt`.

Files (Logos group): `solum-mark.svg` (light grounds), `solum-mark-reverse.svg` (dark grounds), `solum-mark-mono.svg` (one color: decals, stamps, embroidery), `solum-app-icon.svg` (1024 × 1024 master).

- **Wordmark.** "solum", lower case, Plus Jakarta Sans ExtraBold (800), letter-spacing −0.045em. The wordmark is set type until a final outlined lockup is drawn; never retype it in another face.
- **Lockups.** Horizontal: mark left of wordmark, mark height = 0.9× the wordmark's x-height-to-baseline span, gap = 0.2× mark width. Stacked: mark centered above, gap = 0.15× mark width.
- **Clear space.** Keep the diameter of the dot clear on all sides.
- **Minimum size.** Mark 16px; horizontal lockup 80px wide. Below 24px, thicken the bar (see `solum-app-icon.svg` proportions).
- **Don't** recolor the dot to anything but `sol` (or the single mono color), stretch the mark, put the dot under the bar, add outlines or shadows, or place the full-color mark on `olive`.

---

## 4. Color

A neutral, earthy palette with one brand hue (`olive`) and one signal (`sol`). Grounds are warm (`surface`, `sandstone`), never pure gray.

- `olive` is the brand and the "done" color: primary buttons, visited pins, progress.
- `sol` is reserved: it means *someone to see* (follow-ups, the Follow up action, the dot in the mark). If everything is gold, nothing is.
- `basalt` is the fixed dark ground for the icon, splash and hero moments; it does not invert in dark mode.
- Text on `sol` is always `on-sol` (dark). Text on `olive` is `on-olive`.

**Map language** (the palette doubles as the map legend):

| State | Pin |
| --- | --- |
| Not visited | `surface-raised` fill, 3px `ink` ring |
| Visited | solid `olive` |
| Follow-up | `sol` fill, 3px `ink` ring (larger, 9px radius vs 7–8) |
| Outlined area | `olive` 12% fill, 3px dashed `olive` stroke |

Follow-up and visited differ in lightness, not just hue, so the map reads for color-blind users and in harsh sun.

---

## 5. Typography

One family: **Plus Jakarta Sans** (Google Fonts, open license). ExtraBold for display and numbers, Bold for emphasis, Regular/Medium for body.

| Style | Size / line | Weight | Use |
| --- | --- | --- | --- |
| `display` | 56 / 56 | 800 | Marketing headlines |
| `title` | 26 / 32 | 800 | Sheet headline ("29 of 41 visited") |
| `heading` | 20 / 26 | 700 | Card and section titles |
| `body-strong` | 16 / 22 | 700 | Contact names, row titles |
| `body` | 16 / 24 | 400 | Body copy |
| `small` | 14 / 20 | 500 | Secondary lines, timestamps |
| `label` | 13 / 16 | 700 | Area names, overlines (uppercase, +0.06em) |

Display sizes take −0.02 to −0.045em letter-spacing. Minimum text in the app is 13px.

---

## 6. Layout and components (app)

- Screen margin `space-4`; sheet padding `space-5`; radius `radius-lg` on sheets, `radius-md` on cards, `radius-pill` on buttons and chips.
- Every tap target is at least `touch-min` (44px); primary actions are `button-height` (54px) pills side by side at the bottom of the sheet, within thumb reach.
- Map screen anatomy: greeting card on `basalt` at top ("3 people to see today"), filter chips (Today · This week · Not visited), floating Outline-area button, bottom sheet with area progress, next contact, and two actions: **Log visit** (`basalt` pill) and **Follow up** (`sol` pill).
- Icons: 24px, 2px stroke, rounded caps and joins, drawn in `ink` or `ink-muted`.

---

## 7. Name and availability

No field-sales, territory or CRM product named Solum turned up in a first search, but the word is busy elsewhere: SoluM Co. (South Korean electronic shelf labels, with a US trademark portfolio), a soil-sensing company, and several small apps (miSolum, Solum Aims Manager). Plan on:

- A descriptor in store listings: **Solum – Field Sales Map** (or *Territory & Follow-ups*).
- A modified domain if solum.com is unavailable: e.g. getsolum, solum.app, usesolum.
- A clearance search by a trademark attorney in software classes (9 and 42) before filing or investing in final logo art.

---

## 8. Open items

- Final outlined wordmark lockup (current wordmark is live type).
- Marketing site, App Store screenshots and onboarding screens built from these tokens.
- Dark-mode map style.
