import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../services/services.dart';
import '../state/solum_store.dart';
import '../theme/solum_theme.dart';
import '../widgets/solum_components.dart';

/// 18. Contact detail. Pushes from the right over the tabs.
class ContactDetail extends StatelessWidget {
  const ContactDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final c = store.stopById(store.contactId);
    if (c == null) return const SizedBox.shrink();
    final pad = MediaQuery.paddingOf(context);
    final (tone, badge) = switch (c.state) {
      StopState.followUp => (BadgeTone.followUp, SolumStore.dueLabel(c)),
      StopState.visited => (BadgeTone.visited, 'Visited'),
      StopState.unvisited => (BadgeTone.neutral, 'Not visited'),
    };
    final line = (c.isNamed ? c.street : store.addresses.placeName) + (c.phone.isNotEmpty ? ' · ${c.phone}' : '');

    return Material(
      color: context.cs.surface,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, pad.top + 2, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SolumIconButton(
                    icon: LucideIcons.chevronLeft,
                    label: 'Back',
                    variant: SolumIconButtonVariant.plain,
                    onPressed: store.closeContact),
                SolumButton(
                  label: 'Edit',
                  icon: LucideIcons.pencil,
                  size: SolumButtonSize.sm,
                  variant: SolumButtonVariant.ghost,
                  onPressed: () => store.openEdit(c.id),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                Row(children: [SolumMapPin(state: c.state), const SizedBox(width: 10), SolumBadge(badge, tone: tone)]),
                const SizedBox(height: 8),
                Text(c.name, style: SolumText.title.copyWith(color: context.ink)),
                const SizedBox(height: 8),
                Text(line, style: SolumText.small.copyWith(color: context.inkMuted)),
                if (c.email.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(c.email, style: SolumText.small.copyWith(color: context.inkMuted)),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SolumButton(
                      label: 'Call',
                      icon: LucideIcons.phone,
                      size: SolumButtonSize.sm,
                      variant: SolumButtonVariant.secondary,
                      onPressed: c.phone.isEmpty ? null : () => Contacting.call(c.phone),
                    ),
                    SolumButton(
                      label: 'Text',
                      icon: LucideIcons.messageSquare,
                      size: SolumButtonSize.sm,
                      variant: SolumButtonVariant.secondary,
                      onPressed: c.phone.isEmpty ? null : () => Contacting.text(c.phone),
                    ),
                    SolumButton(
                      label: 'Directions',
                      icon: LucideIcons.navigation,
                      size: SolumButtonSize.sm,
                      variant: SolumButtonVariant.secondary,
                      onPressed: () => store.askDirections(c.street),
                    ),
                  ],
                ),
                if (c.isFollowUp && c.note.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration:
                        BoxDecoration(color: context.sc.solTint, borderRadius: BorderRadius.circular(SolumRadius.md)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SolumLabel('What to say', color: context.ink),
                        const SizedBox(height: 6),
                        Text(c.note, style: SolumText.body.copyWith(color: context.ink)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: context.raised, borderRadius: BorderRadius.circular(SolumRadius.md)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Visits', style: SolumText.heading.copyWith(color: context.ink)),
                      const SizedBox(height: 4),
                      for (var i = 0; i < c.history.length; i++)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration:
                              BoxDecoration(border: i > 0 ? Border(top: BorderSide(color: context.sandstone)) : null),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 52,
                                  child:
                                      Text(c.history[i].day, style: SolumText.bodyStrong.copyWith(color: context.ink))),
                              const SizedBox(width: 12),
                              Expanded(
                                  child:
                                      Text(c.history[i].text, style: SolumText.body.copyWith(color: context.inkMuted))),
                            ],
                          ),
                        ),
                      if (c.history.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('No visits yet.', style: SolumText.body.copyWith(color: context.inkMuted)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, pad.bottom + 12),
            decoration: BoxDecoration(
              color: context.raised,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(SolumRadius.lg)),
              boxShadow: SolumShadows.sheet,
            ),
            child: Row(
              children: [
                Expanded(
                    child: SolumButton(
                        label: 'Log visit',
                        variant: SolumButtonVariant.dark,
                        fullWidth: true,
                        onPressed: () => store.openLog(c.id))),
                const SizedBox(width: 12),
                Expanded(
                    child: SolumButton(
                        label: 'Follow up',
                        variant: SolumButtonVariant.signal,
                        fullWidth: true,
                        onPressed: () => store.openFollow(c.id))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
