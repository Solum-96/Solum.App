import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../state/solum_store.dart';
import '../theme/solum_theme.dart';
import '../widgets/solum_components.dart';
import 'tabs.dart' show areaRows, newAreaRow;

/// The one bottom sheet. Its content follows `store.sheet`; it slides up over
/// a scrim (280 ms) and closes on scrim tap or the x.
class SolumSheet extends StatelessWidget {
  const SolumSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final pad = MediaQuery.paddingOf(context);
    final insets = MediaQuery.viewInsetsOf(context);
    final body = switch (store.sheet) {
      SheetKind.logVisit => const _LogVisit(),
      SheetKind.followUp => const _FollowUp(),
      SheetKind.newContact => const _NewContact(),
      SheetKind.addByAddress => const _AddByAddress(),
      SheetKind.editContact => const _EditContact(),
      SheetKind.nameArea => const _NameArea(),
      SheetKind.areas => const _Areas(),
      SheetKind.limit => const _Limit(),
      null => const SizedBox.shrink(),
    };
    return Container(
      key: ValueKey(store.sheet),
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height - pad.top - 24),
      decoration: BoxDecoration(
        color: context.raised,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(SolumRadius.lg)),
        boxShadow: SolumShadows.sheet,
      ),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20 + (insets.bottom > 0 ? insets.bottom : pad.bottom)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(color: context.sandstone, borderRadius: BorderRadius.circular(999)),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(store.sheetTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SolumText.heading.copyWith(color: context.ink)),
                ),
                const SizedBox(width: 12),
                SolumIconButton(
                    icon: LucideIcons.x,
                    label: 'Close',
                    variant: SolumIconButtonVariant.tint,
                    onPressed: store.closeSheet),
              ],
            ),
            const SizedBox(height: 16),
            body,
          ],
        ),
      ),
    );
  }
}

Widget _gap(double h) => SizedBox(height: h);

Widget _chips(List<String> options, String value, ValueChanged<String> onTap) => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final o in options) SolumChip(label: o, selected: o == value, onTap: () => onTap(o))],
    );

Widget _labelled(String label, Widget child) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [SolumLabel(label), _gap(10), child],
    );

/// 9. Log visit.
class _LogVisit extends StatelessWidget {
  const _LogVisit();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final l = store.log;
    final notHome = l.outcome == 'Not home';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _labelled(
            'Outcome',
            _chips(LogForm.outcomes, l.outcome, (o) {
              l.outcome = o;
              store.touch();
            })),
        if (notHome) ...[
          _gap(16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(color: context.sc.solTint, borderRadius: BorderRadius.circular(SolumRadius.md)),
            child: SolumSwitch(
              label: 'Remind me to try again Friday',
              value: l.retry,
              onChanged: (v) {
                l.retry = v;
                store.touch();
              },
            ),
          ),
        ],
        _gap(16),
        SolumTextField(
          label: 'Note',
          multiline: true,
          placeholder: 'What to say next time',
          value: l.note,
          onChanged: (v) => l.note = v,
        ),
        _gap(16),
        SolumCheckbox(
          label: 'Left a flyer',
          value: l.flyer,
          onChanged: (v) {
            l.flyer = v;
            store.touch();
          },
        ),
        if (!(notHome && l.retry)) ...[
          _gap(4),
          SolumCheckbox(
            label: 'Set a follow-up next',
            value: l.followAfter,
            onChanged: (v) {
              l.followAfter = v;
              store.touch();
            },
          ),
        ],
        _gap(16),
        SolumButton(label: 'Save visit', fullWidth: true, onPressed: store.saveLog),
      ],
    );
  }
}

/// 10. Follow up.
class _FollowUp extends StatelessWidget {
  const _FollowUp();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final f = store.follow;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _labelled(
          'When',
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _chips(FollowForm.days, f.day, (o) {
                f.day = o;
                store.touch();
              }),
              _gap(10),
              _chips(FollowForm.times, f.time, (o) {
                f.time = o;
                store.touch();
              }),
            ],
          ),
        ),
        _gap(16),
        SolumTextField(
            label: 'What to say', placeholder: 'Bring the price sheet', value: f.note, onChanged: (v) => f.note = v),
        _gap(16),
        SolumSwitch(
          label: 'Remind me that morning',
          value: f.remind,
          onChanged: (v) {
            f.remind = v;
            store.touch();
          },
        ),
        _gap(16),
        SolumButton(
            label: store.followCta, variant: SolumButtonVariant.signal, fullWidth: true, onPressed: store.saveFollow),
      ],
    );
  }
}

/// 11. New contact (dropped pin or search result).
class _NewContact extends StatelessWidget {
  const _NewContact();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final a = store.add;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolumTextField(
          label: 'Name or business',
          placeholder: 'Maria Lopez',
          value: a.name,
          hint: a.touched && a.name.trim().isEmpty ? 'Add a name so you can find them later' : null,
          onChanged: (v) {
            a.name = v;
            if (a.touched) store.touch();
          },
        ),
        _gap(14),
        SolumTextField(label: 'Address', icon: LucideIcons.mapPin, value: a.address, onChanged: (v) => a.address = v),
        _gap(14),
        SolumTextField(
            label: 'Phone',
            placeholder: 'Optional',
            keyboardType: TextInputType.phone,
            value: a.phone,
            onChanged: (v) => a.phone = v),
        _gap(14),
        _labelled(
          'Status',
          Wrap(spacing: 8, children: [
            for (final (s, l) in const [(StopState.unvisited, 'Not visited'), (StopState.visited, 'Visited')])
              SolumChip(
                label: l,
                selected: a.status == s,
                onTap: () {
                  a.status = s;
                  store.touch();
                },
              ),
          ]),
        ),
        _gap(14),
        SolumButton(label: 'Save contact', fullWidth: true, onPressed: store.saveAdd),
      ],
    );
  }
}

/// Up to three map addresses under an address field.
class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.items, required this.suffix, required this.onPick});
  final List<MapAddress> items;
  final String suffix;
  final ValueChanged<MapAddress> onPick;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: context.cs.surface, borderRadius: BorderRadius.circular(SolumRadius.md)),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            InkWell(
              onTap: () => onPick(items[i]),
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                decoration: BoxDecoration(
                    border: i < items.length - 1 ? Border(bottom: BorderSide(color: context.sandstone)) : null),
                child: Row(
                  children: [
                    Icon(LucideIcons.mapPin, size: 18, color: context.inkMuted),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(text: items[i].street, style: const TextStyle(fontWeight: FontWeight.w700)),
                          TextSpan(text: ' · $suffix'),
                        ]),
                        style: SolumText.small.copyWith(color: context.ink),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 11b. Add by address (house not on the map).
class _AddByAddress extends StatelessWidget {
  const _AddByAddress();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final m = store.manual;
    final addrHint = m.touched && m.address.trim().isEmpty
        ? 'Add the street address'
        : m.snap != null
            ? 'Pinned at this address on the map'
            : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolumTextField(
          label: 'Name or business',
          placeholder: 'Maria Lopez',
          value: m.name,
          hint: m.touched && m.name.trim().isEmpty ? 'Add a name so you can find them later' : null,
          onChanged: (v) {
            m.name = v;
            if (m.touched) store.touch();
          },
        ),
        _gap(14),
        SolumTextField(
          label: 'Street address',
          icon: LucideIcons.mapPin,
          placeholder: '1620 SE Spokane St',
          value: m.address,
          hint: addrHint,
          onChanged: (v) {
            m.address = v;
            m.snap = null;
            store.touch();
          },
        ),
        _Suggestions(
          items: store.manualSuggestions,
          suffix: 'on the map',
          onPick: (a) {
            m.address = a.street;
            m.snap = a;
            store.touch();
          },
        ),
        _gap(14),
        SolumTextField(
            label: 'Phone',
            placeholder: 'Optional',
            keyboardType: TextInputType.phone,
            value: m.phone,
            onChanged: (v) => m.phone = v),
        if (m.snap == null) ...[
          _gap(14),
          _labelled(
            'Pin on the map',
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final (p, l) in const [(ManualPin.here, 'At my location'), (ManualPin.none, 'No pin')])
                SolumChip(
                  label: l,
                  selected: m.pin == p,
                  onTap: () {
                    m.pin = p;
                    store.touch();
                  },
                ),
            ]),
          ),
        ],
        _gap(14),
        SolumButton(label: 'Save contact', fullWidth: true, onPressed: store.saveManual),
      ],
    );
  }
}

/// 19. Edit contact.
class _EditContact extends StatelessWidget {
  const _EditContact();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final e = store.edit!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolumTextField(
            label: 'Name or business',
            placeholder: 'Leave blank to use the address',
            value: e.name,
            onChanged: (v) => e.name = v),
        _gap(14),
        SolumTextField(
          label: 'Address',
          icon: LucideIcons.mapPin,
          value: e.street,
          hint: e.snap != null ? 'The pin will move to this address' : 'Pick a match to move the pin',
          onChanged: (v) {
            e.street = v;
            e.snap = null;
            store.touch();
          },
        ),
        _Suggestions(
          items: store.editSuggestions,
          suffix: 'move pin here',
          onPick: (a) {
            e.street = a.street;
            e.snap = a;
            store.touch();
          },
        ),
        _gap(14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: SolumTextField(
                  label: 'Phone',
                  placeholder: 'Optional',
                  keyboardType: TextInputType.phone,
                  value: e.phone,
                  onChanged: (v) => e.phone = v),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 13,
              child: SolumTextField(
                  label: 'Email',
                  placeholder: 'Optional',
                  keyboardType: TextInputType.emailAddress,
                  value: e.email,
                  onChanged: (v) => e.email = v),
            ),
          ],
        ),
        _gap(14),
        SolumTextField(
          label: 'What to say',
          multiline: true,
          placeholder: 'Interested in a quote. Call after 5pm.',
          value: e.note,
          onChanged: (v) => e.note = v,
        ),
        _gap(14),
        SolumButton(label: 'Save changes', fullWidth: true, onPressed: store.saveEdit),
      ],
    );
  }
}

/// 12b. Name this area.
class _NameArea extends StatelessWidget {
  const _NameArea();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolumTextField(
          label: 'Area name',
          placeholder: 'SE Spokane St',
          value: store.areaName,
          hint: store.areaNameTouched && store.areaName.trim().isEmpty ? 'Give the area a name' : null,
          onChanged: (v) {
            store.areaName = v;
            if (store.areaNameTouched) store.touch();
          },
        ),
        _gap(16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: context.cs.surface, borderRadius: BorderRadius.circular(SolumRadius.md)),
          child: Row(
            children: [
              const AreaTile(size: 44, radius: 12),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${store.draftHomes.length} homes inside',
                        style: SolumText.count.copyWith(color: context.ink)),
                    const SizedBox(height: 2),
                    Text(store.draftHomesLine, style: SolumText.small.copyWith(color: context.inkMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
        _gap(16),
        Row(
          children: [
            Expanded(
                child: SolumButton(
                    label: 'Redraw',
                    variant: SolumButtonVariant.secondary,
                    fullWidth: true,
                    onPressed: store.redrawArea)),
            const SizedBox(width: 12),
            Expanded(child: SolumButton(label: 'Save area', fullWidth: true, onPressed: store.saveArea)),
          ],
        ),
      ],
    );
  }
}

/// 13. Your areas.
class _Areas extends StatelessWidget {
  const _Areas();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    return Column(children: [...areaRows(context, store), newAreaRow(context, store)]);
  }
}

/// 14. Plan limits.
class _Limit extends StatelessWidget {
  const _Limit();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final area = store.limitKind == LimitKind.area;
    final areaName = store.areas.isNotEmpty ? store.areas.first.name : 'Your area';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: context.sc.solTint, borderRadius: BorderRadius.circular(12)),
              child: Icon(area ? LucideIcons.map : LucideIcons.users, size: 22, color: context.ink),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                area
                    ? '$areaName is your one area on Free. Plus lets you outline up to 5, with coverage history for each. Try it free for 14 days.'
                    : 'Free holds up to 50 contacts. Plus holds 500 and adds 5 areas. Try it free for 14 days.',
                style: SolumText.body.copyWith(color: context.inkMuted),
              ),
            ),
          ],
        ),
        _gap(20),
        Row(
          children: [
            Expanded(
                child: SolumButton(
                    label: 'Not now',
                    variant: SolumButtonVariant.secondary,
                    fullWidth: true,
                    onPressed: store.closeSheet)),
            const SizedBox(width: 12),
            Expanded(child: SolumButton(label: 'See plans', fullWidth: true, onPressed: store.seePlans)),
          ],
        ),
      ],
    );
  }
}
