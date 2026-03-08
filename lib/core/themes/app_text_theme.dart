import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';

/// App Typography System
/// Comprehensive text styles for the entire app
class AppTextTheme {
  AppTextTheme._();

  // Font Family
  static const String fontFamily = "inter";
  static const String fontFamilySecondary = "openSans";

  // Font Sizes
  static const double fontSize10 = 10.0;
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;
  static const double fontSize36 = 36.0;
  static const double fontSize40 = 40.0;
  static const double fontSize48 = 48.0;

  // Font Weights
  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;

  /// Build TextTheme from ColorScheme
  /// This ensures text colors are always consistent with the theme
  static TextTheme buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display Styles
      displayLarge: GoogleFonts.inter(
        fontSize: fontSize48,
        fontWeight: weightBold,
        color: colorScheme.onSurface,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: fontSize40,
        fontWeight: weightBold,
        color: colorScheme.onSurface,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: fontSize36,
        fontWeight: weightBold,
        color: colorScheme.onSurface,
        letterSpacing: 0,
      ),

      // Headline Styles
      headlineLarge: GoogleFonts.inter(
        fontSize: fontSize32,
        fontWeight: weightBold,
        color: colorScheme.onSurface,
        letterSpacing: 0,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: fontSize28,
        fontWeight: weightSemiBold,
        color: colorScheme.onSurface,
        letterSpacing: 0,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: fontSize24,
        fontWeight: weightSemiBold,
        color: colorScheme.onSurface,
        letterSpacing: 0,
      ),

      // Title Styles
      titleLarge: GoogleFonts.inter(
        fontSize: fontSize20,
        fontWeight: weightSemiBold,
        color: colorScheme.onSurface,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: fontSize18,
        fontWeight: weightMedium,
        color: colorScheme.onSurface,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: fontSize16,
        fontWeight: weightMedium,
        color: colorScheme.onSurface,
        letterSpacing: 0.1,
      ),

      // Body Styles
      bodyLarge: GoogleFonts.inter(
        fontSize: fontSize16,
        fontWeight: weightRegular,
        color: colorScheme.onSurface,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: fontSize14,
        fontWeight: weightRegular,
        color: colorScheme.onSurface,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: fontSize12,
        fontWeight: weightRegular,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 0.4,
      ),

      // Label Styles
      labelLarge: GoogleFonts.inter(
        fontSize: fontSize14,
        fontWeight: weightMedium,
        color: colorScheme.onSurface,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: fontSize12,
        fontWeight: weightMedium,
        color: colorScheme.onSurface,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: fontSize10,
        fontWeight: weightMedium,
        color: colorScheme.onSurface,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Light Theme Text Styles
  static TextTheme get lightTextTheme =>
      buildTextTheme(AppColorScheme.lightColorScheme);

  /// Dark Theme Text Styles
  static TextTheme get darkTextTheme =>
      buildTextTheme(AppColorScheme.darkColorScheme);
}

/// Extension for easy access to text styles in BuildContext
extension GetTextStyle on BuildContext {
  // Display Styles
  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;

  // Headline Styles
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;

  // Title Styles
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  // Body Styles
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  // Label Styles
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium;
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;

  // Legacy support (for backward compatibility)
  TextStyle interMedTextStyle() {
    return Theme.of(this).textTheme.bodyMedium ?? const TextStyle();
  }

  TextStyle interLargeTextStyle() {
    return Theme.of(this).textTheme.bodyLarge ?? const TextStyle();
  }
}
