import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/validators.dart';
import 'package:wealthnxai/presentation/modules/auth/page/recover_account/controller/recover_account_controller.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/dialogs/app_dialog.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';

class RecoverAccountDialog extends StatelessWidget {
  RecoverAccountDialog({super.key});

  final _formKey = GlobalKey<FormState>();

  RecoverAccountController get controller =>
      Get.find<RecoverAccountController>();

  @override
  Widget build(BuildContext context) {
    final bool isDeleteFlow = controller.accountType == AccountType.delete;

    return AppDialog(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, color: context.colors.grey),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: AppText(
                      txt:
                          isDeleteFlow
                              ? "Delete Account".tr
                              : "Recover Account".tr,
                    ),
                  ),
                  AppSpacing.addHeight(AppSpacing.sm),
                  Center(
                    child: AppText(
                      txt: "Please confirm by entering your email address.".tr,
                    ),
                  ),
                  AppTextField(
                    controller: controller.emailController,
                    label: "".tr,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'example@gmail.com',
                    validator: Validators.validateEmail,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
              AppSpacing.addHeight(AppSpacing.sm),
              AppButton(
                txt: isDeleteFlow ? 'Delete Account'.tr : 'Recover Account'.tr,
                onTap: () async {
                  isDeleteFlow? await controller.submitDeleteAccount(_formKey): await controller.submitRecoverAccount(_formKey);
                },
              ),
              AppSpacing.addHeight(AppSpacing.sm),
              isDeleteFlow?SizedBox.shrink() : Center(
                child: AppText(txt: "*This process will take approx 24hrs".tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
