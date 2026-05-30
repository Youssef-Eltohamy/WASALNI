import 'package:flutter/material.dart';

/// WASALNI palette — single source from return_to_zero/design_system.md.
abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF0D5C75);
  static const primaryDark = Color(0xFF082F3D);
  static const primaryLight = Color(0xFF14708C);
  static const accent = Color(0xFFFF7A45);
  static const whatsapp = Color(0xFF25D366);

  // Surfaces & text
  static const background = Color(0xFFF4F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFEAF1F4);
  static const text = Color(0xFF15252E);
  static const textMuted = Color(0xFF5B6B73);
  static const textDisabled = Color(0xFF9AAAB0);
  static const border = Color(0xFFD0DCE2);

  // Semantic
  static const success = Color(0xFF2E9E5B);
  static const verified = Color(0xFF1B4965);
  static const error = Color(0xFFD64545);
  static const prime = Color(0xFFE8A317);

  // Badge / pill surfaces (tinted backgrounds)
  static const villageSurface = Color(0xFFFFF1E8); // ⭐ في قريتك
  static const primeSurface = Color(0xFFFFF6DD); // 👑 برايم
}
