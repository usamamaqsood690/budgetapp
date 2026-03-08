import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';

/// Helper class for semantic color access from ColorScheme
class ColorSchemeColors {
  final ColorScheme scheme;

  ColorSchemeColors(this.scheme);

  // Primary colors
  Color get primary => scheme.primary;
  Color get primaryContainer => scheme.primaryContainer;
  Color get onPrimary => scheme.onPrimary;
  Color get onPrimaryContainer => scheme.onPrimaryContainer;

  // Secondary colors
  Color get secondary => scheme.secondary;
  Color get secondaryContainer => scheme.secondaryContainer;
  Color get onSecondary => scheme.onSecondary;
  Color get onSecondaryContainer => scheme.onSecondaryContainer;

  // Tertiary colors
  Color get tertiary => scheme.tertiary;
  Color get tertiaryContainer => scheme.tertiaryContainer;
  Color get onTertiary => scheme.onTertiary;
  Color get onTertiaryContainer => scheme.onTertiaryContainer;

  // Error colors
  Color get error => scheme.error;
  Color get errorContainer => scheme.errorContainer;
  Color get onError => scheme.onError;
  Color get onErrorContainer => scheme.onErrorContainer;

  // Surface colors
  Color get surface => scheme.surface;
  Color get surfaceVariant => scheme.surfaceVariant;
  Color get onSurface => scheme.onSurface;
  Color get onSurfaceVariant => scheme.onSurfaceVariant;

  // Background colors
  Color get background => scheme.background;
  Color get onBackground => scheme.onBackground;

  // Outline colors
  Color get outline => scheme.outline;
  Color get outlineVariant => scheme.outlineVariant;

  // Shadow and scrim
  Color get shadow => scheme.shadow;
  Color get scrim => scheme.scrim;

  // Inverse colors
  Color get inverseSurface => scheme.inverseSurface;
  Color get onInverseSurface => scheme.onInverseSurface;
  Color get inversePrimary => scheme.inversePrimary;

  // Semantic colors (mapped from ColorScheme)
  Color get success => AppColorScheme.success;
  Color get warning => AppColorScheme.warning;
  Color get info => AppColorScheme.info;

  // Text colors (mapped from ColorScheme)
  Color get textPrimary => scheme.onSurface;
  Color get textSecondary => scheme.onSurfaceVariant;
  Color get textTertiary => scheme.outline;
  Color get textInverse => scheme.onInverseSurface;

  // UI element colors
  Color get divider => scheme.outlineVariant;
  Color get border => scheme.outline;
  Color get cardBackground => scheme.surface;
  Color get bottomNav => scheme.surface;
  Color get surfaceElevated => scheme.surfaceVariant;
  Color get backgroundSecondary => scheme.surfaceVariant;
  Color get strokeColor => scheme.outline;

  // Static colors (not theme-dependent)
  Color get white => AppColorScheme.primaryWhite;
  Color get black => Colors.black;
  Color get grey => AppColorScheme.primaryGrey;
  Color get greyDialog => Colors.grey.shade900;
  Color get transparent => AppColorScheme.transparent;

  // Gradient colors (static)
  // Color get gradientColor1 => AppColorScheme.gradientColor1;
  // Color get gradientColor2 => AppColorScheme.gradientColor2;
  // Color get gradientGreenColor => AppColorScheme.gradientGreenColor;
  // Color get gradientBlueColor => AppColorScheme.gradientBlueColor;
  // Color get backArrowBackground => AppColorScheme.backArrowBackground;
  // Color get cardShadowColor => AppColorScheme.cardShadowColor;

  // Additional primary colors
  Color get primaryDark => AppColorScheme.primaryDark;

  //Shimmer Colors
  Color get shimmerBaseColor => AppColorScheme.shimmerBaseColor;
  Color get shimmerHighlightColor => AppColorScheme.shimmerHighlightColor;
  Color get shimmerColor => AppColorScheme.shimmerColor;
}
