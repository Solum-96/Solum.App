// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens turn-by-turn directions in the app the seller picked.
/// [app] is "apple" or "google". The UI asks every time (spec §8).
/// Pubspec dependency: url_launcher.
Future<bool> openDirections(String address, String app) async {
  final q = Uri.encodeComponent(address);
  final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  final uri = app == 'apple'
      ? Uri.parse('https://maps.apple.com/?daddr=$q')
      : isAndroid
          ? Uri.parse('google.navigation:q=$q')
          : Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$q');
  try {
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return true;
  } catch (_) {}
  return launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$q'),
      mode: LaunchMode.externalApplication);
}
