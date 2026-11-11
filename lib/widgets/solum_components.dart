// Solum design-system components for Flutter. Each mirrors a component in
// docs/design/prototype/_ds/.../_ds_bundle.js (same names, sizes and states).
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/models.dart';
import '../theme/solum_theme.dart';

/// Shorthands for theme colors. `context.cs.primary` is olive.
extension SolumContext on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;
  SolumColors get sc => SolumColors.of(this);
  SolumMapColors get mc => SolumMapColors.of(this);
  Color get raised => cs.surfaceContainerLowest;
  Color get ink => cs.onSurface;
  Color get inkMuted => cs.onSurfaceVariant;
  Color get sandstone => cs.outlineVariant;
  Color get olive => cs.primary;
  Color get onOlive => cs.onPrimary;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

// ------------------------------------------------------------------ Button

enum SolumButtonVariant { primary, dark, signal, secondary, ghost }

enum SolumButtonSize { lg, md, sm }

/// Pill button. lg 54 (primary actions), md 44, sm 36 visual with a 44 hit
/// area. Press: scale 0.98 and 8% darker, 120 ms.
class SolumButton extends StatefulWidget {
  const SolumButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = SolumButtonVariant.primary,
    this.size = SolumButtonSize.lg,
    this.icon,
    this.leading,
    this.fullWidth = false,
    this.shadow = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final SolumButtonVariant variant;
  final SolumButtonSize size;
  final IconData? icon;

  /// Custom leading widget (Apple / Google marks).
  final Widget? leading;
  final bool fullWidth;

  /// shadowFloat, for buttons floating over the map.
  final bool shadow;

  @override
  State<SolumButton> createState() => _SolumButtonState();
}

class _SolumButtonState extends State<SolumButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (widget.variant) {
      SolumButtonVariant.primary => (context.olive, context.onOlive, null),
      SolumButtonVariant.dark => (context.sc.basalt, context.sc.onBasalt, null),
      SolumButtonVariant.signal => (context.sc.sol, context.sc.onSol, null),
      SolumButtonVariant.secondary => (context.raised, context.ink, BorderSide(color: context.sandstone, width: 1.5)),
      SolumButtonVariant.ghost => (Colors.transparent, context.ink, null),
    };
    final (h, px, fs) = switch (widget.size) {
      SolumButtonSize.lg => (54.0, 24.0, 17.0),
      SolumButtonSize.md => (44.0, 20.0, 16.0),
      SolumButtonSize.sm => (44.0, 14.0, 14.0), // 36 in CSS, min 44 touch
    };
    final enabled = widget.onPressed != null;
    final pressed = _down && enabled;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.leading != null) ...[widget.leading!, const SizedBox(width: 8)],
        if (widget.icon != null) ...[Icon(widget.icon, size: h >= 54 ? 22 : 20, color: fg), const SizedBox(width: 8)],
        Flexible(
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: SolumText.family,
              fontWeight: FontWeight.w700,
              fontSize: fs,
              height: 1,
              letterSpacing: -0.005 * fs,
              color: fg,
            ),
          ),
        ),
      ],
    );
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapUp: enabled ? (_) => setState(() => _down = false) : null,
        onTapCancel: enabled ? () => setState(() => _down = false) : null,
        onTap: widget.onPressed,
        child: AnimatedOpacity(
          duration: SolumMotion.press,
          opacity: enabled ? 1 : 0.4,
          child: AnimatedScale(
            duration: SolumMotion.press,
            curve: SolumMotion.ease,
            scale: pressed ? 0.98 : 1,
            child: AnimatedContainer(
              duration: SolumMotion.press,
              height: h,
              width: widget.fullWidth ? double.infinity : null,
              padding: EdgeInsets.symmetric(horizontal: px),
              decoration: BoxDecoration(
                color: pressed && bg != Colors.transparent ? Color.lerp(bg, Colors.black, 0.08) : bg,
                borderRadius: BorderRadius.circular(SolumRadius.pill),
                border: border == null ? null : Border.fromBorderSide(border),
                boxShadow: widget.shadow ? SolumShadows.float : null,
              ),
              // Only full-width buttons stretch; others hug their label.
              alignment: widget.fullWidth ? Alignment.center : null,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------- IconButton

enum SolumIconButtonVariant { raised, plain, dark, tint }

/// 44px circular icon button. raised = floating over the map.
class SolumIconButton extends StatelessWidget {
  const SolumIconButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.variant = SolumIconButtonVariant.raised,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final SolumIconButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      SolumIconButtonVariant.raised => (context.raised, context.ink),
      SolumIconButtonVariant.plain => (Colors.transparent, context.ink),
      SolumIconButtonVariant.dark => (context.sc.basalt, context.sc.onBasalt),
      SolumIconButtonVariant.tint => (context.sandstone, context.ink),
    };
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Container(
            width: SolumSize.touchMin,
            height: SolumSize.touchMin,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              boxShadow: variant == SolumIconButtonVariant.raised ? SolumShadows.float : null,
            ),
            child: Icon(icon, size: 22, color: fg),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------- Chip

/// 44px filter / choice chip. Selected = olive fill.
class SolumChip extends StatelessWidget {
  const SolumChip(
      {super.key, required this.label, this.selected = false, this.onTap, this.count, this.floating = false});

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final int? count;

  /// shadowFloat, for chips over the map.
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? context.onOlive : context.ink;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: SolumMotion.press,
          height: SolumSize.chip,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? context.olive : context.raised,
            borderRadius: BorderRadius.circular(SolumRadius.pill),
            border: selected ? null : Border.all(color: context.sandstone, width: 1.5),
            boxShadow: floating ? SolumShadows.float : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: TextStyle(
                      fontFamily: SolumText.family, fontWeight: FontWeight.w700, fontSize: 14, height: 1, color: fg)),
              if (count != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white.withValues(alpha: 0.16) : context.cs.surface,
                    borderRadius: BorderRadius.circular(SolumRadius.pill),
                  ),
                  child: Text('$count',
                      style: TextStyle(
                          fontFamily: SolumText.family,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          height: 1,
                          color: fg)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------- Badge

enum BadgeTone { followUp, visited, neutral, dark }

class SolumBadge extends StatelessWidget {
  const SolumBadge(this.text, {super.key, this.tone = BadgeTone.neutral});

  final String text;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      BadgeTone.followUp => (context.sc.solTint, context.ink),
      BadgeTone.visited => (context.sc.visitedTint, context.olive),
      BadgeTone.neutral => (context.sandstone, context.ink),
      BadgeTone.dark => (context.sc.basalt, context.sc.onBasalt),
    };
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(SolumRadius.sm)),
      child: Text(text,
          maxLines: 1,
          style:
              TextStyle(fontFamily: SolumText.family, fontWeight: FontWeight.w700, fontSize: 13, height: 1, color: fg)),
    );
  }
}

// ------------------------------------------------------------------ MapPin

/// Pin language: unvisited = raised fill + 3px ink ring (16), visited = solid
/// olive (16), follow-up = sol + 3px basalt ring (18). Selected: ×1.35, 3px
/// white outline, drop shadow.
class SolumMapPin extends StatelessWidget {
  const SolumMapPin({super.key, required this.state, this.selected = false, this.size});

  final StopState state;
  final bool selected;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    final d = size ?? (state == StopState.followUp ? SolumSize.pinFollowUp : SolumSize.pin);
    final (fill, ring) = switch (state) {
      StopState.unvisited => (sc.pinNotVisited, sc.pinRing),
      StopState.visited => (sc.pinVisited, null),
      StopState.followUp => (sc.sol, sc.pinFollowUpRing),
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
    return Semantics(
      label: switch (state) {
        StopState.unvisited => 'Not visited',
        StopState.visited => 'Visited',
        StopState.followUp => 'Follow-up',
      },
      child: AnimatedScale(
        duration: SolumMotion.press,
        curve: SolumMotion.ease,
        scale: selected ? 1.35 : 1,
        child: selected
            ? Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle, boxShadow: SolumShadows.pinSelected),
                child: pin,
              )
            : pin,
      ),
    );
  }
}

// -------------------------------------------------------------- ContactRow

/// List row: pin, name, address line, optional badge, chevron.
class ContactRow extends StatelessWidget {
  const ContactRow({
    super.key,
    required this.state,
    required this.name,
    required this.address,
    this.badge,
    this.divider = true,
    this.onTap,
  });

  final StopState state;
  final String name;
  final String address;
  final String? badge;
  final bool divider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: divider ? Border(bottom: BorderSide(color: context.sandstone)) : null,
        ),
        child: Row(
          children: [
            SizedBox(width: 24, child: Center(child: SolumMapPin(state: state))),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SolumText.bodyStrong.copyWith(color: context.ink)),
                  const SizedBox(height: 2),
                  Text(address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SolumText.small.copyWith(color: context.inkMuted)),
                ],
              ),
            ),
            if (badge != null) ...[const SizedBox(width: 14), SolumBadge(badge!, tone: BadgeTone.followUp)],
            if (onTap != null) ...[
              const SizedBox(width: 14),
              Icon(LucideIcons.chevronRight, size: 20, color: context.inkMuted),
            ],
          ],
        ),
      ),
    );
  }
}

/// Raised, 16-radius card holding rows (horizontal padding 16).
class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.children, this.solRing = false});

  final List<Widget> children;

  /// 2px inset sol ring for the Overdue section.
  final bool solRing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.raised,
        borderRadius: BorderRadius.circular(SolumRadius.md),
        border: solRing ? Border.all(color: context.sc.sol, width: 2, strokeAlign: BorderSide.strokeAlignInside) : null,
      ),
      child: Column(children: children),
    );
  }
}

/// Uppercase 13/16 700 +0.06em label.
class SolumLabel extends StatelessWidget {
  const SolumLabel(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: SolumText.label.copyWith(color: color ?? context.inkMuted));
}

// --------------------------------------------------------------- TextField

/// Labelled field: 52 min height, raised fill, 1.5px sandstone border,
/// olive when focused, optional leading icon and hint below.
class SolumTextField extends StatefulWidget {
  const SolumTextField({
    super.key,
    this.label,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.icon,
    this.hint,
    this.multiline = false,
    this.rows = 2,
    this.keyboardType,
    this.autofocus = false,
    this.trailing,
  });

  final String? label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? placeholder;
  final IconData? icon;
  final String? hint;
  final bool multiline;
  final int rows;
  final TextInputType? keyboardType;
  final bool autofocus;
  final Widget? trailing;

  @override
  State<SolumTextField> createState() => _SolumTextFieldState();
}

class _SolumTextFieldState extends State<SolumTextField> {
  late final TextEditingController _c = TextEditingController(text: widget.value);
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(SolumTextField old) {
    super.didUpdateWidget(old);
    // Keep in sync when the store changes the value (e.g. picking a suggestion).
    if (widget.value != _c.text) {
      _c.value = TextEditingValue(text: widget.value, selection: TextSelection.collapsed(offset: widget.value.length));
    }
  }

  @override
  void dispose() {
    _c.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: _c,
      focusNode: _focus,
      onChanged: widget.onChanged,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType ?? (widget.multiline ? TextInputType.multiline : TextInputType.text),
      minLines: widget.multiline ? widget.rows : 1,
      maxLines: widget.multiline ? widget.rows + 2 : 1,
      style: SolumText.body.copyWith(color: context.ink),
      cursorColor: context.olive,
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: widget.placeholder,
        hintStyle: SolumText.body.copyWith(color: context.inkMuted),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[SolumLabel(widget.label!), const SizedBox(height: 6)],
        AnimatedContainer(
          duration: SolumMotion.press,
          constraints: const BoxConstraints(minHeight: 52),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: widget.multiline ? 14 : 0),
          decoration: BoxDecoration(
            color: context.raised,
            borderRadius: BorderRadius.circular(SolumRadius.md),
            border: Border.all(color: _focus.hasFocus ? context.olive : context.sandstone, width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: widget.multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 20, color: context.inkMuted),
                const SizedBox(width: 10),
              ],
              Expanded(child: field),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
        if (widget.hint != null && widget.hint!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(widget.hint!, style: SolumText.small.copyWith(color: context.inkMuted)),
        ],
      ],
    );
  }
}

// ------------------------------------------------------------------ Switch

/// 52×32 switch; optional label row (space-between, 44 min height).
class SolumSwitch extends StatelessWidget {
  const SolumSwitch({super.key, required this.value, required this.onChanged, this.label});

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final track = GestureDetector(
      onTap: () => onChanged(!value),
      child: Semantics(
        toggled: value,
        label: label,
        child: AnimatedContainer(
          duration: SolumMotion.toggle,
          curve: SolumMotion.ease,
          width: 52,
          height: 32,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? context.olive : context.sandstone,
            borderRadius: BorderRadius.circular(SolumRadius.pill),
          ),
          child: AnimatedAlign(
            duration: SolumMotion.toggle,
            curve: SolumMotion.ease,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0x331F2421), blurRadius: 2, offset: Offset(0, 1))],
              ),
            ),
          ),
        ),
      ),
    );
    if (label == null) return track;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Row(
          children: [
            Expanded(child: Text(label!, style: SolumText.body.copyWith(color: context.ink))),
            const SizedBox(width: 16),
            track,
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Checkbox

class SolumCheckbox extends StatelessWidget {
  const SolumCheckbox({super.key, required this.value, required this.onChanged, required this.label});

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Semantics(
        checked: value,
        label: label,
        excludeSemantics: true,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: SolumMotion.press,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: value ? context.olive : context.raised,
                  borderRadius: BorderRadius.circular(7),
                  border: value ? null : Border.all(color: context.ink, width: 2),
                ),
                child: value ? Icon(LucideIcons.check, size: 16, color: context.onOlive) : null,
              ),
              const SizedBox(width: 12),
              Text(label, style: SolumText.body.copyWith(color: context.ink)),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------- ProgressBar

class SolumProgressBar extends StatelessWidget {
  const SolumProgressBar({super.key, required this.value, required this.max, this.track, this.fill});

  final int value;
  final int max;
  final Color? track;
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    final pct = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return Semantics(
      value: '$value of $max',
      child: Container(
        height: 8,
        decoration: BoxDecoration(color: track ?? context.sandstone, borderRadius: BorderRadius.circular(999)),
        alignment: Alignment.centerLeft,
        child: LayoutBuilder(
          builder: (context, c) => AnimatedContainer(
            duration: SolumMotion.sheet,
            curve: SolumMotion.ease,
            width: c.maxWidth * pct,
            decoration: BoxDecoration(color: fill ?? context.olive, borderRadius: BorderRadius.circular(999)),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------- Toast

class SolumToast extends StatelessWidget {
  const SolumToast({super.key, required this.text, this.actionLabel, this.onAction});

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Semantics(
      liveRegion: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.only(left: 16, right: 8),
        decoration: BoxDecoration(
          color: sc.basalt,
          borderRadius: BorderRadius.circular(SolumRadius.md),
          boxShadow: SolumShadows.float,
        ),
        child: Row(
          children: [
            Icon(LucideIcons.circleCheck, size: 20, color: sc.sol),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(text, style: SolumText.toast.copyWith(color: sc.onBasalt)),
              ),
            ),
            if (actionLabel != null)
              GestureDetector(
                onTap: onAction,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  child: Text(actionLabel!,
                      style: TextStyle(
                          fontFamily: SolumText.family, fontWeight: FontWeight.w700, fontSize: 15, color: sc.sol)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------- Segmented

/// Sandstone pill track with raised selected segment (billing, contact sort).
class SolumSegmented<T> extends StatelessWidget {
  const SolumSegmented(
      {super.key, required this.options, required this.value, required this.onChanged, this.height = 44});

  final List<(T, String)> options;
  final T value;
  final ValueChanged<T> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: context.sandstone, borderRadius: BorderRadius.circular(SolumRadius.pill)),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(options[i].$1),
                child: Semantics(
                  button: true,
                  selected: options[i].$1 == value,
                  child: AnimatedContainer(
                    duration: SolumMotion.toggle,
                    height: height,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: options[i].$1 == value ? context.raised : Colors.transparent,
                      borderRadius: BorderRadius.circular(SolumRadius.pill),
                      boxShadow: options[i].$1 == value ? SolumShadows.float : null,
                    ),
                    child: Text(options[i].$2,
                        style: TextStyle(
                            fontFamily: SolumText.family,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1,
                            color: context.ink)),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// --------------------------------------------------------------- AreaTile

/// Dashed olive square on olive-12% fill: the "area" glyph.
class AreaTile extends StatelessWidget {
  const AreaTile({super.key, this.size = 28, this.radius = 8});
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: DashedRRectPainter(color: context.olive, fill: context.sc.areaFill, radius: radius),
      );
}

class DashedRRectPainter extends CustomPainter {
  DashedRRectPainter(
      {required this.color, required this.fill, this.radius = 8, this.width = 2, this.dash = 5, this.gap = 4});

  final Color color, fill;
  final double radius, width, dash, gap;

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)).deflate(width / 2);
    canvas.drawRRect(r, Paint()..color = fill);
    final path = Path()..addRRect(r);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    for (final m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, math.min(d + dash, m.length)), p);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedRRectPainter old) => old.color != color || old.fill != fill;
}

/// Step dots for onboarding (active = 22×6 olive pill).
class StepDots extends StatelessWidget {
  const StepDots({super.key, required this.index, this.count = 3});
  final int index;
  final int count;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            AnimatedContainer(
              duration: SolumMotion.toggle,
              width: i == index ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == index ? context.olive : context.sandstone,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ],
      );
}
