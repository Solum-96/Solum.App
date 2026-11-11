// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Map top card (spec §6): area name + chevron, "37 of 43 visited", sol-tint
/// "3 today" pill, 8px progress bar. Switches to "Area complete" when
/// visited == total. Custom colors used: solTint.
class SolumProgressCard extends StatelessWidget {
  const SolumProgressCard({
    super.key,
    this.width,
    this.height,
    required this.areaName,
    required this.visited,
    required this.total,
    required this.todayCount,
    required this.openFollowUps,
    this.onAreaTap,
    this.onTodayTap,
  });

  final double? width;
  final double? height;
  final String areaName;
  final int visited;
  final int total;
  final int todayCount;
  final int openFollowUps;
  final Future Function()? onAreaTap;
  final Future Function()? onTodayTap;

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final complete = total > 0 && visited == total;
    const font = 'Plus Jakarta Sans';
    TextStyle s(double size, FontWeight w, Color c, [double ls = 0]) =>
        TextStyle(fontFamily: font, fontSize: size, fontWeight: w, color: c, letterSpacing: ls);
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x1A1F2421), blurRadius: 8, offset: Offset(0, 2)),
          BoxShadow(color: Color(0x141F2421), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            if (complete) ...[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: t.primary, shape: BoxShape.circle),
                child: Icon(Icons.check_rounded, color: t.info),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GestureDetector(
                  onTap: () => onAreaTap?.call(),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(areaName.toUpperCase(), style: s(13, FontWeight.w700, t.secondaryText, 0.78)),
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: t.secondaryText),
                  ]),
                ),
                const SizedBox(height: 2),
                Text(complete ? 'Area complete' : '$visited of $total visited',
                    style: s(20, FontWeight.w800, t.primaryText, -0.4)),
              ]),
            ),
            if (!complete && todayCount > 0)
              GestureDetector(
                onTap: () => onTodayTap?.call(),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: t.solTint, borderRadius: BorderRadius.circular(999)),
                  child: Row(children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: t.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF1F2421), width: 1.5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$todayCount today', style: s(14, FontWeight.w700, t.primaryText)),
                  ]),
                ),
              ),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : visited / total,
              minHeight: 8,
              color: t.primary,
              backgroundColor: t.alternate,
            ),
          ),
          if (complete) ...[
            const SizedBox(height: 10),
            Text(
              'All $total stops visited. ${openFollowUps > 0 ? '$openFollowUps ${openFollowUps == 1 ? 'follow-up' : 'follow-ups'} still open.' : 'No follow-ups open.'}',
              style: s(14, FontWeight.w500, t.secondaryText),
            ),
          ],
        ],
      ),
    );
  }
}
