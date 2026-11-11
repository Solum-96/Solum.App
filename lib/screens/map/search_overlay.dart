import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/address_repository.dart' show tokens;
import '../../data/models.dart';
import '../../state/solum_store.dart';
import '../../theme/solum_theme.dart';
import '../../widgets/solum_components.dart';

/// 7. Search from the map: contacts (name + street) and map addresses.
class SearchOverlay extends StatelessWidget {
  const SearchOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final hasQuery = tokens(store.query).isNotEmpty;
    final stops = store.searchStops();
    final addrs = hasQuery ? store.searchAddresses() : const <MapAddress>[];

    Widget rows(List<Stop> l) => ListCard(children: [
          for (var i = 0; i < l.length; i++)
            ContactRow(
              state: l[i].state,
              name: l[i].name,
              address: l[i].listLine,
              badge: SolumStore.badgeText(l[i]),
              divider: i < l.length - 1,
              onTap: () => store.pickStop(l[i].id),
            ),
        ]);

    Widget section(String label, Widget child) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [SolumLabel(label), const SizedBox(height: 8), child],
        );

    return Material(
      color: context.cs.surface,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 4, 16, 16),
        children: [
          Row(
            children: [
              Expanded(
                child: SolumTextField(
                  value: store.query,
                  onChanged: store.setQuery,
                  icon: LucideIcons.search,
                  placeholder: 'Name, street or address',
                  autofocus: true,
                ),
              ),
              const SizedBox(width: 8),
              SolumButton(
                  label: 'Cancel',
                  size: SolumButtonSize.sm,
                  variant: SolumButtonVariant.ghost,
                  onPressed: store.closeSearch),
            ],
          ),
          const SizedBox(height: 16),
          if (!hasQuery && store.todayList.isNotEmpty) section('People to see today', rows(store.todayList)),
          if (stops.isNotEmpty) ...[section('Your contacts', rows(stops)), const SizedBox(height: 16)],
          if (addrs.isNotEmpty)
            section(
              'Addresses',
              ListCard(children: [
                for (var i = 0; i < addrs.length; i++)
                  InkWell(
                    onTap: () => store.pickAddress(addrs[i]),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 64),
                      decoration: BoxDecoration(
                          border: i < addrs.length - 1 ? Border(bottom: BorderSide(color: context.sandstone)) : null),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: context.sandstone, shape: BoxShape.circle),
                            child: Icon(LucideIcons.mapPin, size: 18, color: context.ink),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(addrs[i].street, style: SolumText.bodyStrong.copyWith(color: context.ink)),
                                const SizedBox(height: 2),
                                Text(store.addresses.placeName,
                                    style: SolumText.small.copyWith(color: context.inkMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ]),
            ),
          if (hasQuery && stops.isEmpty && addrs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text('Nothing matches “${store.query}” in ${store.activeArea.name}.',
                  style: SolumText.body.copyWith(color: context.inkMuted)),
            ),
        ],
      ),
    );
  }
}
