// Solum theme for Flutter.
//
// Values come from brand/tokens/tokens.json (the Solum design system).
// Change a value there first, then mirror it here. Never hard-code a brand
// color in a widget: use Theme.of(context).colorScheme, SolumColors.of(context)
// or SolumText.
import 'package:flutter/material.dart';

/// Raw brand palette. Prefer the theme accessors in widgets.
abstract final class SolumPalette {
  // Light
  static const surface = Color(0xFFFAF8F3); // Chalk
  static const surfaceRaised = Color(0xFFFFFFFF);
  static const sandstone = Color(0xFFE7DFD0);
  static const ink = Color(0xFF1F2421);
  static const inkMuted = Color(0xFF50564F);
  static const olive = Color(0xFF4D5B2E);
  static const onOlive = Color(0xFFFFFFFF);
  static const sol = Color(0xFFE9B949);
  static const onSol = Color(0xFF1F2421);
  static const solTint = Color(0xFFFBF0D3);
  static const basalt = Color(0xFF1F2421);
  static const onBasalt = Color(0xFFFFFFFF);

  // Dark
  static const surfaceDark = Color(0xFF171A18);
  static const surfaceRaisedDark = Color(0xFF222623);
  static const sandstoneDark = Color(0xFF3A3E38);
  static const inkDark = Color(0xFFF3F0E8);
  static const inkMutedDark = Color(0xFFB9BDB6);
  static const oliveDark = Color(0xFFA3B57A);
  static const onOliveDark = Color(0xFF171A18);
  static const solTintDark = Color(0xFF3D3420);

  // Outlined-area fill: olive at 12%.
  static const areaFill = Color(0x1F4D5B2E);
  static const areaFillDark = Color(0x1FA3B57A);
  static const scrim = Color(0x661F2421); // basalt at 40%
  /// Olive-light used on basalt (free-plan usage bar, coach "Skip").
  static const oliveOnBasalt = Color(0xFFA3B57A);
}

/// Map palette (docs/design/SPEC.md, "Map palette"). Read with
/// `SolumMapColors.of(context)`.
@immutable
class SolumMapColors extends ThemeExtension<SolumMapColors> {
  const SolumMapColors({
    required this.ground,
    required this.road,
    required this.majorRoad,
    required this.building,
    required this.green,
    required this.label,
    required this.halo,
    required this.attributionBg,
    required this.meHalo,
    required this.areaFill,
  });

  final Color ground, road, majorRoad, building, green, label, halo, attributionBg, meHalo;

  /// Outlined-area fill on the map (olive 12% light, olive-dark 14% dark).
  final Color areaFill;

  static const light = SolumMapColors(
    ground: Color(0xFFE7DFD0),
    road: Color(0xFFFAF8F3),
    majorRoad: Color(0xFFFAF8F3),
    building: Color(0xFFD6CFC1),
    green: Color(0xFFD3D0B7),
    label: Color(0xFF50564F),
    halo: Color(0xFFFAF8F3),
    attributionBg: Color(0xD9E7DFD0),
    meHalo: Color(0x384D5B2E),
    areaFill: Color(0x1F4D5B2E),
  );

  static const dark = SolumMapColors(
    ground: Color(0xFF1B1F1C),
    road: Color(0xFF2F342F),
    majorRoad: Color(0xFF3E443D),
    building: Color(0xFF252A26),
    green: Color(0xFF252C21),
    label: Color(0xFFB9BDB6),
    halo: Color(0xFF1B1F1C),
    attributionBg: Color(0xD91B1F1C),
    meHalo: Color(0x47A3B57A),
    areaFill: Color(0x24A3B57A),
  );

  static SolumMapColors of(BuildContext context) => Theme.of(context).extension<SolumMapColors>() ?? light;

  @override
  SolumMapColors copyWith() => this;

  @override
  SolumMapColors lerp(ThemeExtension<SolumMapColors>? other, double t) {
    if (other is! SolumMapColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return SolumMapColors(
      ground: l(ground, other.ground),
      road: l(road, other.road),
      majorRoad: l(majorRoad, other.majorRoad),
      building: l(building, other.building),
      green: l(green, other.green),
      label: l(label, other.label),
      halo: l(halo, other.halo),
      attributionBg: l(attributionBg, other.attributionBg),
      meHalo: l(meHalo, other.meHalo),
      areaFill: l(areaFill, other.areaFill),
    );
  }
}

abstract final class SolumSpace {
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0; // screen margin
  static const s5 = 20.0; // sheet and card padding
  static const s6 = 24.0;
  static const s8 = 32.0;
  static const s10 = 40.0;
  static const s12 = 48.0;
}

abstract final class SolumRadius {
  static const sm = 10.0; // badges
  static const md = 16.0; // cards, inputs
  static const lg = 24.0; // bottom sheets
  static const pill = 999.0; // buttons, chips
}

abstract final class SolumSize {
  static const touchMin = 44.0;
  static const buttonHeight = 54.0; // primary pills
  static const buttonMd = 44.0;
  static const chip = 44.0;
  static const icon = 24.0;
  static const tabBar = 84.0; // includes the home indicator
  static const pin = 16.0;
  static const pinFollowUp = 18.0;
}

/// Elevation. Flat by default; shadows only for UI floating over the map
/// ([float]) and bottom sheets ([sheet]).
abstract final class SolumShadows {
  static const float = [
    BoxShadow(color: Color(0x1A1F2421), blurRadius: 8, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x141F2421), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const sheet = [BoxShadow(color: Color(0x1A1F2421), blurRadius: 24, offset: Offset(0, -4))];
  static const pinSelected = [BoxShadow(color: Color(0x591F2421), blurRadius: 4, offset: Offset(0, 2))];
}

/// Motion. Ease-out, no bounce.
abstract final class SolumMotion {
  static const ease = Cubic(0.2, 0.8, 0.2, 1);
  static const press = Duration(milliseconds: 120);
  static const toggle = Duration(milliseconds: 200);
  static const sheet = Duration(milliseconds: 280);
  static const pan = Duration(milliseconds: 320);
  static const toast = Duration(milliseconds: 3500);
}

/// The Solum type scale. Plus Jakarta Sans only.
abstract final class SolumText {
  static const family = 'PlusJakartaSans';

  static const display =
      TextStyle(fontFamily: family, fontSize: 56, height: 1.0, fontWeight: FontWeight.w800, letterSpacing: -2.0);
  static const title =
      TextStyle(fontFamily: family, fontSize: 26, height: 32 / 26, fontWeight: FontWeight.w800, letterSpacing: -0.5);
  static const heading = TextStyle(fontFamily: family, fontSize: 20, height: 26 / 20, fontWeight: FontWeight.w700);
  static const bodyStrong = TextStyle(fontFamily: family, fontSize: 16, height: 22 / 16, fontWeight: FontWeight.w700);
  static const body = TextStyle(fontFamily: family, fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w400);
  static const small = TextStyle(fontFamily: family, fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w500);
  static const label =
      TextStyle(fontFamily: family, fontSize: 13, height: 16 / 13, fontWeight: FontWeight.w700, letterSpacing: 0.8);
  static const button = TextStyle(fontFamily: family, fontSize: 17, height: 1.2, fontWeight: FontWeight.w700);

  // Screen-level styles used by the v2 app (docs/design/SPEC.md).
  /// Tab and paywall headlines: 30/34 800 −0.03em.
  static const headline =
      TextStyle(fontFamily: family, fontSize: 30, height: 34 / 30, fontWeight: FontWeight.w800, letterSpacing: -0.9);

  /// Welcome headline: 34/38 800 −0.03em.
  static const welcome =
      TextStyle(fontFamily: family, fontSize: 34, height: 38 / 34, fontWeight: FontWeight.w800, letterSpacing: -1.02);

  /// Big counts ("37 of 43 visited"): 20/24 800 −0.02em.
  static const count =
      TextStyle(fontFamily: family, fontSize: 20, height: 24 / 20, fontWeight: FontWeight.w800, letterSpacing: -0.4);

  /// Toasts: 500 15/20.
  static const toast = TextStyle(fontFamily: family, fontSize: 15, height: 20 / 15, fontWeight: FontWeight.w500);
}

/// Brand colors that Material's ColorScheme has no slot for.
/// Read with `SolumColors.of(context)`.
@immutable
class SolumColors extends ThemeExtension<SolumColors> {
  const SolumColors({
    required this.sol,
    required this.onSol,
    required this.solTint,
    required this.sandstone,
    required this.inkMuted,
    required this.basalt,
    required this.onBasalt,
    required this.pinVisited,
    required this.pinNotVisited,
    required this.pinRing,
    required this.areaFill,
    required this.areaStroke,
    required this.pinFollowUpRing,
    required this.visitedTint,
    required this.scrim,
  });

  /// Follow-ups only: the logo dot, follow-up pins, the Follow up button.
  final Color sol;
  final Color onSol;
  final Color solTint;
  final Color sandstone;
  final Color inkMuted;

  /// Fixed dark brand ground. Stays dark in both themes.
  final Color basalt;
  final Color onBasalt;

  // Map pin language.
  final Color pinVisited;
  final Color pinNotVisited;
  final Color pinRing;
  final Color areaFill;
  final Color areaStroke;
  final Color pinFollowUpRing;

  /// Visited badge background: olive at 12%.
  final Color visitedTint;

  /// Behind modal sheets.
  final Color scrim;

  static const light = SolumColors(
    sol: SolumPalette.sol,
    onSol: SolumPalette.onSol,
    solTint: SolumPalette.solTint,
    sandstone: SolumPalette.sandstone,
    inkMuted: SolumPalette.inkMuted,
    basalt: SolumPalette.basalt,
    onBasalt: SolumPalette.onBasalt,
    pinVisited: SolumPalette.olive,
    pinNotVisited: SolumPalette.surfaceRaised,
    pinRing: SolumPalette.ink,
    areaFill: SolumPalette.areaFill,
    areaStroke: SolumPalette.olive,
    pinFollowUpRing: SolumPalette.basalt,
    visitedTint: SolumPalette.areaFill,
    scrim: SolumPalette.scrim,
  );

  static const dark = SolumColors(
    sol: SolumPalette.sol,
    onSol: SolumPalette.onSol,
    solTint: SolumPalette.solTintDark,
    sandstone: SolumPalette.sandstoneDark,
    inkMuted: SolumPalette.inkMutedDark,
    basalt: SolumPalette.basalt,
    onBasalt: SolumPalette.onBasalt,
    pinVisited: SolumPalette.oliveDark,
    pinNotVisited: SolumPalette.surfaceRaisedDark,
    pinRing: SolumPalette.inkDark,
    areaFill: SolumPalette.areaFillDark,
    areaStroke: SolumPalette.oliveDark,
    pinFollowUpRing: SolumPalette.basalt,
    visitedTint: SolumPalette.areaFillDark,
    scrim: SolumPalette.scrim,
  );

  static SolumColors of(BuildContext context) => Theme.of(context).extension<SolumColors>() ?? light;

  @override
  SolumColors copyWith({
    Color? sol,
    Color? onSol,
    Color? solTint,
    Color? sandstone,
    Color? inkMuted,
    Color? basalt,
    Color? onBasalt,
    Color? pinVisited,
    Color? pinNotVisited,
    Color? pinRing,
    Color? areaFill,
    Color? areaStroke,
    Color? pinFollowUpRing,
    Color? visitedTint,
    Color? scrim,
  }) {
    return SolumColors(
      sol: sol ?? this.sol,
      onSol: onSol ?? this.onSol,
      solTint: solTint ?? this.solTint,
      sandstone: sandstone ?? this.sandstone,
      inkMuted: inkMuted ?? this.inkMuted,
      basalt: basalt ?? this.basalt,
      onBasalt: onBasalt ?? this.onBasalt,
      pinVisited: pinVisited ?? this.pinVisited,
      pinNotVisited: pinNotVisited ?? this.pinNotVisited,
      pinRing: pinRing ?? this.pinRing,
      areaFill: areaFill ?? this.areaFill,
      areaStroke: areaStroke ?? this.areaStroke,
      pinFollowUpRing: pinFollowUpRing ?? this.pinFollowUpRing,
      visitedTint: visitedTint ?? this.visitedTint,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  SolumColors lerp(ThemeExtension<SolumColors>? other, double t) {
    if (other is! SolumColors) return this;
    return SolumColors(
      sol: Color.lerp(sol, other.sol, t)!,
      onSol: Color.lerp(onSol, other.onSol, t)!,
      solTint: Color.lerp(solTint, other.solTint, t)!,
      sandstone: Color.lerp(sandstone, other.sandstone, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      basalt: Color.lerp(basalt, other.basalt, t)!,
      onBasalt: Color.lerp(onBasalt, other.onBasalt, t)!,
      pinVisited: Color.lerp(pinVisited, other.pinVisited, t)!,
      pinNotVisited: Color.lerp(pinNotVisited, other.pinNotVisited, t)!,
      pinRing: Color.lerp(pinRing, other.pinRing, t)!,
      areaFill: Color.lerp(areaFill, other.areaFill, t)!,
      areaStroke: Color.lerp(areaStroke, other.areaStroke, t)!,
      pinFollowUpRing: Color.lerp(pinFollowUpRing, other.pinFollowUpRing, t)!,
      visitedTint: Color.lerp(visitedTint, other.visitedTint, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}

TextTheme _textTheme(Color ink, Color muted) {
  return TextTheme(
    displayMedium: SolumText.display.copyWith(color: ink),
    headlineSmall: SolumText.title.copyWith(color: ink),
    titleLarge: SolumText.heading.copyWith(color: ink),
    titleMedium: SolumText.bodyStrong.copyWith(color: ink),
    bodyLarge: SolumText.body.copyWith(color: ink),
    bodyMedium: SolumText.small.copyWith(color: ink),
    bodySmall: SolumText.small.copyWith(color: muted),
    labelLarge: SolumText.button.copyWith(color: ink),
    labelMedium: SolumText.label.copyWith(color: muted),
  );
}

ThemeData _build({
  required Brightness brightness,
  required Color surface,
  required Color surfaceRaised,
  required Color sandstone,
  required Color ink,
  required Color inkMuted,
  required Color primary,
  required Color onPrimary,
  required SolumColors extra,
  required SolumMapColors map,
}) {
  final scheme = ColorScheme(
    brightness: brightness,
    primary: primary,
    onPrimary: onPrimary,
    secondary: SolumPalette.sol,
    onSecondary: SolumPalette.onSol,
    tertiary: SolumPalette.basalt,
    onTertiary: SolumPalette.onBasalt,
    error: const Color(0xFFB42318),
    onError: const Color(0xFFFFFFFF),
    surface: surface,
    onSurface: ink,
    onSurfaceVariant: inkMuted,
    surfaceContainerLowest: surfaceRaised,
    surfaceContainerLow: surfaceRaised,
    surfaceContainer: surfaceRaised,
    surfaceContainerHigh: surfaceRaised,
    outline: inkMuted,
    outlineVariant: sandstone,
  );

  final pill = RoundedRectangleBorder(borderRadius: BorderRadius.circular(SolumRadius.pill));
  const buttonSize = Size(SolumSize.touchMin, SolumSize.buttonHeight);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    fontFamily: SolumText.family,
    scaffoldBackgroundColor: surface,
    textTheme: _textTheme(ink, inkMuted),
    extensions: <ThemeExtension<dynamic>>[extra, map],
    dividerColor: sandstone,
    materialTapTargetSize: MaterialTapTargetSize.padded,

    // Primary action: olive pill.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        minimumSize: buttonSize,
        shape: pill,
        textStyle: SolumText.button,
      ),
    ),
    // Secondary action: outlined pill in ink.
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        minimumSize: buttonSize,
        shape: pill,
        side: BorderSide(color: ink, width: 1.5),
        textStyle: SolumText.button,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        minimumSize: const Size(SolumSize.touchMin, SolumSize.touchMin),
        textStyle: SolumText.bodyStrong,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: SolumPalette.basalt,
      foregroundColor: SolumPalette.onBasalt,
      shape: CircleBorder(),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceRaised,
      selectedColor: primary,
      labelStyle: SolumText.small.copyWith(color: ink, fontWeight: FontWeight.w600),
      secondaryLabelStyle: SolumText.small.copyWith(color: onPrimary, fontWeight: FontWeight.w700),
      side: BorderSide(color: sandstone),
      shape: pill,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceRaised,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: sandstone,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(SolumRadius.lg)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceRaised,
      hintStyle: SolumText.body.copyWith(color: inkMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: SolumSpace.s4, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SolumRadius.md),
        borderSide: BorderSide(color: sandstone),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SolumRadius.md),
        borderSide: BorderSide(color: sandstone),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SolumRadius.md),
        borderSide: BorderSide(color: primary, width: 2),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: sandstone,
      linearMinHeight: 8,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceRaised,
      surfaceTintColor: Colors.transparent,
      indicatorColor: sandstone,
      labelTextStyle: WidgetStatePropertyAll(SolumText.label.copyWith(letterSpacing: 0, color: ink)),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 24,
          color: states.contains(WidgetState.selected) ? ink : inkMuted,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: SolumPalette.basalt,
      contentTextStyle: SolumText.small.copyWith(color: SolumPalette.onBasalt),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SolumRadius.md)),
    ),
  );
}

/// Light theme: Chalk ground, olive primary, sol for follow-ups.
ThemeData solumLightTheme() => _build(
      brightness: Brightness.light,
      surface: SolumPalette.surface,
      surfaceRaised: SolumPalette.surfaceRaised,
      sandstone: SolumPalette.sandstone,
      ink: SolumPalette.ink,
      inkMuted: SolumPalette.inkMuted,
      primary: SolumPalette.olive,
      onPrimary: SolumPalette.onOlive,
      extra: SolumColors.light,
      map: SolumMapColors.light,
    );

/// Dark theme. Basalt and sol keep their values.
ThemeData solumDarkTheme() => _build(
      brightness: Brightness.dark,
      surface: SolumPalette.surfaceDark,
      surfaceRaised: SolumPalette.surfaceRaisedDark,
      sandstone: SolumPalette.sandstoneDark,
      ink: SolumPalette.inkDark,
      inkMuted: SolumPalette.inkMutedDark,
      primary: SolumPalette.oliveDark,
      onPrimary: SolumPalette.onOliveDark,
      extra: SolumColors.dark,
      map: SolumMapColors.dark,
    );
