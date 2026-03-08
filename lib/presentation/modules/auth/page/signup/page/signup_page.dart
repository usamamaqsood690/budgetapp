/// Signup Screen - Presentation Layer
/// Main signup page with form fields and social signup options
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/validators.dart';
import 'package:wealthnxai/presentation/modules/auth/page/signup/controller/signup_page_controller.dart';
import 'package:wealthnxai/presentation/modules/auth/page/signup/widget/signup_header.dart';
import 'package:wealthnxai/presentation/modules/auth/page/signup/widget/signup_terms_agreement.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/buttons/social_buttons.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupController _controller = Get.find<SignupController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.nameController.dispose();
    _controller.emailController.dispose();
    _controller.passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SignupHeader(),

                AppSpacing.addHeight(AppSpacing.xxl),

                AppTextField(
                  controller: _controller.nameController,
                  label: "Full Name".tr,
                  keyboardType: TextInputType.name,
                  hintText: 'John Doe',
                  validator: Validators.validateName,
                  textInputAction: TextInputAction.next,
                ),

                AppSpacing.addHeight(AppSpacing.md),

                AppTextField(
                  controller: _controller.emailController,
                  label: "email".tr,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'john@gmail.com',
                  validator: Validators.validateEmail,
                  textInputAction: TextInputAction.next,
                ),

                AppSpacing.addHeight(AppSpacing.xxl),

                Obx(
                  () => AppTextField(
                    controller: _controller.passwordController,
                    label: "password".tr,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: '******',
                    validator: Validators.validateRequired,
                    textInputAction: TextInputAction.done,
                    obscureText: !_controller.isPasswordVisible.value,
                    suffixIcon: IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        _controller.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: _controller.togglePasswordVisibility,
                    ),
                  ),
                ),

                AppSpacing.addHeight(AppSpacing.xxl),

                const SignupTermsAgreement(),

                AppSpacing.addHeight(AppSpacing.lg),

                AppButton(
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (_controller.isAgreed.value) {
                        _controller.signupSendOtp();
                      } else {
                        _controller.showErrorDialog(
                          'Please agree with terms and conditions'.tr,
                        );
                      }
                    }
                  },
                  txt: 'Sign Up'.tr,
                ),

                AppSpacing.addHeight(AppSpacing.sm),

                AppButton(
                  onTap: () {
                    Get.offNamed(Routes.LOGIN);
                  },
                  txt: 'Log In'.tr,
                ),

                AppSpacing.addHeight(AppSpacing.lg),

                AppDivider(text:' or connect with'),

                AppSpacing.addHeight(AppSpacing.lg),

                SocialButtons(
                  onGoogleTap: _controller.signUpWithGoogle,
                  onAppleTap: _controller.signUpWithApple,
                ),

                AppSpacing.addHeight(AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
