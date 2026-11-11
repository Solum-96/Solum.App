import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import 'auth_config.dart';
import 'services.dart';

/// Native Sign in with Apple (iOS) and Google (iOS + Android), exchanged for a
/// Supabase session with `signInWithIdToken`. Supabase persists and refreshes
/// the session, so [restoreSession] returns the seller on the next launch.
class SupabaseAuthService implements AuthService {
  SupabaseAuthService({SupabaseClient? client, GoogleSignIn? google})
      : _client = client ?? Supabase.instance.client,
        _google = google ?? GoogleSignIn.instance;

  final SupabaseClient _client;
  final GoogleSignIn _google;
  Future<void>? _googleInit;

  GoTrueClient get _auth => _client.auth;

  @override
  bool supports(AuthProvider p) => switch (p) {
        // Apple has no native Android SDK; Android shows Google only.
        AuthProvider.apple =>
          !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS),
        AuthProvider.google =>
          !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android),
      };

  @override
  Future<SolumUser?> restoreSession() async {
    final u = _auth.currentUser;
    return u == null ? null : _toSolumUser(u);
  }

  @override
  Future<SolumUser> signIn(AuthProvider provider) async {
    try {
      final user = switch (provider) {
        AuthProvider.apple => await _apple(),
        AuthProvider.google => await _googleSignIn(),
      };
      return _toSolumUser(user);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) throw const AuthCancelled();
      throw AuthFailure('Apple: ${e.code.name} ${e.message}');
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled || e.code == GoogleSignInExceptionCode.interrupted) {
        throw const AuthCancelled();
      }
      throw AuthFailure('Google: ${e.code.name} ${e.description ?? ''}');
    } on AuthApiException catch (e) {
      throw AuthFailure('Supabase: ${e.message}');
    }
  }

  Future<User> _apple() async {
    final rawNonce = _rawNonce();
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      nonce: sha256.convert(utf8.encode(rawNonce)).toString(),
    );
    final idToken = credential.identityToken;
    if (idToken == null) throw const AuthFailure('Apple returned no identity token.');
    final res = await _auth.signInWithIdToken(provider: OAuthProvider.apple, idToken: idToken, nonce: rawNonce);
    var user = res.user!;
    // Apple shares the name only on the first sign-in: keep it on the profile.
    final name = [credential.givenName, credential.familyName].whereType<String>().join(' ').trim();
    if (name.isNotEmpty && _nameOf(user) == null) {
      user = (await _auth.updateUser(UserAttributes(data: {'full_name': name}))).user ?? user;
    }
    return user;
  }

  Future<User> _googleSignIn() async {
    if (AuthConfig.googleWebClientId.isEmpty) {
      throw const AuthFailure('Google sign-in is not configured (GOOGLE_WEB_CLIENT_ID).');
    }
    _googleInit ??= _google.initialize(
      clientId: defaultTargetPlatform == TargetPlatform.iOS && AuthConfig.googleIosClientId.isNotEmpty
          ? AuthConfig.googleIosClientId
          : null,
      serverClientId: AuthConfig.googleWebClientId,
    );
    await _googleInit;
    final account = await _google.authenticate(scopeHint: const ['email', 'profile']);
    final idToken = account.authentication.idToken;
    if (idToken == null) throw const AuthFailure('Google returned no ID token.');
    final res = await _auth.signInWithIdToken(provider: OAuthProvider.google, idToken: idToken);
    return res.user!;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    try {
      if (_googleInit != null) await _google.signOut();
    } catch (_) {
      // Signing out of Google is best effort; the Supabase session is gone.
    }
  }

  static String? _nameOf(User u) {
    final m = u.userMetadata ?? const {};
    final n = (m['full_name'] ?? m['name']) as String?;
    return n == null || n.trim().isEmpty ? null : n.trim();
  }

  static SolumUser _toSolumUser(User u) {
    final email = u.email ?? '';
    final name = _nameOf(u) ?? (email.contains('@') ? email.split('@').first : 'Seller');
    return SolumUser(name: name, email: email, id: u.id);
  }

  static String _rawNonce([int length = 32]) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final r = Random.secure();
    return List.generate(length, (_) => chars[r.nextInt(chars.length)]).join();
  }
}
