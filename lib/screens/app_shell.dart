import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../state/solum_store.dart';
import '../theme/solum_theme.dart';
import '../widgets/solum_components.dart';
import 'contact_detail.dart';
import 'map/map_tab.dart';
import 'onboarding/onboarding_screens.dart';
import 'onboarding/welcome_screen.dart';
import 'sheets.dart';
import 'tabs.dart';

/// Root: onboarding steps, then the tabbed app with its overlay layers
/// (contact push, sheet + scrim, toast, directions chooser, paywall).
class SolumRoot extends StatelessWidget {
  const SolumRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final base = switch (store.step) {
      OnboardingStep.welcome => const WelcomeScreen(),
      OnboardingStep.how => const HowItWorksScreen(),
      OnboardingStep.location => const LocationScreen(),
      OnboardingStep.auth => const AuthScreen(),
      OnboardingStep.plans || OnboardingStep.done => const AppShell(),
    };
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedSwitcher(
              duration: SolumMotion.sheet,
              switchInCurve: SolumMotion.ease,
              child: KeyedSubtree(
                  key: ValueKey(store.step == OnboardingStep.plans ? OnboardingStep.done : store.step), child: base)),
        ),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !store.showPaywall,
            child: AnimatedSlide(
              duration: SolumMotion.sheet,
              curve: SolumMotion.ease,
              offset: store.showPaywall ? Offset.zero : const Offset(0, 1),
              child: store.showPaywall ? const PaywallScreen() : const SizedBox.shrink(),
            ),
          ),
        ),
        const _ToastLayer(),
      ],
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final sheetOpen = store.sheet != null;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: store.tab.index,
              children: const [MapTab(), FollowUpsTab(), ContactsTab(), SettingsTab()],
            ),
          ),
          const Positioned(left: 0, right: 0, bottom: 0, child: SolumTabBar()),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !store.contactOpen,
              child: AnimatedSlide(
                duration: SolumMotion.sheet,
                curve: SolumMotion.ease,
                offset: store.contactOpen ? Offset.zero : const Offset(1, 0),
                child: const ContactDetail(),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !sheetOpen,
              child: GestureDetector(
                onTap: store.closeSheet,
                child: AnimatedOpacity(
                  duration: SolumMotion.sheet,
                  curve: SolumMotion.ease,
                  opacity: sheetOpen ? 1 : 0,
                  child: ColoredBox(color: context.sc.scrim),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSwitcher(
              duration: SolumMotion.sheet,
              switchInCurve: SolumMotion.ease,
              switchOutCurve: SolumMotion.ease,
              transitionBuilder: (child, a) => SlideTransition(
                  position: Tween(begin: const Offset(0, 1.05), end: Offset.zero).animate(a), child: child),
              child: sheetOpen ? const SolumSheet() : const SizedBox.shrink(),
            ),
          ),
          if (store.directionsTarget != null) _DirectionsChooser(address: store.directionsTarget!),
        ],
      ),
    );
  }
}

/// 84px tab bar (incl. home indicator). Follow-ups shows a sol badge.
class SolumTabBar extends StatelessWidget {
  const SolumTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final tabs = [
      (AppTab.map, 'Map', LucideIcons.map),
      (AppTab.followUps, 'Follow-ups', LucideIcons.calendarClock),
      (AppTab.contacts, 'Contacts', LucideIcons.users),
      (AppTab.settings, 'Settings', LucideIcons.settings),
    ];
    final badge = store.followUpBadge;
    return Container(
      height: tabBarHeight(context),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: context.raised, border: Border(top: BorderSide(color: context.sandstone))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (t, label, icon) in tabs)
            Expanded(
              child: Semantics(
                button: true,
                selected: store.tab == t,
                label: label,
                excludeSemantics: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => store.setTab(t),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Icon(icon, size: 24, color: store.tab == t ? context.olive : context.inkMuted),
                            const SizedBox(height: 4),
                            Text(label,
                                style: TextStyle(
                                    fontFamily: SolumText.family,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    height: 16 / 13,
                                    color: store.tab == t ? context.olive : context.inkMuted)),
                          ],
                        ),
                      ),
                      if (t == AppTab.followUps && badge > 0)
                        Positioned(
                          top: 5,
                          left: 0,
                          right: 0,
                          child: Transform.translate(
                            offset: const Offset(16, 0),
                            child: Center(
                              child: Container(
                                constraints: const BoxConstraints(minWidth: 20),
                                height: 20,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: context.sc.sol,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                      color: context.raised, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
                                ),
                                child: Center(
                                    widthFactor: 1,
                                    child: Text('$badge',
                                        style: const TextStyle(
                                            fontFamily: SolumText.family,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13,
                                            height: 1,
                                            color: SolumPalette.onSol))),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToastLayer extends StatelessWidget {
  const _ToastLayer();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final t = store.toast;
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 2,
      left: 16,
      right: 16,
      child: AnimatedSwitcher(
        duration: SolumMotion.toggle,
        transitionBuilder: (c, a) => FadeTransition(
          opacity: a,
          child: SlideTransition(position: Tween(begin: const Offset(0, -0.3), end: Offset.zero).animate(a), child: c),
        ),
        child: t == null
            ? const SizedBox.shrink()
            : SolumToast(
                key: ValueKey(t.serial),
                text: t.text,
                actionLabel: t.undo ? 'Undo' : null,
                onAction: store.undo,
              ),
      ),
    );
  }
}

bool get _isAndroid => !kIsWeb && Platform.isAndroid;

/// 8. Directions: asks every time. iOS-style action sheet, Material sheet on Android.
class _DirectionsChooser extends StatelessWidget {
  const _DirectionsChooser({required this.address});
  final String address;

  @override
  Widget build(BuildContext context) {
    final store = context.read<SolumStore>();
    final pad = MediaQuery.paddingOf(context);
    if (_isAndroid) {
      return Positioned.fill(
        child: GestureDetector(
          onTap: store.closeDirections,
          child: ColoredBox(
            color: context.sc.scrim,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20, 20, 20, pad.bottom + 16),
                  decoration: BoxDecoration(
                    color: context.raised,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(SolumRadius.lg)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Get directions to $address', style: SolumText.small.copyWith(color: context.inkMuted)),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: Icon(LucideIcons.navigation, color: context.ink),
                        title: Text('Google Maps', style: SolumText.body.copyWith(color: context.ink)),
                        onTap: () => store.openDirections(MapsApp.google, android: true),
                      ),
                      ListTile(
                        leading: Icon(LucideIcons.map, color: context.ink),
                        title: Text('Apple Maps', style: SolumText.body.copyWith(color: context.ink)),
                        onTap: () => store.openDirections(MapsApp.apple, android: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Positioned.fill(
      child: GestureDetector(
        onTap: store.closeDirections,
        child: ColoredBox(
          color: const Color(0x52000000),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: pad.bottom),
              // System sheet: keeps the iOS system blue, not the app's olive.
              child: CupertinoTheme(
                data: const CupertinoThemeData(primaryColor: CupertinoColors.systemBlue),
                child: CupertinoActionSheet(
                  message: Text('Get directions to $address'),
                  actions: [
                    CupertinoActionSheetAction(
                        onPressed: () => store.openDirections(MapsApp.apple), child: const Text('Apple Maps')),
                    CupertinoActionSheetAction(
                        onPressed: () => store.openDirections(MapsApp.google), child: const Text('Google Maps')),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: store.closeDirections,
                    child: const Text('Cancel'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
