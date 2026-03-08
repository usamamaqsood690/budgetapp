import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/dialogs/app_dialog.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

/// SessionExpireDialog
/// Reusable dialog shown when the user session has expired (401).
class SessionExpireDialog extends StatelessWidget {
  const SessionExpireDialog({super.key, required this.onConfirm});

  final Future<void> Function() onConfirm;

  static Future<void> show({required Future<void> Function() onConfirm}) async {
    // If there is any existing dialog open (e.g. a loading spinner),
    // close it before showing the session-expired dialog so it isn't blocked.
    while (Get.isDialogOpen == true) {
      Get.back();
      // Give Flutter a tiny moment to update the navigation stack
      await Future.delayed(const Duration(milliseconds: 30));
    }

    await Get.dialog<void>(
      WillPopScope(
        onWillPop: () async => false,
        child: SessionExpireDialog(onConfirm: onConfirm),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImageAvatar(
            imageWidth: 70,
            imageHeight: 70,
            fallbackAsset: ImagePaths.sessionExpire,
            isCircular: false,
          ),
          Center(
            child: AppText(
              txt: 'Session Expired'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          AppSpacing.addHeight(AppSpacing.md),
          AppText(
            txt:
                'Your session has expired.\n Please login again to continue.'
                    .tr,
            textAlign: TextAlign.center,
          ),
          AppSpacing.addHeight(AppSpacing.xl),
          AppButton(
            onTap: () async {
              await onConfirm();
            },
            txt: 'OK'.tr,
            // Use red color to highlight destructive action
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius:
                    Theme.of(context).buttonTheme.shape
                            is RoundedRectangleBorder
                        ? (Theme.of(context).buttonTheme.shape
                                as RoundedRectangleBorder)
                            .borderRadius
                        : BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
