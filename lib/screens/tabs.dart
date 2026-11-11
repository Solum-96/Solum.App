import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../state/solum_store.dart';
import '../theme/solum_theme.dart';
import '../widgets/solum_components.dart';
import 'map/map_tab.dart';

/// Scrolling page body for the non-map tabs (top 62, sides 16, above the tab bar).
class _TabPage extends StatelessWidget {
  const _TabPage({required this.children, this.gap = 16});
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 16, 16, tabBarHeight(context) + 24),
        children: [
          for (var i = 0; i < children.length; i++) ...[if (i > 0) SizedBox(height: gap), children[i]]
        ],
      );
}

List<Widget> _rows(SolumStore store, List<Stop> l) => [
      for (var i = 0; i < l.length; i++)
        ContactRow(
          state: l[i].state,
          name: l[i].name,
          address: l[i].listLine,
          badge: SolumStore.badgeText(l[i]),
          divider: i < l.length - 1,
          onTap: () => store.openContact(l[i].id),
        ),
    ];

Widget _section(String label, Widget child, {Widget? lead}) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          if (lead != null) ...[lead, const SizedBox(width: 8)],
          SolumLabel(label)
        ]),
        const SizedBox(height: 8),
        child,
      ],
    );

/// 16. Follow-ups tab: Overdue, Today, Later this week, reminder callout.
class FollowUpsTab extends StatelessWidget {
  const FollowUpsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final today = store.todayList, week = store.weekList, overdue = store.overdueList;
    return _TabPage(
      gap: 20,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SolumLabel(store.todayLabel),
            const SizedBox(height: 4),
            Text(
              today.isNotEmpty
                  ? '${today.length} ${today.length == 1 ? 'person' : 'people'} to see today'
                  : 'No one left to see today',
              style: SolumText.headline.copyWith(color: context.ink),
            ),
          ],
        ),
        if (overdue.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                const SolDot(size: 8),
                const SizedBox(width: 8),
                SolumLabel('Overdue', color: context.ink)
              ]),
              const SizedBox(height: 8),
              ListCard(solRing: true, children: _rows(store, overdue)),
            ],
          ),
        if (today.isNotEmpty)
          _section('Today', ListCard(children: _rows(store, today)))
        else
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: context.raised, borderRadius: BorderRadius.circular(SolumRadius.md)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good ground covered today.', style: SolumText.bodyStrong.copyWith(color: context.ink)),
                const SizedBox(height: 4),
                Text('No one left to see. New follow-ups show up here.',
                    style: SolumText.small.copyWith(color: context.inkMuted)),
              ],
            ),
          ),
        if (week.isNotEmpty) _section('Later this week', ListCard(children: _rows(store, week))),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: context.sc.solTint, borderRadius: BorderRadius.circular(SolumRadius.md)),
          child: Row(
            children: [
              Icon(LucideIcons.bell, size: 22, color: context.ink),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  store.morningReminder
                      ? 'Solum reminds you at 8:00 am on days with follow-ups.'
                      : 'Morning reminders are off. Turn them on in Settings.',
                  style: SolumText.small.copyWith(color: context.ink),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 17. Contacts tab: search, sort, list.
class ContactsTab extends StatelessWidget {
  const ContactsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final list = store.contactsSorted;
    return _TabPage(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Contacts', style: SolumText.title.copyWith(color: context.ink)),
            SolumIconButton(
                icon: LucideIcons.plus,
                label: 'Add contact',
                variant: SolumIconButtonVariant.tint,
                onPressed: store.openManual),
          ],
        ),
        SolumTextField(
          value: store.contactSearch,
          onChanged: (v) {
            store.contactSearch = v;
            store.touch();
          },
          icon: LucideIcons.search,
          placeholder: 'Search name or street',
        ),
        SolumSegmented<ContactSort>(
          height: 40,
          options: const [(ContactSort.status, 'Status'), (ContactSort.az, 'A–Z'), (ContactSort.recent, 'Recent')],
          value: store.sort,
          onChanged: (v) {
            store.sort = v;
            store.touch();
          },
        ),
        _section(
          store.contactsLabel,
          ListCard(children: [
            ..._rows(store, list),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text('No contacts match “${store.contactSearch}”.',
                    style: SolumText.body.copyWith(color: context.inkMuted)),
              ),
          ]),
        ),
      ],
    );
  }
}

/// 20. Settings: profile, plan, areas, automations, preferences.
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final free = store.plan == PlanTier.free;
    final muted = Colors.white.withValues(alpha: 0.72);
    Widget row(
            {required IconData icon,
            required String title,
            String? sub,
            Widget? trailing,
            bool divider = true,
            VoidCallback? onTap}) =>
        InkWell(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minHeight: sub != null ? 68 : 56),
            decoration: BoxDecoration(border: divider ? Border(bottom: BorderSide(color: context.sandstone)) : null),
            child: Row(
              children: [
                Icon(icon, size: 22, color: context.inkMuted),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: SolumText.body.copyWith(color: context.ink)),
                      if (sub != null) ...[
                        const SizedBox(height: 2),
                        Text(sub, style: SolumText.small.copyWith(color: context.inkMuted)),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 12), trailing],
              ],
            ),
          ),
        );

    final autos = [
      (LucideIcons.repeat, 'Retry not-home stops', 'Remind me 3 days later', false, 'retry', store.autoRetry),
      (LucideIcons.messageSquare, 'Text after a visit', 'Send a short thank-you', free, 'text', store.autoText),
      (LucideIcons.calendarCheck, 'Weekly coverage summary', 'Mondays at 8:00 am', free, 'weekly', store.autoWeekly),
    ];

    return _TabPage(
      children: [
        Text('Settings', style: SolumText.title.copyWith(color: context.ink)),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: context.raised, borderRadius: BorderRadius.circular(SolumRadius.md)),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: context.sc.basalt, shape: BoxShape.circle),
                child: Text(store.user.initial,
                    style: TextStyle(
                        fontFamily: SolumText.family,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: context.sc.onBasalt)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.user.name, style: SolumText.bodyStrong.copyWith(color: context.ink)),
                    const SizedBox(height: 2),
                    Text(store.user.email, style: SolumText.small.copyWith(color: context.inkMuted)),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 20, color: context.inkMuted),
            ],
          ),
        ),
        if (free)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: context.sc.basalt, borderRadius: BorderRadius.circular(SolumRadius.md)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SolumLabel('Free plan', color: muted),
                const SizedBox(height: 4),
                Text('${store.stops.length} of 50 contacts used',
                    style: SolumText.heading.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text('Plus adds 5 areas, 500 contacts and every automation.',
                    style: SolumText.small.copyWith(color: muted)),
                const SizedBox(height: 14),
                SolumProgressBar(
                  value: store.stops.length,
                  max: PlanLimits.freeContacts,
                  track: Colors.white.withValues(alpha: 0.16),
                  fill: SolumPalette.oliveOnBasalt,
                ),
                const SizedBox(height: 14),
                SolumButton(label: 'Try Plus free for 14 days', fullWidth: true, onPressed: store.openPaywall),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: context.raised, borderRadius: BorderRadius.circular(SolumRadius.md)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.plan == PlanTier.plus ? 'Solum Plus' : 'Solum Pro',
                          style: SolumText.bodyStrong.copyWith(color: context.ink)),
                      const SizedBox(height: 2),
                      Text('Free trial ends ${store.trialEndLabel}',
                          style: SolumText.small.copyWith(color: context.inkMuted)),
                    ],
                  ),
                ),
                const SolumBadge('Active', tone: BadgeTone.visited),
              ],
            ),
          ),
        _section(
            'Areas', ListCard(children: [...areaRows(context, store, settings: true), newAreaRow(context, store)])),
        _section(
          'Automations',
          ListCard(children: [
            for (var i = 0; i < autos.length; i++)
              row(
                icon: autos[i].$1,
                title: autos[i].$2,
                sub: autos[i].$3,
                divider: i < autos.length - 1,
                onTap: autos[i].$4 ? () => store.openPaywall(PaywallContext.automation) : null,
                trailing: autos[i].$4
                    ? const SolumBadge('Plus')
                    : SolumSwitch(value: autos[i].$6, onChanged: (v) => store.setAutomation(autos[i].$5, v)),
              ),
          ]),
        ),
        _section(
          'Preferences',
          ListCard(children: [
            row(
              icon: LucideIcons.moon,
              title: 'Dark mode',
              trailing: SolumSwitch(
                value: context.isDark,
                onChanged: (v) => store.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
              ),
            ),
            row(
              icon: LucideIcons.bell,
              title: 'Morning reminder',
              divider: false,
              trailing: SolumSwitch(value: store.morningReminder, onChanged: store.setMorningReminder),
            ),
          ]),
        ),
        SolumButton(
            label: 'Sign out', variant: SolumButtonVariant.secondary, fullWidth: true, onPressed: store.signOut),
        Text('Solum 1.0', textAlign: TextAlign.center, style: SolumText.small.copyWith(color: context.inkMuted)),
      ],
    );
  }
}

/// Area rows for Settings and the Your areas sheet.
List<Widget> areaRows(BuildContext context, SolumStore store, {bool settings = false}) => [
      for (final a in store.areas)
        InkWell(
          onTap: () => store.pickArea(a.id),
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.sandstone))),
            child: Row(
              children: [
                const AreaTile(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(a.name, style: SolumText.bodyStrong.copyWith(color: context.ink)),
                      const SizedBox(height: 2),
                      Text(store.areaSubtitle(a), style: SolumText.small.copyWith(color: context.inkMuted)),
                    ],
                  ),
                ),
                if (settings)
                  Icon(LucideIcons.chevronRight, size: 20, color: context.inkMuted)
                else if (a.id == store.activeAreaId)
                  Icon(LucideIcons.check, size: 22, color: context.olive),
              ],
            ),
          ),
        ),
    ];

Widget newAreaRow(BuildContext context, SolumStore store) => InkWell(
      onTap: store.startOutline,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        child: Row(
          children: [
            Icon(LucideIcons.plus, size: 22, color: context.olive),
            const SizedBox(width: 12),
            Text('Outline a new area', style: SolumText.bodyStrong.copyWith(color: context.olive)),
          ],
        ),
      ),
    );
