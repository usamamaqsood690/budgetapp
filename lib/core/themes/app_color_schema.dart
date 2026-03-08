import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color.dart';

/// App Color Scheme
/// Clean, unified color system using Material 3 ColorScheme
class AppColorScheme {
  AppColorScheme._();
  static const Color transparent = Colors.transparent;

  // Primary Colors
  static const Color primaryColor = Color(0xFF1D9A91);
  static const Color primaryDark = Color(0xff004943);
  static const Color primarySeed = primaryColor;
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color primaryGrey = Color(0xFF7C7C7C);

  // Semantic Colors
  static const Color success = Color(0xFF01CE34);
  static const Color error = Color(0xFFDA3939);
  static const Color warning = Color(0xFFFFF200);
  static const Color info = Color(0xff3DAAE0);

  // // Gradient Colors (Static - not theme-dependent)
  // static const Color gradientColor1 = Color(0xFF0C3633);
  // static const Color gradientColor2 = Color(0xffDCDDD7);
  // static const Color gradientGreenColor = Color(0xFF318578);
  // static const Color gradientBlueColor = Color(0xFF799BE4);
  // static const Color backArrowBackground = Color(0xff819afd);
  // static const Color cardShadowColor = Color(0x268271ee);

  // Shimmer colors
  static final Color shimmerBaseColor = Colors.grey[800]!;
  static final Color shimmerHighlightColor = Colors.grey[600]!;
  static final Color shimmerColor = Colors.grey[900]!;

  /// Light Theme ColorScheme
  static ColorScheme get lightColorScheme {
    return ColorScheme(
      brightness: Brightness.light,

      // Primary Colors
      primary: primarySeed,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFB2DFD9),
      onPrimaryContainer: Color(0xFF002018),

      // Primary Fixed Colors (Material 3.5)
      primaryFixed: Color(0xFFB2DFD9),
      primaryFixedDim: Color(0xFF97C3BD),
      onPrimaryFixed: Color(0xFF002018),
      onPrimaryFixedVariant: Color(0xFF004943),

      // Secondary Colors
      secondary: const Color(0xFF318519),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFB8F397),
      onSecondaryContainer: Color(0xFF0A2000),

      // Secondary Fixed Colors (Material 3.5)
      secondaryFixed: Color(0xFFB8F397),
      secondaryFixedDim: Color(0xFF9DD77C),
      onSecondaryFixed: Color(0xFF0A2000),
      onSecondaryFixedVariant: Color(0xFF1B4D00),

      // Tertiary Colors
      tertiary: const Color(0xFF799BE4),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFDDE3FF),
      onTertiaryContainer: Color(0xFF001C3B),

      // Tertiary Fixed Colors (Material 3.5)
      tertiaryFixed: Color(0xFFDDE3FF),
      tertiaryFixedDim: Color(0xFFB8C7FF),
      onTertiaryFixed: Color(0xFF001C3B),
      onTertiaryFixedVariant: Color(0xFF003C7E),

      // Error Colors
      error: error,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),

      // Surface Colors
      surface: Colors.white,
      onSurface: const Color(0xFF4F4F4F),
      surfaceVariant: const Color(0xFFF5F5F5),
      onSurfaceVariant: Colors.transparent,

      // Surface Container Colors
      surfaceDim: Color(0xFFE8E8E8),
      surfaceBright: Colors.white,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Color(0xFFFAFAFA),
      surfaceContainer: Color(0xFFF5F5F5),
      surfaceContainerHigh: Color(0xFFEEEEEE),
      surfaceContainerHighest: Color(0xFFE0E0E0),

      // Outline Colors
      outline: Colors.black,
      outlineVariant: const Color(0xFFE0DEF1),

      // Shadow & Scrim
      shadow: Colors.black.withOpacity(0.1),
      scrim: Colors.black.withOpacity(0.5),

      // Inverse Colors
      inverseSurface: Colors.black,
      onInverseSurface: Colors.white,
      inversePrimary: primarySeed,

      // Surface Tint
      surfaceTint: primarySeed,
    );
  }

  /// Dark Theme ColorScheme
  static ColorScheme get darkColorScheme {
    return ColorScheme(
      brightness: Brightness.dark,

      // Primary Colors
      primary: primaryColor,
      onPrimary: primaryWhite,
      primaryContainer: Color(0xFF0C6556),
      onPrimaryContainer: Color(0xFF979C9E),

      // Primary Fixed Colors
      // primaryFixed: Color(0xFFB2DFD9),
      // primaryFixedDim: Color(0xFF97C3BD),
      // onPrimaryFixed: Color(0xFF002018),
      // onPrimaryFixedVariant: Color(0xFF00504A),

      // Secondary Colors
      secondary: const Color(0xFF318578),
      onSecondary: primaryGrey,
      // secondaryContainer: Color(0xFF1B4D00),
      // onSecondaryContainer: Color(0xFFB8F397),

      // Secondary Fixed Colors
      // secondaryFixed: Color(0xFFB8F397),
      // secondaryFixedDim: Color(0xFF9DD77C),
      // onSecondaryFixed: Color(0xFF0A2000),
      // onSecondaryFixedVariant: Color(0xFF1B4D00),

      // Tertiary Colors
      // tertiary: const Color(0xFF799BE4),
      // onTertiary: Colors.white,
      // tertiaryContainer: Color(0xFF003C7E),
      // onTertiaryContainer: Color(0xFFDDE3FF),

      // Tertiary Fixed Colors
      // tertiaryFixed: Color(0xFFDDE3FF),
      // tertiaryFixedDim: Color(0xFFB8C7FF),
      // onTertiaryFixed: Color(0xFF001C3B),
      // onTertiaryFixedVariant: Color(0xFF003C7E),

      // Error Colors
      error: error,
      onError: primaryWhite,
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),

      // Surface Colors
      surface: Color(0xFF000000),
      onSurface: primaryWhite,
      // surfaceVariant: const Color(0xFF252525),
      // onSurfaceVariant: Colors.white,

      // Surface Container Colors
      // surfaceDim: Color(0xFF121212),
      // surfaceBright: Color(0xFF3A3A3A),
      // surfaceContainerLowest: Color(0xFF0F0F0F),
      // surfaceContainerLow: Color(0xFF1A1A1A),
      // surfaceContainer: Color(0xFF1E1E1E),
      // surfaceContainerHigh: Color(0xFF252525),
      // surfaceContainerHighest: Color(0xFF2E2E2E),

      // Outline Colors
      outline: Color(0xFF252525),
      outlineVariant: const Color(0xFF256962),

      // Shadow & Scrim
      shadow: primaryWhite.withOpacity(0.3),
      scrim: primaryWhite.withOpacity(0.7),

      // Inverse Colors
      inverseSurface: primaryWhite,
      onInverseSurface: Colors.black,
      inversePrimary: primarySeed,

      // Surface Tint
      surfaceTint: primarySeed,
    );
  }
}

/// Extension for easy access to ColorScheme colors in BuildContext
extension ColorSchemeExtension on BuildContext {
  /// Get the current ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get ColorSchemeColors helper for semantic color access
  ColorSchemeColors get colors => ColorSchemeColors(colorScheme);
}
