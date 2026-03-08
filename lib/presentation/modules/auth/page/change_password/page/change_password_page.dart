import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/validators.dart';
import 'package:wealthnxai/presentation/modules/auth/page/change_password/controller/change_password_page_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/page/email_password_authentication/widget/bullet_points.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';

/// Change Password Screen
/// Used in forgot-password flow after OTP is successfully verified.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final ChangePasswordController controller =
      Get.find<ChangePasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Change Password'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.passwordChangeType ==
                    PasswordChangeType.newPassword) ...[
                  AppText(txt: 'Set New Password'.tr),
                  AppSpacing.addHeight(AppSpacing.sm),
                  AppText(
                    txt:
                        'Your password must be strong and hard to guess.\nPlease create a new password and confirm it.'
                            .tr,
                  ),
                  AppSpacing.addHeight(AppSpacing.lg),
                ],

                /// Current Password (only for in-app change password flow)
                if (controller.passwordChangeType ==
                    PasswordChangeType.changePassword) ...[
                  Obx(
                    () => AppTextField(
                      controller: controller.currentPasswordController,
                      label: 'Current Password'.tr,
                      keyboardType: TextInputType.visiblePassword,
                      // Reuse strong password validation for current password as well
                      validator:
                          (value) => Validators.validatePassword(value),
                      textInputAction: TextInputAction.next,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Enter Current Password'.tr,
                      ),
                    ),
                  ),
                  AppSpacing.addHeight(AppSpacing.md),
                  BulletPoints(bullets:
                  [
                    'Between 8 & 24 characters',
                    'At least one uppercase letter',
                    'At least one lowercase letter',
                    'At least one number',]
                    ),
                  AppSpacing.addHeight(AppSpacing.md),
                ],

                /// New Password with live validation icon (cross / tick)
                Obx(
                  () => AppTextField(
                    controller: controller.newPasswordController,
                    label: 'New Password'.tr,
                    keyboardType: TextInputType.visiblePassword,
                    validator:
                        (value) => Validators.validateStrongPassword(value),
                    textInputAction: TextInputAction.next,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Enter New Password'.tr,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          controller.hasNewPasswordText.value
                              ? Padding(
                                padding: AppSpacing.paddingOnly(
                                  right: AppSpacing.sm,
                                ),
                                child: Icon(
                                  controller.isNewPasswordValid.value
                                      ? Icons.check
                                      : Icons.close,
                                  color:
                                      controller.isNewPasswordValid.value
                                          ? context.colors.success
                                          : context.colors.error,
                                  size: AppDimensions.iconXXL,
                                ),
                              )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
                AppSpacing.addHeight(AppSpacing.md),

                /// Confirm New Password
                Obx(
                  () => AppTextField(
                    controller: controller.confirmPasswordController,
                    label: 'Confirm New Password'.tr,
                    keyboardType: TextInputType.visiblePassword,
                    validator:
                        (value) => Validators.validateConfirmPassword(
                          value,
                          controller.newPasswordController.text,
                        ),
                    textInputAction: TextInputAction.done,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Confirm New Password'.tr,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          controller.hasConfirmPasswordText.value
                              ? Padding(
                                padding: AppSpacing.paddingOnly(
                                  right: AppSpacing.sm,
                                ),
                                child: Icon(
                                  controller.isConfirmPasswordValid.value
                                      ? Icons.check
                                      : Icons.close,
                                  color:
                                      controller.isConfirmPasswordValid.value
                                          ? context.colors.success
                                          : context.colors.error,
                                  size: AppDimensions.iconXXL,
                                ),
                              )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
                AppSpacing.addHeight(AppSpacing.sm),

                /// Simple password rules helper
                if (controller.passwordChangeType ==
                    PasswordChangeType.newPassword) ...[
                  AppText(
                    txt:
                        'Password must be at least 8 characters and include upper, lower, number and symbol.'
                            .tr,
                  ),
                ],
                const Spacer(),
                AppButton(
                  onTap: () {
                    if (_formKey.currentState!.validate() && !controller.isLoading.value) {
                      (controller.passwordChangeType == PasswordChangeType.newPassword)? controller.submitNewPassword(): controller.submitChangePassword();
                    }
                  },
                  txt: controller.passwordChangeType == PasswordChangeType.newPassword ?  'Change Password'.tr : "Save Changes".tr,
                ),
                AppSpacing.addHeight(AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
