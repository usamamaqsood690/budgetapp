import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';

/// App Snackbar Helper
class AppSnackBar {
  AppSnackBar._();

  /// Show snackbar message with theme-aware styling
  static void show(
      String message, {
        String? title,
        SnackPosition position = SnackPosition.TOP,
        Duration duration = const Duration(seconds: 3),
        Color? backgroundColor,
        Color? textColor,
        IconData? icon,
      }) {
    final context = Get.context;
    if (context == null) return;

    final defaultBgColor =
        backgroundColor ?? context.colors.surfaceElevated;
    final defaultTextColor = textColor ?? context.colors.inversePrimary;

    Get.snackbar(
      title ?? '',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: defaultBgColor,
      colorText: defaultTextColor,
      icon: icon != null ? Icon(icon, color: defaultTextColor) : null,
      margin: AppSpacing.marginAll(AppSpacing.md),
      borderRadius: AppDimensions.radiusSM,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  /// Show success snackbar
  static void showSuccess(
      String message, {
        String? title,
        SnackPosition position = SnackPosition.TOP,
        Duration duration = const Duration(seconds: 3),
        Widget? icon,
        bool? isDismissible
      }) {
    final context = Get.context;
    if (context == null) return;

    Get.snackbar(
      title ?? 'Success',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: context.colors.success,
      colorText: context.colors.white,
      icon: icon??Icon(Icons.check_circle, color: context.colors.white),
      margin: AppSpacing.marginAll(AppSpacing.md),
      borderRadius: AppDimensions.radiusSM,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  /// Show error snackbar
  static void showError(
      String message, {
        String? title,
        SnackPosition position = SnackPosition.TOP,
        Duration duration = const Duration(seconds: 4),
        Widget? icon,
        bool? isDismissible
      }) {
    final context = Get.context;
    if (context == null) return;

    Get.snackbar(
      title ?? 'Error',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: context.colors.error,
      colorText: context.colors.white,
      icon: icon?? Icon(Icons.error, color: context.colors.white),
      margin: AppSpacing.marginAll(AppSpacing.md),
      borderRadius: AppDimensions.radiusSM,
      isDismissible:isDismissible?? true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  /// Show warning snackbar
  static void showWarning(
      String message, {
        String? title,
        SnackPosition position = SnackPosition.TOP,
        Duration duration = const Duration(seconds: 3),
      }) {
    final context = Get.context;
    if (context == null) return;

    Get.snackbar(
      title ?? 'Warning',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: context.colors.warning,
      colorText: context.colors.black,
      icon: Icon(Icons.warning, color: context.colors.black),
      margin: AppSpacing.marginAll(AppSpacing.md),
      borderRadius: AppDimensions.radiusSM,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  /// Show info snackbar
  static void showInfo(
      String message, {
        String? title,
        SnackPosition position = SnackPosition.TOP,
        Duration duration = const Duration(seconds: 3),
        Widget? icon,
        bool? isDismissible
      }) {
    final context = Get.context;
    if (context == null) return;

    Get.snackbar(
      title ?? 'Info',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: context.colors.info,
      colorText: context.colors.white,
      icon:icon?? Icon(Icons.info, color: context.colors.white),
      margin: AppSpacing.marginAll(AppSpacing.md),
      borderRadius: AppDimensions.radiusSM,
      isDismissible:isDismissible?? true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
