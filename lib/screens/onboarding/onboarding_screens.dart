import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../services/services.dart';
import '../../state/solum_store.dart';
import '../../theme/solum_theme.dart';
import '../../widgets/brand_marks.dart';
import '../../widgets/solum_components.dart';
import '../../widgets/solum_logo.dart';
import 'welcome_screen.dart';

/// Back button + step dots header (44 tall).
class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.onBack, this.step});
  final VoidCallback onBack;
  final int? step;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SolumIconButton(
                icon: LucideIcons.chevronLeft, label: 'Back', variant: SolumIconButtonVariant.plain, onPressed: onBack),
            if (step != null) StepDots(index: step!),
            const SizedBox(width: 44),
          ],
        ),
      );
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock(this.title, this.body);
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: SolumText.title.copyWith(color: context.ink)),
            const SizedBox(height: 8),
            Text(body, style: SolumText.body.copyWith(color: context.inkMuted)),
          ],
        ),
      );
}

/// 2. How it works.
class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<SolumStore>();
    Widget card(Widget visual, String title, String body) => Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: context.raised, borderRadius: BorderRadius.circular(SolumRadius.md)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 44, height: 44, child: Center(child: visual)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: SolumText.bodyStrong.copyWith(color: context.ink)),
                    const SizedBox(height: 4),
                    Text(body, style: SolumText.small.copyWith(color: context.inkMuted)),
                  ],
                ),
              ),
            ],
          ),
        );
    return OnboardingScaffold(
      children: [
        _StepHeader(onBack: () => store.goTo(OnboardingStep.welcome), step: 0),
        const _TitleBlock('How Solum works', 'Three habits that keep a territory moving.'),
        Column(
          children: [
            card(const AreaTile(size: 44, radius: 12), 'Outline your area',
                'Draw the streets you plan to cover and watch the count fill in.'),
            const SizedBox(height: 10),
            card(const SolumMapPin(state: StopState.visited), 'Mark every stop',
                'One tap logs a visit. Olive pins are done.'),
            const SizedBox(height: 10),
            card(const SolumMapPin(state: StopState.followUp), 'Follow up on time',
                'Gold pins are people to see. Solum reminds you that morning.'),
          ],
        ),
        const Spacer(),
        SolumButton(label: 'Continue', fullWidth: true, onPressed: () => store.goTo(OnboardingStep.location)),
      ],
    );
  }
}

/// 3. Location permission.
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<SolumStore>();
    final mc = context.mc;
    Widget road({double? top, double? left, double? w, double? h}) => Positioned(
          top: top,
          left: left,
          right: w == null ? 0 : null,
          bottom: h == null ? 0 : null,
          width: w,
          height: h,
          child: ColoredBox(color: mc.road),
        );
    return OnboardingScaffold(
      children: [
        _StepHeader(onBack: () => store.goTo(OnboardingStep.how), step: 1),
        ClipRRect(
          borderRadius: BorderRadius.circular(SolumRadius.lg),
          child: SizedBox(
            height: 300,
            child: ColoredBox(
              color: context.sc.sandstone,
              child: Stack(
                children: [
                  road(top: 96, left: 0, h: 12),
                  road(top: 196, left: 0, h: 10),
                  road(top: 0, left: 236, w: 10),
                  const Positioned(left: 60, top: 60, child: SolumMapPin(state: StopState.visited)),
                  const Positioned(left: 140, top: 140, child: SolumMapPin(state: StopState.followUp)),
                  const Positioned(left: 290, top: 60, child: SolumMapPin(state: StopState.unvisited)),
                  const Positioned(left: 300, top: 236, child: SolumMapPin(state: StopState.visited)),
                  Positioned(left: 176, top: 220, child: UserLocationDot(halo: mc.meHalo, size: 22, haloWidth: 10)),
                ],
              ),
            ),
          ),
        ),
        const _TitleBlock(
            'See the stops around you', 'Solum uses your location to center the map and show which doors are next.'),
        const Spacer(),
        Column(
          children: [
            SolumButton(
                label: 'Allow location',
                icon: LucideIcons.locateFixed,
                fullWidth: true,
                onPressed: store.allowLocation),
            const SizedBox(height: 8),
            SolumButton(
                label: 'Not now', variant: SolumButtonVariant.secondary, fullWidth: true, onPressed: store.startSignUp),
          ],
        ),
      ],
    );
  }
}

/// White dot with a basalt core and a soft olive halo.
class UserLocationDot extends StatelessWidget {
  const UserLocationDot({super.key, required this.halo, this.size = 18, this.haloWidth = 7});
  final Color halo;
  final double size;
  final double haloWidth;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: halo, spreadRadius: haloWidth)],
        ),
        alignment: Alignment.center,
        child: Container(
          width: size * 10 / 18,
          height: size * 10 / 18,
          decoration: const BoxDecoration(color: SolumPalette.basalt, shape: BoxShape.circle),
        ),
      );
}

/// 4. Create account / Sign in. Apple and Google only.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final signUp = store.authMode == AuthMode.signUp;
    return OnboardingScaffold(
      children: [
        _StepHeader(onBack: store.authBack, step: signUp ? 2 : null),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SolumRadius.lg),
            child: ColoredBox(color: context.olive, child: const Center(child: _DroppingMark())),
          ),
        ),
        _TitleBlock(
          signUp ? 'Create your account' : 'Welcome back',
          signUp ? 'Free to start. No card needed.' : 'Sign in with the account you used before.',
        ),
        Column(
          children: [
            SolumButton(
              label: 'Continue with Apple',
              variant: SolumButtonVariant.dark,
              leading: const AppleMark(size: 20),
              fullWidth: true,
              onPressed: () => store.signInWith(AuthProvider.apple),
            ),
            const SizedBox(height: 10),
            SolumButton(
              label: 'Continue with Google',
              variant: SolumButtonVariant.secondary,
              leading: const GoogleMark(size: 19),
              fullWidth: true,
              onPressed: () => store.signInWith(AuthProvider.google),
            ),
          ],
        ),
        Text('By continuing you agree to the Terms and Privacy Policy.',
            textAlign: TextAlign.center, style: SolumText.small.copyWith(color: context.inkMuted)),
      ],
    );
  }
}

/// The mark animating in: chalk bar grows (600 ms), sol dot drops (800 ms, 200 ms delay).
class _DroppingMark extends StatefulWidget {
  const _DroppingMark();

  @override
  State<_DroppingMark> createState() => _DroppingMarkState();
}

class _DroppingMarkState extends State<_DroppingMark> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _c.value = 1;
    } else if (_c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final ms = _c.value * 1000;
          final drop = SolumMotion.ease.transform(((ms - 200) / 800).clamp(0.0, 1.0));
          final grow = SolumMotion.ease.transform((ms / 600).clamp(0.0, 1.0));
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: drop,
                child: Transform.translate(
                  offset: Offset(0, -160 * (1 - drop)),
                  child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(color: SolumPalette.sol, shape: BoxShape.circle)),
                ),
              ),
              const SizedBox(height: 12),
              Transform.scale(
                scaleX: grow,
                child: Container(
                  width: 156,
                  height: 20,
                  decoration: BoxDecoration(color: SolumPalette.surface, borderRadius: BorderRadius.circular(999)),
                ),
              ),
            ],
          );
        },
      );
}

/// 5. Plans (paywall). Full screen; headline follows the context.
class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SolumStore>();
    final (title, sub) = SolumStore.paywallCopy(store.paywallContext);
    final pad = MediaQuery.paddingOf(context);
    return Material(
      color: context.cs.surface,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, pad.top + 2, 16, pad.bottom + 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SolumMarkLogo(height: 32),
                  SolumIconButton(
                    icon: LucideIcons.x,
                    label: 'Close',
                    variant: SolumIconButtonVariant.tint,
                    onPressed: () => store.endPaywall(startTrial: false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: SolumText.headline.copyWith(color: context.ink)),
                  const SizedBox(height: 8),
                  Text(sub, style: SolumText.body.copyWith(color: context.inkMuted)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SolumSegmented<Billing>(
              options: const [(Billing.monthly, 'Monthly'), (Billing.yearly, 'Yearly · save 25%')],
              value: store.billing,
              onChanged: store.setBilling,
            ),
            const SizedBox(height: 20),
            for (final o in PlanOffer.all) ...[
              _TierCard(
                  offer: o,
                  selected: store.planChoice == o.tier,
                  billing: store.billing,
                  onTap: () => store.choosePlan(o.tier)),
              const SizedBox(height: 10),
            ],
            const Spacer(),
            SolumButton(
              label: store.paywallCtaLabel,
              fullWidth: true,
              onPressed: () => store.endPaywall(startTrial: store.planChoice != PlanTier.free),
            ),
            const SizedBox(height: 10),
            Text(store.paywallFootnote,
                textAlign: TextAlign.center, style: SolumText.small.copyWith(color: context.inkMuted)),
          ],
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({required this.offer, required this.selected, required this.billing, required this.onTap});

  final PlanOffer offer;
  final bool selected;
  final Billing billing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final free = offer.tier == PlanTier.free;
    final price = free ? '\$0' : '\$${billing == Billing.yearly ? offer.yearly ~/ 12 : offer.monthly}';
    final per = free ? 'forever' : (billing == Billing.yearly ? '/mo, yearly' : '/month');
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: SolumMotion.toggle,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: context.raised,
            borderRadius: BorderRadius.circular(SolumRadius.md),
            border: Border.all(
                color: selected ? context.olive : Colors.transparent,
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: SolumMotion.toggle,
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: selected ? context.olive : context.sandstone, width: selected ? 7 : 2),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(offer.name, style: SolumText.heading.copyWith(color: context.ink)),
                        if (offer.popular) ...[
                          const SizedBox(width: 8),
                          Container(
                            height: 22,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: context.olive, borderRadius: BorderRadius.circular(SolumRadius.sm)),
                            child: Text('MOST POPULAR',
                                style: TextStyle(
                                    fontFamily: SolumText.family,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    letterSpacing: 0.66,
                                    color: context.onOlive)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(offer.description, style: SolumText.small.copyWith(color: context.inkMuted)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price,
                      style: TextStyle(
                          fontFamily: SolumText.family,
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                          height: 1,
                          letterSpacing: -0.78,
                          color: context.ink)),
                  const SizedBox(height: 2),
                  Text(per,
                      style: TextStyle(
                          fontFamily: SolumText.family,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: context.inkMuted)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
