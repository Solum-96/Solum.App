# Solum Design System

**Solid ground for solo sellers.**

Solum is a utility-first mobile app for people who sell in the field alone: solo entrepreneurs, door-to-door marketers, B2B route agents, home-services pros, real estate prospectors. You outline an area, see what you've covered, filter pins by follow-up date, and keep a fast, phone-first CRM in your pocket. It is priced like a personal productivity app ($9–14/month), not an enterprise contract. Positioning: *the territory and follow-up app for a team of one.*

There is one product surface today: the **Solum mobile app** (map + bottom sheet + lightweight CRM). Marketing site, App Store screenshots, onboarding and a dark-mode map style are listed as open items in the brand book and are not designed yet.

## Sources

- `07-brand-book/solum-brand-book.md` — brand book text (local folder attached by the user).
- `07-brand-book/Solum-Brand-Book.pdf` — 7-page brand book v1, November 2026. Copied to `source/Solum-Brand-Book.pdf`.
- The book references a larger kit (01 Logos, 02 App icons, 03 Colors, 04 Fonts, 05 Design tokens incl. `tokens.json`, 06 Social images). Official logo PNGs and the app icon set were later uploaded (`assets/logo/png/`, `assets/app-icons/`). `tokens.json` was later supplied and is now canonical (`tokens/tokens.json`), including dark-theme values. Social images were later supplied (`assets/social/`). The full kit is now in the project. SVG logos in `assets/logo/` were extracted as vector paths directly from the PDF's logo page; colors were read from the PDF's fill operators; spacing/radius tokens follow the book's stated values.
- No codebase, Figma file or production screens were provided.

## Index

- `styles.css` — global entry; `@import`s only.
- `tokens/` — `tokens.json` (canonical source), `fonts.css` (Plus Jakarta Sans @font-face), `colors.css`, `typography.css`, `spacing.css` (space, radius, sizes, elevation, motion), `base.css` (body reset + `.solum-*` type classes).
- `assets/logo/` — SVG mark, lockups (horizontal, stacked), reverse/mono/white, app icon (vector paths extracted from the PDF). `assets/logo/png/` — **official supplied PNGs**: horizontal, stacked, mark (full-color, reverse, mono-ink, mono-white) and wordmark (ink, white). Prefer these for raster use; SVGs for scalable/inline use.
- `assets/app-icons/` — **official app icon set**: iOS 1024, Google Play 512, Android adaptive foreground (on #1F2421), apple-touch 180, PWA 192/512, favicon.ico, square master SVG, rounded preview (presentations only — never upload pre-rounded to a store). See its README.txt. `assets/icons/` — Lucide SVGs used in the kit. `assets/fonts/` — Plus Jakarta Sans variable woff2. `assets/brand/cover-blocks.png` — cover slab motif.
- `assets/social/` — **official social images**: OG 1200×630, Facebook cover, X header, LinkedIn banner, 1080 avatar (app icon on basalt). Layout: chalk left with horizontal lockup + primary tagline in ink-muted; right side = cover-block slabs (olive panel with sol dot + chalk bar, basalt and sandstone blocks with 24px corners).
- `guidelines/` — foundation specimen cards (Colors, Type, Spacing, Brand).
- `components/` — React primitives (see below), one `@dsCard` per folder.
- `ui_kits/app/` — click-through recreation of the mobile app.
- `source/` — original PDF and extraction scratch files.
- `SKILL.md` — Agent Skill entry point.

### Components

- `components/core/` — **Button**, **IconButton**, **Icon**, **Logo**
- `components/forms/` — **Chip**, **TextField**, **Checkbox**, **Switch**
- `components/feedback/` — **Badge**, **ProgressBar**, **Toast**
- `components/surfaces/` — **Card**, **BottomSheet**
- `components/map/` — **MapPin**, **AreaProgress**, **GreetingCard**
- `components/crm/` — **ContactRow**

No component library exists in the source. This set was authored from the brand book's interface rules and the map-screen anatomy (§6): greeting card, filter chips, outline-area button, bottom sheet with area progress, next contact, Log visit / Follow up pills. MapPin follows the map legend exactly.

### UI kits

- `ui_kits/app/` — Map, Follow-ups list, Contact, Log visit sheet, Follow up sheet, Outline area mode.

---

## CONTENT FUNDAMENTALS

**Voice:** calm, assured, quietly premium. Solum speaks like a trusted mentor: steady, encouraging, never loud, never corporate.

- **Verbs first on buttons.** "Log visit", "Follow up", "Outline area", "Save visit". Never "Submit interaction record".
- **Numbers before nouns.** "29 of 41 visited", "3 people to see today", "12 stops". Not "Visit completion rate: 70.7%". Counts are set in ExtraBold.
- **Sentence case everywhere** — buttons, titles, chips. The only uppercase is the `label` style (area names, overlines), applied via CSS, not typed.
- **No exclamation marks, no emoji** in product UI. Encouragement is understated: "Good ground covered today." not "Crushing it!! 🔥".
- **Second person, implied.** The app addresses the seller directly but sparingly ("Good morning, Dana", "Remind me that morning"). No "we" in product UI.
- **Vocabulary.** Use: visited, area, stop, contact, seller, follow up. Avoid: canvass, knocked, rep, turf, leverage, pipeline, tasks.
- **Human, plain notes.** "Interested in a quote. Call after 5pm." Short sentences, periods, no jargon.
- **Taglines.** Primary: *Solid ground for solo sellers.* Alternates: *Know your ground.* · *Cover ground. Close more.*
- **Store name:** "Solum – Field Sales Map" (descriptor needed; the word is busy elsewhere).

## VISUAL FOUNDATIONS

**Themes.** Light (default, `:root`) and dark (`[data-theme="dark"]`) per tokens.json. Dark: surface #171A18, raised #222623, sandstone #3A3E38, ink #F3F0E8, ink-muted #B9BDB6, olive #A3B57A (on-olive dark), sol-tint #3D3420. Sol, basalt and on-sol never change.

**Palette.** Neutral and earthy: one brand hue, one signal. Olive `#4D5B2E` is the brand and the "done" color (primary buttons, visited pins, progress). Sol `#E9B949` is reserved — it always means *someone to see* (follow-ups, the Follow up action, the dot in the mark); if everything is gold, nothing is. Basalt `#1F2421` is text and the fixed dark ground for icon, splash, greeting card; it does not invert in dark mode. Grounds are warm: Chalk `#FAF8F3` (background), White (cards/sheets), Sandstone `#E7DFD0` (map ground, dividers), Sol Tint `#FBF0D3` (follow-up badge), Sandstone is also the progress-bar track (per tokens.json). Secondary text is Ink Muted `#50564F`. Text on Sol is always Basalt, never white. Never pure gray.

**Type.** One family, Plus Jakarta Sans. ExtraBold 800 for display and numbers with tight tracking (−0.02 to −0.045em); Bold 700 for headings and names; Regular/Medium for body and secondary lines. Scale: display 56/56, title 26/32, heading 20/26, body-strong 16/22, body 16/24, small 14/20, label 13/16 uppercase +0.06em. Minimum 13px.

**Spacing & layout.** 4px step. Screen margin 16px, sheet padding 20px. Phone-first, one-thumb: primary actions are 54px pills, side by side at the bottom of the sheet. Every tap target ≥44px. The map is full-bleed; the greeting card and filter chips float at top; the bottom sheet is fixed at bottom.

**Corners.** 10 (badges, small tags) / 16 (cards, contact rows, inputs) / 24 (bottom sheets, large panels, app icon at 1x) / pill (buttons, filter chips, progress). Pills echo the ground bar in the mark.

**Cards.** White on chalk, 16px radius, no border, no shadow — flat. Inverse cards are basalt. Callouts use Sol Tint. No colored left-border accents.

**Shadows / elevation.** Flat by default. Shadow appears only on UI floating over the map (`--shadow-float`: soft, low, basalt-tinted) and the bottom sheet (`--shadow-sheet`, upward). No inner shadows. The logo never gets shadows or outlines.

**Backgrounds & imagery.** Solid color slabs only. The brand-book cover uses tall flat panels of olive, basalt and sandstone with the dot and bar at panel scale (`assets/brand/cover-blocks.png`). No gradients, no textures, no patterns. The official social images reuse this exact composition (lockup + tagline on chalk, slabs at right). No photography is supplied; the logo must not sit on busy photos.

**Map language.** Not visited = white fill, 3px ink ring. Visited = solid olive. Follow-up = sol fill, 3px ink ring, larger (9px vs 7–8px radius). Outlined area = olive 12% fill, 3px dashed olive stroke. States differ in lightness so the map reads in harsh sun and for color-blind users.

**Borders.** 1px sandstone dividers between rows; 1.5px sandstone on secondary buttons, unselected chips and inputs; focus turns the border olive.

**Transparency & blur.** Minimal. Used for the 12% olive area fill, the 40% basalt scrim behind modal sheets, and 72% white secondary text on basalt. No backdrop blur.

**Motion.** Quiet and quick. `cubic-bezier(.2,.8,.2,1)` ease-out; 120ms for presses, 200ms for toggles, 280ms for sheets/progress. Sheets slide; no bounces, no confetti.

**States.** Press: scale 0.98 + slight darken (brightness 0.92). Hover (web): same darken, no lift. The active filter chip fills olive. Chips are 44px tall (touch-min includes chips). Disabled: 40% opacity. Checked/on states use olive.

## ICONOGRAPHY

- Spec from the brand book: **24px, 2px stroke, rounded caps and joins, drawn in Ink or Ink Muted** (white on basalt).
- No icon set was supplied. **Lucide** matches the spec exactly and is used as the system set (substitution — please confirm). The `Icon` component loads glyphs from `cdn.jsdelivr.net/npm/lucide-static@0.454.0` via CSS mask so they tint with `currentColor`; 32 commonly used glyphs are copied into `assets/icons/`.
- No icon font, no PNG icons, no emoji, no unicode-as-icon. The mark itself (dot + bar) doubles as a motif: the sol dot appears in the greeting card.

## Logo

Mark = one point (the seller, always Sol) resting on a ground bar (Ink on light, white on basalt). Wordmark "solum", lower case, Plus Jakarta Sans ExtraBold, −4.5% tracking, supplied as outlines — never retype it; use `Logo` or the SVGs. Clear space = dot diameter. Min: mark 16px, lockup 80px wide. Full color on chalk/white/sandstone; reverse on basalt; one-color (mono) for decals; white on olive. Never recolor the dot, stretch, rotate, put the dot under the bar, or place the full-color logo on olive.

## Intentional additions

Brand-guidelines-only source, so the whole component set is authored. Additions beyond what the book names explicitly: TextField, Checkbox, Switch, Toast (needed for log-visit/follow-up flows), Icon (Lucide wrapper), Logo (wraps the extracted paths). Elevation and motion tokens are also additions — the book does not specify them.
