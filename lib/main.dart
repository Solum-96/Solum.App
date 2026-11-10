import 'package:flutter/material.dart';

import 'screens/map_home_screen.dart';
import 'theme/solum_theme.dart';

void main() => runApp(const SolumApp());

class SolumApp extends StatelessWidget {
  const SolumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solum',
      debugShowCheckedModeBanner: false,
      theme: solumLightTheme(),
      darkTheme: solumDarkTheme(),
      themeMode: ThemeMode.system,
      home: const MapHomeScreen(),
    );
  }
}
