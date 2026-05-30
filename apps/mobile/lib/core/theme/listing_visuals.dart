import 'package:flutter/material.dart';
import '../../data/models/enums.dart';
import 'app_colors.dart';

/// Visual helpers for a listing's kind — used by the smart placeholder when a
/// listing has no cover image, so a card never falls back to a flat grey box.
abstract final class ListingVisuals {
  static IconData icon(ListingKind kind) => switch (kind) {
        ListingKind.shop => Icons.storefront,
        ListingKind.service => Icons.handyman,
        ListingKind.transport => Icons.electric_rickshaw,
      };

  /// A soft brand gradient behind the placeholder icon.
  static const LinearGradient placeholderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryLight, AppColors.primaryDark],
  );
}
