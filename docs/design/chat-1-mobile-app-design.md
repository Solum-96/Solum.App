# Solum mobile app design

_Started 2026-11-10 06:38 UTC_

---

## User

Design a mobile app for Solum.

## Assistant



## Assistant

_[tool: list_files]_

_[tool: ask_user]_

I've put up a short form. It covers which flows to include, the format, whether you want variations, how far to move from the existing app kit, which seller to design for and which device frame to show. I'll start once you submit it. Anything you skip, I'll choose myself.

## User

<artifact-content-authored-by-others/>
Answered — Asked for follow-up questions; scope: Map + bottom sheet, Log a visit, Schedule a follow-up, Follow-ups list (today/upcoming), Contact detail, Add new contact/pin, Onboarding + sign-up, Paywall / trial, Settings + profile, Dark mode; format: Both; variations: 2–3 for the map screen; novelty: Refine it; persona: Mixed / generic; device: iPhone; notes: Focus on user friendly. Modern and clean with interactive flow.

## Assistant



## Assistant

_[tool: ask_user]_

_[tool: ask_user]_

I've added a second round to the form: navigation, onboarding length, how pricing works on the paywall, and how dark mode switches on. There's also a box for any questions you have. I'll start building once you submit it.

## User

<artifact-content-authored-by-others/>
Answered — nav: Bottom tab bar; paywall: Free tier + Pro; dark: Toggle in settings

## Assistant

_[tool: update_todos]_

_[tool: read_file]_

_[tool: read_file]_

_[tool: read_file]_

_[tool: read_file]_

_[tool: list_files]_

_[tool: read_file]_

_[tool: read_file]_

_[tool: read_file]_

_[tool: read_file]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: copy_starter_component]_

_[tool: grep]_

_[tool: update_todos]_

_[tool: dc_write]_

_[tool: show_html]_

Now the static canvas with the three map directions and all screens.

_[tool: dc_write]_

_[tool: ready_for_verification]_

_[tool: update_todos]_

I built two files: a clickable prototype and a static board. A background check is still running, and I haven't looked through all the screens myself yet.

- **Solum App** (clickable): the full flow, from onboarding (welcome, how it works, location, account, Free or Pro) to the app with four tabs (Map, Follow-ups, Contacts, Settings). Logging a visit, setting a follow-up and adding a contact by dropping a pin all update the map and counts, with undo. Dark mode is a switch in Settings.
- **Solum Screens** (board): three map layouts side by side, plus every flow and four dark-mode screens. Every phone on the board is live, so you can tap through each one.
  - **1a** keeps the existing app layout.
  - **1b** puts stops in a swipeable row of cards along the bottom.
  - **1c** leads with a coverage ring and has a list you can pull up.

You can switch the starting screen, the map layout and dark mode in the Tweaks panel.

A few things are placeholders: the map is a drawn sketch, not a real map, the Pro prices ($9 a month yearly or $12 monthly) and feature list are my own guesses, and "Continue with Apple" has no logo.

You're at about 91% of your usage limit, so I've stopped here. Tell me which map layout you want and I'll take it further.

## User

Found issues — fixing…

## Assistant

_[tool: copy_files]_

_[tool: run_script]_

_[tool: ready_for_verification]_

I've fixed the three problems the check found. It's running again on the updated file.

- **Logo:** the welcome and paywall screens now show the official Solum logo files, using the light-background version in dark mode. Before, the logo didn't show at all.
- **Second buttons:** "I already have an account" and "Not now" are now outlined buttons. They had been showing as a second green button identical to the main one.
- **Status bar:** the paywall no longer covers the time and battery at the top of the phone.

I also moved two pins up so they no longer sit on the edge of the bottom sheet in 1a.

## User

Found issues — fixing…

## Assistant

_[tool: run_script]_

_[tool: ready_for_verification]_

I fixed the logo errors that showed up as the page loaded. The page now loads with no console errors. I skipped the full re-check this time because the change was small.

