import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';

/// App Checkbox Theme
/// Uses ColorScheme for automatic theme adaptation
class AppCheckboxTheme {
  AppCheckboxTheme._();

  /// Build checkbox theme from ColorScheme
  static CheckboxThemeData buildTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusXS),
      side: BorderSide(
        color: colorScheme.outline,
        width: AppDimensions.borderWidthNormal,
      ),
      checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return Colors.transparent;
      }),
    );
  }

  /// Light Checkbox Theme (for backward compatibility)
  static CheckboxThemeData get lightCheckboxTheme {
    // This will be set in app_theme.dart using buildTheme
    return buildTheme(const ColorScheme.light());
  }

  /// Dark Checkbox Theme (for backward compatibility)
  static CheckboxThemeData get darkCheckboxTheme {
    // This will be set in app_theme.dart using buildTheme
    return buildTheme(const ColorScheme.dark());
  }
}
