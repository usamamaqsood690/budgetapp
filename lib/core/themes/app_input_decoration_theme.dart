import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';

/// App Input Decoration Theme
/// Uses ColorScheme for automatic theme adaptation
class AppInputDecorationTheme {
  AppInputDecorationTheme._();

  /// Build input decoration theme from ColorScheme
  static InputDecorationTheme buildTheme(ColorScheme colorScheme) {
    final borderColor = colorScheme.outline;
    final errorColor = colorScheme.error;

    InputBorder activeBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: AppDimensions.borderWidthNormal,
      ),
      borderRadius: AppDimensions.borderRadiusMD,
      gapPadding: AppSpacing.xs,
    );

    InputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: AppDimensions.borderWidthThick,
      ),
      borderRadius: AppDimensions.borderRadiusMD,
      gapPadding: AppSpacing.xs,
    );

    InputBorder disabledBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor.withOpacity(0.38),
        width: AppDimensions.borderWidthNormal,
      ),
      borderRadius: AppDimensions.borderRadiusMD,
      gapPadding: AppSpacing.xs,
    );

    InputBorder errorBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: errorColor,
        width: AppDimensions.borderWidthNormal,
      ),
      borderRadius: AppDimensions.borderRadiusMD,
      gapPadding: AppSpacing.xs,
    );

    return InputDecorationTheme(
      border: activeBorder,
      enabledBorder: activeBorder,
      focusedBorder: focusedBorder,
      disabledBorder: disabledBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      isCollapsed: false,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      filled: true,
      fillColor: colorScheme.surface,
      hintStyle: TextStyle(color: colorScheme.onSurface),
      labelStyle: TextStyle(color: colorScheme.onSurface),
      errorStyle: TextStyle(color: errorColor),

    );
  }

  /// Light Input Decoration Theme (for backward compatibility)
  static InputDecorationTheme lightInputDecorationTheme() {
    return buildTheme(const ColorScheme.light());
  }

  /// Dark Input Decoration Theme (for backward compatibility)
  static InputDecorationTheme darkInputDecorationTheme() {
    return buildTheme(const ColorScheme.dark());
  }
}
