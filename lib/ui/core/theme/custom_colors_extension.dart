import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
class CustomColorsExtension extends ThemeExtension<CustomColorsExtension> {
  const CustomColorsExtension({
    required this.blue,
    required this.green,
    required this.orange,
    required this.success,
    required this.warning,
    required this.info,
    required this.progressLow,
    required this.progressMedium,
    required this.progressHigh,
    required this.shadow,
  });

  final Color blue;
  final Color green;
  final Color orange;
  final Color success;
  final Color warning;
  final Color info;
  final Color progressLow;
  final Color progressMedium;
  final Color progressHigh;
  final Color shadow;

  static const CustomColorsExtension light = CustomColorsExtension(
    blue: AppColors.blue,
    green: AppColors.green,
    orange: AppColors.orange,
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    progressLow: AppColors.progressLow,
    progressMedium: AppColors.progressMedium,
    progressHigh: AppColors.progressHigh,
    shadow: AppColors.shadow,
  );

  static const CustomColorsExtension dark = CustomColorsExtension(
    blue: AppColors.blue,
    green: AppColors.green,
    orange: AppColors.orange,
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    progressLow: AppColors.progressLow,
    progressMedium: AppColors.progressMedium,
    progressHigh: AppColors.progressHigh,
    shadow: AppColors.shadowDark,
  );

  @override
  CustomColorsExtension copyWith({
    Color? blue,
    Color? green,
    Color? orange,
    Color? success,
    Color? warning,
    Color? info,
    Color? progressLow,
    Color? progressMedium,
    Color? progressHigh,
    Color? shadow,
  }) {
    return CustomColorsExtension(
      blue: blue ?? this.blue,
      green: green ?? this.green,
      orange: orange ?? this.orange,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      progressLow: progressLow ?? this.progressLow,
      progressMedium: progressMedium ?? this.progressMedium,
      progressHigh: progressHigh ?? this.progressHigh,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  CustomColorsExtension lerp(ThemeExtension<CustomColorsExtension>? other, double t) {
    if (other is! CustomColorsExtension) {
      return this;
    }
    return CustomColorsExtension(
      blue: Color.lerp(blue, other.blue, t)!,
      green: Color.lerp(green, other.green, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      progressLow: Color.lerp(progressLow, other.progressLow, t)!,
      progressMedium: Color.lerp(progressMedium, other.progressMedium, t)!,
      progressHigh: Color.lerp(progressHigh, other.progressHigh, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}