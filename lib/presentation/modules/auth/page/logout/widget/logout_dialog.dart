import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/auth/page/logout/controller/logout_controller.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/dialogs/app_dialog.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is provided via LogoutBinding
    final controller = Get.find<LogoutController>();
    return AppDialog(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: AppText(
                txt: "Are you sure you want to logout?".tr,
                textAlign: TextAlign.center,
              ),
            ),
            AppSpacing.addHeight(AppSpacing.xl),
            Padding(
              padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.xl),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onTap: () {
                        Get.back(); // close dialog
                        Get.delete<LogoutController>();
                      },
                      txt: 'Cancel',
                    ),
                  ),
                  // Horizontal space between buttons
                  AppSpacing.addWidth(AppSpacing.lg),
                  Expanded(
                    child: AppButton(
                      onTap: () async {
                        // Close confirmation dialog then perform logout
                        Get.back();
                        await controller.onLogoutTap();
                        Get.delete<LogoutController>();
                      },
                      txt: 'Ok',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
