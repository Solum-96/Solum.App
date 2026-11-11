import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solum/main.dart';
import 'package:solum/screens/map/solum_map.dart';
import 'package:solum/services/services.dart';
import 'package:solum/state/solum_store.dart';

/// Scriptable auth for tests.
class FakeAuth implements AuthService {
  FakeAuth({this.apple = true, this.saved, this.error});
  final bool apple;
  final SolumUser? saved;
  Exception? error;
  int signOuts = 0;

  @override
  bool supports(AuthProvider p) => p == AuthProvider.google || apple;
  @override
  Future<SolumUser?> restoreSession() async => saved;
  @override
  Future<SolumUser> signIn(AuthProvider p) async {
    if (error != null) throw error!;
    return const SolumUser(name: 'Sam Rivera', email: 'sam@example.com', id: 'u1');
  }

  @override
  Future<void> signOut() async => signOuts++;
}

SolumStore _store(FakeAuth a, String start) => SolumStore(auth: a, start: start, now: DateTime(2026, 11, 10));

void main() {
  test('sign-up goes to plans with the real name', () async {
    final s = _store(FakeAuth(), 'signup');
    await s.signInWith(AuthProvider.google);
    expect(s.step, OnboardingStep.plans);
    expect(s.user.firstName, 'Sam');
    expect(s.signingIn, isFalse);
  });

  test('sign-in goes straight to the map', () async {
    final s = _store(FakeAuth(), 'welcome');
    s.startSignIn();
    await s.signInWith(AuthProvider.apple);
    expect(s.step, OnboardingStep.done);
    expect(s.toast!.text, 'Welcome back, Sam');
  });

  test('cancelling stays on the screen without a toast', () async {
    final s = _store(FakeAuth(error: const AuthCancelled()), 'signup');
    await s.signInWith(AuthProvider.google);
    expect(s.step, OnboardingStep.auth);
    expect(s.toast, isNull);
    expect(s.signingIn, isFalse);
  });

  test('a failure shows a calm toast and stays on the screen', () async {
    final s = _store(FakeAuth(error: const AuthFailure('network')), 'signup');
    await s.signInWith(AuthProvider.google);
    expect(s.step, OnboardingStep.auth);
    expect(s.toast!.text, 'Sign-in did not finish. Check your connection and try again.');
  });

  test('a saved session skips onboarding', () async {
    final s = _store(FakeAuth(saved: const SolumUser(name: 'Sam Rivera', email: 'sam@example.com')), '');
    expect(s.step, OnboardingStep.welcome);
    await s.restoreSession();
    expect(s.step, OnboardingStep.done);
    expect(s.user.initial, 'S');
  });

  test('sign out ends the session', () async {
    final a = FakeAuth();
    final s = _store(a, 'settings');
    await s.signOut();
    expect(a.signOuts, 1);
    expect(s.step, OnboardingStep.welcome);
  });

  testWidgets('Android: only Continue with Google', (tester) async {
    SolumMapConfig.showTiles = false;
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(402, 874), disableAnimations: true),
      child: SolumApp(store: _store(FakeAuth(apple: false), 'signup')),
    ));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsNothing);
  });
}
