// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Solum pin language (spec "Spacing, radius, size → Pins").
/// state: "unvisited" | "visited" | "followUp".
/// Theme: primary = olive, secondary = sol, tertiary = basalt,
/// primaryText = ink, secondaryBackground = surface raised.
class SolumMapPin extends StatelessWidget {
  const SolumMapPin({
    super.key,
    this.width,
    this.height,
    required this.state,
    this.selected = false,
  });

  final double? width;
  final double? height;
  final String state;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final followUp = state == 'followUp';
    final d = followUp ? 18.0 : 16.0;
    final Color fill = switch (state) {
      'visited' => t.primary,
      'followUp' => t.secondary,
      _ => t.secondaryBackground,
    };
    final Color? ring = switch (state) {
      'visited' => null,
      'followUp' => const Color(0xFF1F2421), // basalt, same in dark mode
      _ => t.primaryText,
    };
    final pin = Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: ring == null ? null : Border.all(color: ring, width: 3, strokeAlign: BorderSide.strokeAlignInside),
      ),
    );
    return SizedBox(
      width: width ?? 40,
      height: height ?? 40,
      child: Center(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          curve: const Cubic(0.2, 0.8, 0.2, 1),
          scale: selected ? 1.35 : 1,
          child: selected
              ? Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color(0x591F2421), blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: pin,
                )
              : pin,
        ),
      ),
    );
  }
}
