---
name: solum-brand
description: Apply the Solum brand (colors, type, logo, voice, map-pin language) to any Solum UI, screen, page, copy or asset. Use whenever building or reviewing anything for the Solum field-sales app.
---

# Solum brand

Solum is a utility-first mobile app for solo field sellers: outline an area, see what you've covered, filter pins by follow-up date, and use a fast phone-first CRM. Tagline: **Solid ground for solo sellers.** Positioning: the territory and follow-up app for a team of one, priced like a personal productivity app.

If the repo has `brand/` (from the Solum Claude Code kit), use those files as the source of truth: `brand/tokens/solum.css`, `brand/tokens/tailwind.preset.js`, `brand/tokens/theme.ts`, `lib/theme/solum_theme.dart` (Flutter: use `SolumColors.of(context)`, `SolumText`, `SolumSpace`, `SolumRadius`), `brand/logos/`. Never hard-code a hex value that a token already names.

## Color tokens (light / dark)

| Token | Light | Dark | Use |
| --- | --- | --- | --- |
| surface | #FAF8F3 | #171A18 | App and page background (Chalk) |
| surface-raised | #FFFFFF | #222623 | Cards, bottom sheets, chips at rest |
| sandstone | #E7DFD0 | #3A3E38 | Map ground, dividers, progress track |
| ink | #1F2421 | #F3F0E8 | Primary text |
| ink-muted | #50564F | #B9BDB6 | Secondary text, inactive icons |
| olive | #4D5B2E | #A3B57A | Brand: primary buttons, active chip, visited pins, progress, links |
| on-olive | #FFFFFF | #171A18 | Text on olive |
| sol | #E9B949 | #E9B949 | Accent, reserved for "someone to see": follow-ups, Follow up button, the logo dot |
| on-sol | #1F2421 | #1F2421 | Text on sol. Never white on sol |
| sol-tint | #FBF0D3 | #3D3420 | Follow-up badge background |
| basalt | #1F2421 | #1F2421 | Fixed dark ground: app icon, splash, greeting card |
| on-basalt | #FFFFFF | #FFFFFF | Text on basalt |

Rules: olive means done/primary; sol is scarce and always means a follow-up. Grounds stay warm, never pure gray. Text must hit 4.5:1 contrast.

## Map pin language

- Not visited: surface-raised fill, 3px ink ring
- Visited: solid olive
- Follow-up: sol fill, 3px ink ring, slightly larger
- Outlined area: olive at 12% fill, 3px dashed olive stroke

## Type

Plus Jakarta Sans only. display 56/56 800 · title 26/32 800 · heading 20/26 700 · body-strong 16/22 700 · body 16/24 400 · small 14/20 500 · label 13/16 700 uppercase +0.06em. Display sizes use -0.02 to -0.045em tracking. Minimum text 13px.

## Layout

Spacing 4 / 8 / 16 / 20 / 32 px (screen margin 16, sheet padding 20). Radius 10 (badges) / 16 (cards, inputs) / 24 (sheets) / pill (buttons, chips). Touch targets at least 44px; primary actions are 54px pills at the bottom of the sheet within thumb reach. Icons 24px, 2px stroke, rounded caps and joins.

Map screen anatomy: basalt greeting card ("3 people to see today"), filter chips (Today · This week · Not visited), floating Outline-area button, bottom sheet with area progress ("29 of 41 visited"), next contact, and two actions: Log visit (basalt pill) and Follow up (sol pill).

## Logo

A sol dot resting on a ground bar, beside the lower-case wordmark "solum" (Plus Jakarta Sans ExtraBold, tracked -4.5%). Use the supplied SVGs; never retype or redraw the wordmark. Full color on light grounds (ink bar), reverse on basalt (white bar), one-color for single-ink uses. Clear space = the dot's diameter; minimum mark 16px. Never recolor the dot, stretch, add effects, or put the full-color logo on olive.

## Voice

Calm, assured, quietly premium; a trusted mentor. Verbs first on buttons ("Log visit", "Follow up", "Outline area"). Numbers before nouns ("29 of 41 visited"). Sentence case. No exclamation marks or emoji in product UI. Use: visited, area, stop, contact, seller. Avoid: canvass, knocked, rep, turf, leverage, and any team-surveillance language.

## Checklist before finishing Solum work

1. Every color comes from a token; sol only marks follow-ups.
2. Plus Jakarta Sans loaded; styles match the scale above.
3. Tap targets 44px or larger; primary actions reachable with one thumb.
4. Copy follows the voice rules and word list.
5. Dark mode uses the dark token values; basalt stays dark.
