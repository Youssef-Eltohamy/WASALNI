import 'package:flutter/material.dart';

/// Responsive helpers so the same screens read well on a narrow phone and a
/// wide web/tablet window. Breakpoints are width-based (logical pixels).
abstract final class Responsive {
  /// Max content width for forms/centred flows — keeps them from stretching
  /// edge-to-edge on wide windows.
  static const formMaxWidth = 480.0;

  /// Number of grid columns for card feeds, by available width.
  static int gridColumns(double width) {
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  /// Padding for a single-column form body that keeps content centred and
  /// capped at [formMaxWidth] on wide screens (extra width becomes side gutters).
  static EdgeInsets formPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final gutter = width > formMaxWidth ? (width - formMaxWidth) / 2 : 16.0;
    return EdgeInsets.symmetric(horizontal: gutter, vertical: 16);
  }
}

/// Centres its [child] and caps its width at [maxWidth] — use to wrap form
/// bodies so they stay readable on wide screens.
class CenteredConstrained extends StatelessWidget {
  const CenteredConstrained({
    super.key,
    required this.child,
    this.maxWidth = Responsive.formMaxWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
