import 'package:flutter/material.dart';

/// App Dimensions System
class AppDimensions {
  AppDimensions._();

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 27.0;
  static const double radiusXXXL = 56.0;
  static const double radiusRound = 999.0;

  // Border Radius as BorderRadius objects
  static BorderRadius borderRadiusXS = BorderRadius.circular(radiusXS);
  static BorderRadius borderRadiusSM = BorderRadius.circular(radiusSM);
  static BorderRadius borderRadiusMD = BorderRadius.circular(radiusMD);
  static BorderRadius borderRadiusLG = BorderRadius.circular(radiusLG);
  static BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);
  static BorderRadius borderRadiusXXL = BorderRadius.circular(radiusXXL);
  static BorderRadius borderRadiusRound = BorderRadius.circular(radiusRound);

  // Icon Sizes
  static const double iconXS = 8.0;
  static const double iconSM = 10.0;
  static const double iconMD = 12.0;
  static const double iconLG = 14.0;
  static const double iconXL = 16.0;
  static const double iconXXL = 22.0;


  // Button Heights
  static const double buttonHeightSM = 36.0;
  static const double buttonHeightMD = 44.0;
  static const double buttonHeightLG = 66.0;
  static const double buttonHeightXL = 90.0;

  // Input Field Heights
  static const double inputHeightSM = 40.0;
  static const double inputHeightMD = 48.0;
  static const double inputHeightLG = 56.0;

  // App Bar
  static const double appBarHeight = 50.0;
  static const double appBarHeightLarge = 64.0;

  // Drawer Width
  static const double drawerWidth = 320.0;


  // Bottom Navigation
  static const double bottomNavHeight = 60.0;

  // Card Dimensions
  static const double cardElevation = 2.0;
  static const double cardElevationRaised = 4.0;

  // Divider
  static const double dividerHeight = 1.0;
  static const double dividerThickness = 0.5;

  // Border Width
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;
  static const double borderWidthThick = 2.0;
  static const double borderWidthExtraThick = 3.0;



  // Shadow
  static List<BoxShadow> get shadowSM => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMD => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLG => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get shadowXL => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}

/// Extension for easy access to dimensions in BuildContext
extension AppDimensionsExtension on BuildContext {
  // Access dimension constants directly via AppDimensions class
  // Example: AppDimensions.radiusMD, AppDimensions.iconMD, etc.
}
