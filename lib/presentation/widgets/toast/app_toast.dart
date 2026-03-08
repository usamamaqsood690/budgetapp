import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';

/// App Toast Helper
/// A helper class for showing toast messages with theme-aware styling
class AppToast {
  AppToast._();

  /// Show toast message with theme-aware styling
  static void show(String message, {int timeInSecForIosWeb = 1}) {
    final context = Get.context;
    if (context == null) return;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: context.colorScheme.surface,
      textColor: context.colorScheme.onSurface,
      fontSize: AppTextTheme.fontSize16,
    );
  }

  /// Show success toast
  static void showSuccess(String message) {
    final context = Get.context;
    if (context == null) return;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: context.colorScheme.primary,
      textColor: context.colorScheme.onPrimary,
      fontSize: AppTextTheme.fontSize16,
    );
  }

  /// Show error toast
  static void showError(String message) {
    final context = Get.context;
    if (context == null) return;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: context.colorScheme.error,
      textColor: context.colorScheme.onError,
      fontSize: AppTextTheme.fontSize16,
    );
  }

  /// Show warning toast
  static void showWarning(String message) {
    final context = Get.context;
    if (context == null) return;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: context.colorScheme.secondary,
      textColor: context.colorScheme.onSecondary,
      fontSize: AppTextTheme.fontSize16,
    );
  }
}
