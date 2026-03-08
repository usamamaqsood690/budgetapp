/// Login Screen - Presentation Layer
/// Main login page with email/password, biometric, and social login options
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/core/utils/validators.dart';
import 'package:wealthnxai/presentation/modules/auth/page/login/controller/login_page_controller.dart';
import 'package:wealthnxai/presentation/modules/auth/page/login/widget/login_biometric_button.dart';
import 'package:wealthnxai/presentation/modules/auth/page/login/widget/login_header.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/buttons/social_buttons.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = Get.find<LoginController>();
  final _formKey = GlobalKey<FormState>();

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
                const LoginHeader(),

                AppSpacing.addHeight(AppSpacing.xxl),

                AppTextField(
                  controller: _loginController.emailController,
                  label: "email".tr,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'john@gmail.com',
                  validator: Validators.validateEmail,
                  textInputAction: TextInputAction.next,
                ),

                AppSpacing.addHeight(AppSpacing.md),

                Obx(
                  () => AppTextField(
                    controller: _loginController.passwordController,
                    label: "password".tr,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: '******',
                    validator: Validators.validatePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: !_loginController.isPasswordVisible.value,
                    suffixIcon: IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        _loginController.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: _loginController.togglePasswordVisibility,
                    ),
                  ),
                ),

                AppSpacing.addHeight(AppSpacing.sm),

                Align(
                  alignment: Alignment.centerRight,
                  child: AppText(
                    onTap: (){
                      _loginController.emailController.clear();
                      _loginController.passwordController.clear();
                      Get.toNamed(Routes.FORGET);
                    },
                    txt: "forgotPassword".tr,
                    style: context.bodyMedium?.copyWith(
                      fontSize: AppTextTheme.fontSize14,
                      fontWeight: AppTextTheme.weightMedium,
                    ),
                  ),
                ),

                AppSpacing.addHeight(AppSpacing.md),

              AppButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _loginController.signIn();
                              }
                            },
                            txt: 'Log In'.tr,
                          ),

                AppSpacing.addHeight(AppSpacing.sm),

                AppButton(
                  onTap: () {
                    Get.offNamed(Routes.SIGNUP);
                  },
                  txt: 'Register'.tr,
                ),

                AppSpacing.addHeight(AppSpacing.md),

                LoginBiometricButton(
                  onTap: _loginController.loginWithBiometrics,
                ),

                AppSpacing.addHeight(AppSpacing.md),

                AppDivider(text:' or connect with'),

                AppSpacing.addHeight(AppSpacing.md),

                SocialButtons(
                  onGoogleTap: _loginController.signInWithGoogle,
                  onAppleTap: _loginController.signInWithApple,
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
