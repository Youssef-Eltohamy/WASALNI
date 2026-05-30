import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _family = 'Cairo';

  static const display = TextStyle(
    fontFamily: _family, fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.text);
  static const headline = TextStyle(
    fontFamily: _family, fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text);
  static const title = TextStyle(
    fontFamily: _family, fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text);
  static const body = TextStyle(
    fontFamily: _family, fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.text, height: 1.5);
  static const label = TextStyle(
    fontFamily: _family, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text);
  static const caption = TextStyle(
    fontFamily: _family, fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textMuted);
  static const labelSmall = TextStyle(
    fontFamily: _family, fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text);
}
