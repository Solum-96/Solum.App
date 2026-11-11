# Welcome screen animation improvement

_Started 2026-11-10 20:56 UTC_

---

## User

<artifact-content-authored-by-others/>
Continuing from "Solum mobile app design".

## Assistant

We've been building out a full mobile app design for Solum across onboarding, map interaction, follow-ups management, contacts, and settings—with dark mode support throughout. The goal is a modern, clean, user-friendly experience.

We decided on a bottom tab navigation with four main sections (Map, Follow-ups, Contacts, Settings), a Free/Pro paywall model, and a toggle-based dark mode in Settings. We explored three distinct map layouts: one keeping the existing app structure, one with swipeable stop cards at the bottom, and one leading with a coverage ring and a pull-up list. You haven't yet chosen which map direction to move forward with.

The current state is two working files:
- Solum App (clickable prototype): full end-to-end flow with all interactions, undo functionality, and dark mode toggling. Map is currently a sketch placeholder; Pro pricing ($9/year or $12/month) and feature list are estimates; "Continue with Apple" lacks a logo.
- Solum Screens (board): three map layouts side-by-side, all flows, and dark variants. Every phone frame is interactive for testing.

We've resolved three verification issues: official Solum logos now display correctly across light/dark contexts, secondary buttons are now properly outlined (not duplicate green), and the paywall no longer overlaps the status bar. The logo loading errors on initial page render are also fixed.

Open work: you need to select which of the three map layouts (1a, 1b, or 1c) to develop further. Once chosen, I'll refine that direction, finalize the map with real data, lock down pricing/feature details, and build out any remaining interactive states.

Files: Solum App.dc.html, Solum Screens.dc.html, ios-frame.jsx, support.js.

## User

The welcome screen has undesired blank space. Let fill with animated icons and bring more life to design

## Assistant

_[tool: grep]_

_[tool: read_file]_

_[tool: screenshot_user_view]_

_[tool: grep]_

_[tool: grep]_

_[tool: read_file]_

_[tool: str_replace_edit]_

_[tool: show_html]_

_[tool: ready_for_verification]_

I filled the three blank panels on the welcome screen with animation:
- **Olive panel:** three round icons (map, follow-up calendar, contacts) float gently. The sol dot drops onto the ground bar as the screen loads.
- **Basalt panel:** pins turn olive one at a time to show stops being visited. A gold follow-up pin pulses in the middle.
- **Sandstone panel:** a dashed outline of an area moves continuously around its edge, and a map pin floats inside it.
- **Text:** the headline and copy fade up into place when the screen opens.

The motion stays slow and calm, and it switches off for anyone who has reduced motion turned on in their phone settings.

## User

Add a middle tier to the paywall subscription. Use best practice when deciding pricing, max price $20.

## Assistant

_[tool: grep]_

_[tool: read_file]_

_[tool: str_replace_edit]_

_[tool: grep]_

Yearly savings stay at 25% ($6 vs $8, $12 vs $16), so that label still holds.

_[tool: ready_for_verification]_

I added a Plus tier between Free and Pro. The paywall now shows three plans:

- **Pro:** $16 a month, or $12 a month billed yearly ($144). Unlimited areas and contacts, CSV export and calendar sync.
- **Plus:** $8 a month, or $6 a month billed yearly ($72). 5 areas, 500 contacts and coverage history. It's marked "Most popular" and selected by default.
- **Free:** stays as it was.

Pricing follows standard practice:
- **Middle plan as the target:** Plus is the plan most people should pick.
- **Pro as the anchor:** at double the price, it makes Plus look like good value.
- **Yearly discount:** yearly billing saves 25% on both paid plans.

The highest price stays under your $20 limit.

Other changes:
- The headline is now "Cover more ground", since there's more than one paid plan.
- The plan card in Settings shows whichever plan was chosen.
- The note under the trial button updates to match the selected plan and billing period.

Calendar sync is a new feature I added to set Pro apart, and the 5-area and 500-contact limits are estimates. Please confirm or replace all three.

## User

Looks good. I have chosen map layout 1b. Lets move forward with development.

## Assistant



## Assistant

_[tool: ask_user]_

I'll build on 1b. Before I start, please answer a few questions in the form: how the map should look, which neighborhood to show, which screens and interactions to build out, whether to design the dark map now, and what this round is for (user testing, developer handoff, or both).

## User

<artifact-content-authored-by-others/>
Answered — Asked for follow-up questions; map_render: Real streets from OpenStreetMap data, styled in Solum colors; area: Doesn't matter; states: Add stop by tapping the map, Area complete, Free-plan limit hit → paywall, Search on map, Route / directions handoff; dark_map: Later; deliverable: Polished prototype for user testing

## Assistant



## Assistant

_[tool: ask_user]_

I added follow-up questions to the form. They cover:
- which app opens directions
- what map search finds
- what triggers the Free limit
- what happens when an area is complete
- any tasks testers will be given

## User

<artifact-content-authored-by-others/>
Answered — Asked for follow-up questions; directions_app: Ask each time; search_scope: Contacts, stops and street addresses; limit_trigger: Adding a 2nd area, Adding the 51st contact; complete_moment: Quiet: card changes to “Area complete” with a summary; open_q: 1. Should I add automations to the free plan or paid plan?  2. Should users be able to auto sign up with their preferred email?

## Assistant



## Assistant

_[tool: ask_user]_

I'd make automations a paid feature, with simple ones on Plus and custom ones on Pro. For sign-up, I'd offer one tap with Apple or Google, plus an emailed sign-in link so nobody needs a password. Please confirm those in the form; there's also a question on whether to show an automation in the prototype.

## User

<artifact-content-authored-by-others/>
Answered — automations: One basic automation free, rest paid; auto_reminder: Yes, build it; signup: Continue with Apple, Continue with Google

## Assistant

_[tool: read_skill_prompt]_

_[tool: read_file]_

_[tool: read_file]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: view_image]_

_[tool: write_file]_

_[tool: show_html]_

_[tool: str_replace_edit]_

_[tool: show_html]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: view_image]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: grep]_

_[tool: grep]_

_[tool: read_file]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: update_todos]_

_[tool: dc_write]_

_[tool: dc_set_props]_

_[tool: show_html]_

_[tool: dc_set_props]_

_[tool: delete_file]_

_[tool: update_todos]_

_[tool: ready_for_verification]_

I built map layout 1b out as a new file, **Solum App v2**, and it's now with the automatic reviewer. The original Solum App and the Screens board are unchanged.

**The map**
- It shows real streets, buildings and parks in Sellwood, Portland, from OpenStreetMap, drawn in Solum colors. You can drag to move around.
- The area covers about 6 blocks, between SE 15th and 16th Avenues and SE Bidwell and Nehalem Streets.
- It holds 43 stops on real house addresses. The people's names are made up.

**What testers can do**
- **Add a stop:** tap the map and the address fills in with the nearest real house.
- **Search:** find contacts, streets or addresses. Picking an address shows a card with Directions and Add contact.
- **Get directions:** from the card, the contact page or search, the app asks each time whether to open Apple Maps or Google Maps.
- **Finish the area:** log the last unvisited stop and the top card quietly changes to "Area complete" with a short summary.
- **Hit a Free limit:** the seed data has 49 contacts, so the second contact a tester adds hits the 50-contact limit. Outlining a new area in Settings hits the one-area limit. Either one opens a short explanation, then the plans screen with a headline that matches.
- **Use the free automation:** when a visit is logged as "Not home", a switch sets a reminder to try again Friday. Settings has two more automations, locked behind Plus.
- **Sign up:** only Continue with Apple or Continue with Google, with the official logos. "I already have an account" opens a Welcome back version of the same screen.

The Tweaks panel has a starting screen for each of these, so you can jump straight to any of them.

**Caveats**
- The map is a fixed picture of the neighborhood, not a live map provider. It can be dragged but not zoomed.
- Drawing a new area isn't built yet, so paid users who tap Outline a new area get a short note instead.
- Dark mode reuses the app's dark colors on the map, but the dark map style isn't designed yet, as agreed.

## User

Lets build out drawing a new area for paid users. In addition add a function to manually input contact in case house does not show up on map.

## Assistant

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_set_props]_

_[tool: ready_for_verification]_

I've added area drawing for paid users and a way to type in a contact's address, both in Solum App v2. The automatic reviewer is checking the file now.

**Drawing a new area (Plus and Pro)**
- Start it from Settings → Outline a new area, or from the area list. Tapping the area name on the map's top card opens that list and lets you switch between areas.
- Tap the map to place each corner of the area. You can still drag the map, and Undo removes the last corner. The banner shows how many homes are inside so far.
- After tapping Done, you name the area. The name field starts with the nearest street, and the sheet shows how many homes are inside and how many new stops that adds.
- Saving makes it the active area, turns every home inside into a not-visited stop, and moves the map to it. The top card, progress, "area complete" message and Settings list all follow whichever area is active.
- Free users still get the one-area limit and upgrade screen. If they start a trial from there, the app goes straight into drawing.
- Plus stops at 5 areas, with a short note pointing to Pro.

**Adding a contact by address**
- On the map, the add banner now has a "House not on the map? Type the address" button.
- The + on the Contacts tab opens this form directly.
- As you type the address, up to three matching addresses from the map appear. Picking one puts the pin on that house.
- If the address isn't on the map, you choose between placing the pin at your current location or no pin. Contacts with no pin show "No pin" in the list and still work for directions and logging visits.

New starting screens in the Tweaks panel: outline, outline-name and manual-add.

## User

This looks good. Lets move forward.

## Assistant



## Assistant

_[tool: ask_user]_

Please pick what to build next in the form. You can choose more than one, and there's a box for any notes, like who your testers will be.

## User

<artifact-content-authored-by-others/>
Answered — Asked for follow-up questions; next: Update the Screens board with v2 flows, User-testing kit (tasks script + start links), Developer handoff package, Polish Contacts / Follow-ups tabs, App Store screenshots, Onboarding tour of the map…

## Assistant



## Assistant

_[tool: ask_user]_

I added follow-up questions to the form. They cover:
- the order of work
- who the testers are
- which improvements to the Contacts and Follow-ups tabs to include
- the style of the map's first-run tour
- the App Store screenshot set
- the tech stack for the developer handoff

## User

<artifact-content-authored-by-others/>
Answered — Asked for follow-up questions; order: Product first: polish tabs + map tour, then board, testing kit, screenshots, handoff last; testers: Mixed solo sellers; polish: Follow-ups: overdue section, Contacts: sort (A–Z, recent, status), Contact: edit details; tour: Sample-area walkthrough; screenshots: 5 iPhone + 3 Android; handoff: Flutter

## Assistant



## Assistant

_[tool: ask_user]_

I added a third round to the form. It asks:
- when the sample-area walkthrough runs
- which steps it covers
- which contact details can be edited
- which background the App Store screenshots use
- any open questions you have

## User

<artifact-content-authored-by-others/>
Answered — walkthrough: After sign-up: first map open uses a sample area, then “Outline your own”; walk_steps: Tap a pin, Log a visit, Outline your area; edit_fields: Name, Address (re-pin), Phone, Email, Notes / what to say; ss_style: Chalk + slabs (brand)

## Assistant

_[tool: update_todos]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

Now the logic.

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_set_props]_

_[tool: show_html]_

_[tool: get_webview_logs]_

_[tool: update_todos]_

_[tool: grep]_

_[tool: read_file]_

_[tool: run_script]_

_[tool: dc_js_str_replace]_

_[tool: read_skill_prompt]_

_[tool: copy_starter_component]_

_[tool: dc_write]_

_[tool: grep]_

_[tool: read_file]_

_[tool: read_file]_

_[tool: write_file]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_set_props]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: show_html]_

_[tool: save_screenshot]_

_[tool: get_webview_logs]_

_[tool: sleep]_

_[tool: save_screenshot]_

_[tool: show_html]_

_[tool: run_script]_

_[tool: run_script]_

_[tool: delete_file]_

_[tool: show_html]_

_[tool: save_screenshot]_

_[tool: save_screenshot]_

_[tool: dc_js_str_replace]_

_[tool: delete_file]_

_[tool: update_todos]_

_[tool: read_skill_prompt]_

_[tool: read_file]_

_[tool: read_file]_

_[tool: list_files]_

_[tool: list_files]_

_[tool: copy_files]_

_[tool: grep]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: update_todos]_

_[tool: present_fs_item_for_download]_

_[tool: ready_for_verification]_

I've built all six items in your order, and the developer package is ready to download above. The automatic reviewer is checking Solum App v2 now.

- **Tab improvements (Solum App v2):**
  - Follow-ups has an Overdue section at the top, and those items show an "Overdue" badge.
  - Contacts can be sorted by Status, A–Z or Recent.
  - Each contact has an Edit button for name, address, phone, email and notes. Picking a matching address moves the pin.
- **First-run walkthrough:** after sign-up the map opens on a sample area with three steps: tap a gold pin, log a visit, then outline your own area. Saving that outline replaces the sample, and testers can skip the walkthrough.
- **Screens board:** five new v2 sections sit at the top. The earlier sections are unchanged below them.
- **Solum Testing Kit:** a printable, 40-minute session script with seven tasks, each linking to the right starting screen. It also has the pricing questions and notes for the moderator.
- **Solum Store Screenshots:** five iPhone and three Android images at full store size, on the brand's chalk background with color blocks.
- **Developer package:** a written spec for Flutter, a starter Flutter theme file, and a copy of the prototype.

Things to know:
- The screenshots page shows eight live copies of the map, so it's slow to load. My own screenshot tool timed out on the full page; I only confirmed a single screenshot renders correctly.
- Prices, plan limits and the Pro features are still proposals until you sign off on them.
- The dark map style still isn't designed.

Do you want screen images added to the developer package? I left them out by default.

## User

Found issues — fixing…

## Assistant

_[tool: dc_js_str_replace]_

_[tool: ready_for_verification]_

I fixed the walkthrough's first step; the reviewer is checking it again now.
- **Hidden pin:** the map now starts lower, so the pulsing gold pin sits below the coach card instead of underneath it.
- **Wrong first card:** the sample area now holds only its own stops. The first card is Grace Whitfield, the same pin the walkthrough points at, instead of an overdue contact from outside the area.

The copy of the prototype in the developer package was made before this fix. I'll refresh it if you want the package to match.

## User

Refresh it to match package. Lets build dark map. Add screen images to developer package.

## Assistant

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_html_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: show_html]_

_[tool: save_screenshot]_

_[tool: copy_files]_

_[tool: delete_file]_

_[tool: update_todos]_

_[tool: update_todos]_

_[tool: ready_for_verification]_

The dark map is built, and the prototype copy in the developer package now matches the latest version. The screen images aren't in the package yet: I stopped because the usage limit is almost reached.

- **Dark map:** in dark mode the map now uses a near-black ground, slightly lighter roads (main roads lighter still), dark buildings and muted green parks. Street labels are light gray, and the area outline and visited pins use the lighter dark-mode olive. Gold follow-up pins and white not-visited pins stand out well on it. Light mode is unchanged.
- **Developer package:** the prototype copy includes the walkthrough fix and the dark map.

Still to do:
- **Screen images:** I added a way to jump the prototype to any screen, so images of every screen in light and dark can be exported into the package.
- **Dark map spec:** the developer notes still say the dark map isn't designed and need its colors added.

Say "continue" and I'll finish both, then refresh the download.

## User

Continue

## Assistant

_[tool: show_html]_

_[tool: save_screenshot]_

## Assistant

_[tool: view_image]_

_[tool: delete_file]_

_[tool: show_html]_

_[tool: save_screenshot]_

_[tool: save_screenshot]_

_[tool: copy_files]_

_[tool: view_image]_

_[tool: delete_file]_

_[tool: view_image]_

Images look right. Now the README.

_[tool: str_replace_edit]_

_[tool: update_todos]_

_[tool: present_fs_item_for_download]_

The updated developer package is ready to download above. It now has 30 screen images and the dark map colors in its written spec.

- **Screens folder:** 25 light screens and 5 dark ones, numbered in the order a user moves through the app. They're scaled down to fit, so they're good for orientation; exact sizes and colors are in the written spec.
- **Spec:** the dark map now has its own table of light and dark colors, replacing the "not designed yet" note.

