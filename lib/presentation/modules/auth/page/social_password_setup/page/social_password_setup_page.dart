import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/validators.dart';
import 'package:wealthnxai/presentation/modules/auth/page/social_password_setup/controller/social_password_setup_controller.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';

class SocialPasswordSetupPage extends GetView<SocialPasswordSetupController> {
  const SocialPasswordSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingSymmetric(
            horizontal: AppSpacing.md,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(txt: 'Welcome'.tr),
                AppSpacing.addHeight(AppSpacing.xs),
                AppText(txt: controller.subtitle()),
          
                AppSpacing.addHeight(AppSpacing.xxl),
          
                AppTextField(
                  controller: controller.nameController,
                  label: "Full Name".tr,
                  keyboardType: TextInputType.name,
                  hintText: 'John Doe',
                  validator: Validators.validateName,
                  textInputAction: TextInputAction.next,
                ),
          
                AppSpacing.addHeight(AppSpacing.md),
          
                AppTextField(
                  controller: controller.emailController,
                  label: "email".tr,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'john@gmail.com',
                  validator: Validators.validateEmail,
                  textInputAction: TextInputAction.next,
                ),
          
                AppSpacing.addHeight(AppSpacing.xxl),
          
                Obx(
                  () => AppTextField(
                    controller: controller.passwordController,
                    label: "password".tr,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: '******',
                    validator: Validators.validateRequired,
                    textInputAction: TextInputAction.done,
                    obscureText: !controller.isPasswordVisible.value,
                    suffixIcon: IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
          
                AppSpacing.addHeight(AppSpacing.xxl),
          
                Obx(() {
                  final isBusy = controller.isLoading.value;
                  return AppButton(
                    onTap: () {
                      if (isBusy) return;
                      if (formKey.currentState?.validate() ?? false) {
                        controller.onContinue();
                      }
                    },
                    txt: 'Continue'.tr,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
