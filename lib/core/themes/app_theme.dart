import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_checkbox_theme.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_input_decoration_theme.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';

/// Main App Theme Configuration
/// Centralized theme management using Material 3 ColorScheme
/// Eliminates duplication by using a builder pattern
class AppTheme {
  AppTheme._();

  /// Build theme for a given brightness
  /// This eliminates code duplication between light and dark themes
  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme =
        brightness == Brightness.light
            ? AppColorScheme.lightColorScheme
            : AppColorScheme.darkColorScheme;

    final textTheme =
        brightness == Brightness.light
            ? AppTextTheme.lightTextTheme
            : AppTextTheme.darkTextTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      //Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.background,
        elevation: 16.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        width: 280.0,
      ),
      // Scaffold
      scaffoldBackgroundColor: colorScheme.background,

      // Typography
      fontFamily: AppTextTheme.fontFamily,
      textTheme: textTheme,

      // Input Decoration
      inputDecorationTheme: AppInputDecorationTheme.buildTheme(colorScheme),

      // Checkbox Theme
      checkboxTheme: AppCheckboxTheme.buildTheme(colorScheme),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.surface,
        titleSpacing: 0,
        surfaceTintColor: colorScheme.surface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppDimensions.iconXXL,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMD,
        ),
        color: colorScheme.surface,
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(
            double.infinity,
            AppDimensions.buttonHeightMD,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMD,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          minimumSize: const Size(
            double.infinity,
            AppDimensions.buttonHeightMD,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          side: BorderSide(
            color: colorScheme.primary,
            width: AppDimensions.borderWidthNormal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMD,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // Filled Button Theme (Material 3)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(
            double.infinity,
            AppDimensions.buttonHeightMD,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMD,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: AppDimensions.dividerThickness,
        space: AppSpacing.md,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: AppDimensions.iconLG,
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: AppDimensions.iconXXL,
          padding: AppSpacing.paddingAll(AppSpacing.sm),
          foregroundColor: colorScheme.onSurface,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: AppDimensions.cardElevationRaised,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusRound,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        barrierColor: colorScheme.surface.withOpacity(0.8),
        elevation: AppDimensions.cardElevationRaised,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusLG,
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMD,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        deleteIconColor: colorScheme.onSurfaceVariant,
        disabledColor: colorScheme.onSurface.withOpacity(0.12),
        selectedColor: colorScheme.primaryContainer,
        secondarySelectedColor: colorScheme.secondaryContainer,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        brightness: brightness,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusSM,
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.onSurface;
          }
          return colorScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceVariant;
        }),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        selectedColor: colorScheme.primary,
        selectedTileColor: colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMD,
        ),
      ),

      // Date Picker Theme
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surface,
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: colorScheme.onPrimary,
        dayStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
        weekdayStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        yearStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
        rangeSelectionBackgroundColor: colorScheme.primaryContainer,
        rangeSelectionOverlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primaryContainer;
          }
          return null;
        }),
        todayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.primary;
        }),
        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return colorScheme.onSurface.withOpacity(0.38);
          }
          if (states.contains(MaterialState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.onSurface;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusLG,
          side: BorderSide(
            color: colorScheme.outline,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        elevation: AppDimensions.cardElevationRaised,
        todayBorder: BorderSide(
          color: colorScheme.primary,
          width: AppDimensions.borderWidthThin,
        ),
      ),
    );
  }

  /// Light Theme Configuration
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  /// Dark Theme Configuration
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);
}
