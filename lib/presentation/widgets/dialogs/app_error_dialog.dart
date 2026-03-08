import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

/// App Error Dialog
/// A reusable error dialog widget with theme-aware styling
class AppErrorDialog extends StatelessWidget {
  const AppErrorDialog({
    super.key,
    required this.message,
    this.title,
    this.onOkPressed,
  });

  final String message;
  final String? title;
  final VoidCallback? onOkPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusLG),
      title: AppText(
        txt: title ?? 'error'.tr,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: AppText(
        txt: message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        AppButton(
          onTap: onOkPressed ?? () => Navigator.of(context).pop(),
          txt: 'ok'.tr,
        ),
      ],
    );
  }

  /// Show error dialog as a function
  static void show(BuildContext context, String message, {String? title}) {
    showDialog(
      context: context,
      builder: (ctx) => AppErrorDialog(message: message, title: title),
    );
  }
}
