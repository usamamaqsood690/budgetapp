import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// App Spacing System
/// Provides consistent spacing values throughout the app
/// Based on 8px grid system for better scalability
class AppSpacing {
  AppSpacing._();

  // Base spacing unit (8px)
  static const double base = 8.0;

  // Spacing scale
  static const double z = 0.0; // 0x base
  static const double xs = 4.0; // 0.5x base
  static const double sm = 8.0; // 1x base
  static const double md = 16.0; // 2x base
  static const double lg = 24.0; // 3x base
  static const double xl = 32.0; // 4x base
  static const double xxl = 40.0; // 5x base
  static const double xxxl = 48.0; // 6x base

  // Specific spacing values
  static const double spacing4 = xs;
  static const double spacing8 = sm;
  static const double spacing10 = 10.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = md;
  static const double spacing20 = 20.0;
  static const double spacing24 = lg;
  static const double spacing32 = xl;
  static const double spacing40 = xxl;
  static const double spacing48 = xxxl;
  static const double spacing64 = 64.0;
  static const double spacing80 = 80.0;
  static const double spacing96 = 96.0;

  // Padding shortcuts
  static EdgeInsets paddingAll(double value) => EdgeInsets.all(value);

  static EdgeInsets paddingHorizontal(double value) =>
      EdgeInsets.symmetric(horizontal: Get.width * (value.toDouble() / Get.width));

  static EdgeInsets paddingVertical(double value) =>
      EdgeInsets.symmetric(vertical: Get.height * (value.toDouble() / Get.height));

  static EdgeInsets paddingSymmetric({double? horizontal, double? vertical}) =>
      EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );
  static EdgeInsets paddingZero() => const EdgeInsets.all(0);

  static EdgeInsets paddingOnly({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) => EdgeInsets.only(
    top: top ?? 0,
    bottom: bottom ?? 0,
    left: left ?? 0,
    right: right ?? 0,
  );

  // Margin shortcuts
  static EdgeInsets marginAll(double value) => EdgeInsets.all(value);

  static EdgeInsets marginHorizontal(double value) =>
      EdgeInsets.symmetric(horizontal: Get.width * (value.toDouble() / Get.width));

  static EdgeInsets marginVertical(double value) =>
      EdgeInsets.symmetric(vertical: Get.height * (value.toDouble() / Get.height));

  static EdgeInsets marginSymmetric({double? horizontal, double? vertical}) =>
      EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );
  static EdgeInsets marginZero() => const EdgeInsets.all(0);

  static EdgeInsets marginOnly({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) => EdgeInsets.only(
    top: top ?? 0,
    bottom: bottom ?? 0,
    left: left ?? 0,
    right: right ?? 0,
  );

  static addHeight([dynamic value = 10]) {
    return SizedBox(height: Get.height * (value.toDouble() / Get.height));
  }

  static addWidth([dynamic value = 10]) {
    return SizedBox(width: Get.width * (value.toDouble() / Get.width));
  }

  static responTextHeight([dynamic value = 0]) {
    return Get.height * (value / Get.height);
  }

  static responTextWidth([dynamic value = 0]) {
    return Get.width * (value / Get.width);
  }
}

/// Extension for easy access to spacing in BuildContext
extension AppSpacingExtension on BuildContext {
  // Access spacing constants directly via AppSpacing class
  // Example: AppSpacing.md, AppSpacing.lg, etc.
}
