import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/core/utils/validators.dart';
import 'package:wealthnxai/presentation/modules/auth/page/forgot_password/controller/forgot_password_page_controller.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final ForgotPasswordController controller = Get.find<ForgotPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Step-2 Verification'),
      body: Padding(
        padding:AppSpacing.paddingSymmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.addHeight( AppSpacing.sm),
              AppText(
                txt:
                    'Enter your email so we can send\nyou an authentication code.',
              ),

              AppSpacing.addHeight( AppSpacing.sm),

              AppTextField(
                controller: controller.emailController,
                label: "email".tr,
                keyboardType: TextInputType.emailAddress,
                hintText: 'john@gmail.com',
                validator: Validators.validateEmail,
                textInputAction: TextInputAction.done,
              ),

              AppSpacing.addHeight( AppSpacing.sm),
              AppText(
                txt:
                    'You will receive an email verification. Message and data rates may apply.',
              ),
              const Spacer(),
              AppButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    controller.sendResetCode();
                  }
                },
                txt: 'Continue',
              ),
              AppSpacing.addHeight( AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
