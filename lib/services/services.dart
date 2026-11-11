import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models.dart';

/// Signed-in seller.
@immutable
class SolumUser {
  const SolumUser({required this.name, required this.email, this.id});
  final String name;
  final String email;

  /// Backend user ID (Supabase `auth.users.id`); null in demo mode.
  final String? id;
  String get firstName => name.split(' ').first;
  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();
}

enum AuthProvider { apple, google }

/// The seller closed the Apple/Google sheet. Not an error: stay on the screen.
class AuthCancelled implements Exception {
  const AuthCancelled();
}

/// Sign-in failed. [detail] is for logs, not for the UI.
class AuthFailure implements Exception {
  const AuthFailure(this.detail);
  final String detail;
  @override
  String toString() => 'AuthFailure: $detail';
}

/// Sign in with Apple / Google only (no email or password).
/// Real implementation: [SupabaseAuthService] in supabase_auth_service.dart.
abstract class AuthService {
  /// Whether this platform offers [provider] (Apple is iOS only).
  bool supports(AuthProvider provider);

  /// The seller from a saved session, or null if signed out.
  Future<SolumUser?> restoreSession();

  /// Throws [AuthCancelled] or [AuthFailure].
  Future<SolumUser> signIn(AuthProvider provider);
  Future<void> signOut();
}

/// Offline stand-in for tests, screenshots and usability sessions.
class DemoAuthService implements AuthService {
  @override
  bool supports(AuthProvider provider) => true;

  @override
  Future<SolumUser?> restoreSession() async => null;

  @override
  Future<SolumUser> signIn(AuthProvider provider) async => SolumUser(
        name: 'Dana Ortiz',
        email: provider == AuthProvider.google ? 'dana.ortiz@gmail.com' : 'dana.ortiz@mail.com',
      );

  @override
  Future<void> signOut() async {}
}

/// Subscriptions. Production: RevenueCat or `in_app_purchase`.
abstract class PurchaseService {
  /// Starts a 14-day trial for [tier]. Returns the trial end date.
  Future<DateTime> startTrial(PlanTier tier, Billing billing);
}

class DemoPurchaseService implements PurchaseService {
  @override
  Future<DateTime> startTrial(PlanTier tier, Billing billing) async => DateTime.now().add(const Duration(days: 14));
}

/// Device location. Production: `geolocator` (+ Info.plist / AndroidManifest
/// permission strings: "Your location centers the map and shows nearby stops.").
abstract class LocationService {
  Future<bool> requestPermission();
  Future<LatLng> current();
}

class DemoLocationService implements LocationService {
  DemoLocationService(this.position);
  final LatLng position;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<LatLng> current() async => position;
}

enum MapsApp { apple, google }

/// Opens turn-by-turn directions. The app asks every time which app to use.
class Directions {
  static Uri uri(MapsApp app, String address, {bool android = false}) {
    final q = Uri.encodeComponent(address);
    return switch (app) {
      MapsApp.apple => Uri.parse('https://maps.apple.com/?daddr=$q'),
      MapsApp.google => android
          ? Uri.parse('google.navigation:q=$q')
          : Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$q'),
    };
  }

  static Future<bool> open(MapsApp app, String address, {bool android = false}) async {
    final u = uri(app, address, android: android);
    try {
      if (await launchUrl(u, mode: LaunchMode.externalApplication)) return true;
    } catch (_) {}
    // Fall back to the web URL if the native scheme is not handled.
    if (app == MapsApp.google && android) {
      return launchUrl(uri(app, address), mode: LaunchMode.externalApplication);
    }
    return false;
  }
}

/// Calls and texts from the contact page.
class Contacting {
  static Future<void> call(String phone) => launchUrl(Uri(scheme: 'tel', path: _digits(phone)));
  static Future<void> text(String phone) => launchUrl(Uri(scheme: 'sms', path: _digits(phone)));
  static String _digits(String p) => p.replaceAll(RegExp(r'[^\d+]'), '');
}
