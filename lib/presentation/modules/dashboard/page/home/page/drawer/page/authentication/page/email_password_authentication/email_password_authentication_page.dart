import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/page/email_password_authentication/controller/email_password_authentication_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/page/email_password_authentication/widget/bullet_points.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/widget/switch_toggle_row.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class EmailAndPasswordAuthPage extends GetView<EmailPasswordAuthenticationController> {
  const EmailAndPasswordAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: 'Email & Password Authentication'),
      body: ListView(
        padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
        children: [
          Obx(
            () => SwitchToggleRow(
              title: 'Both Email & Password Authentication'.tr,
              value: controller.bothEnabled.value,
              onChanged: controller.toggleBoth,
            ),
          ),
          AppSpacing.addHeight(AppSpacing.sm),
          Obx(
            () => SwitchToggleRow(
              title: 'Email Authentication',
              value: controller.emailEnabled.value,
              onChanged: controller.toggleEmail,
            ),
          ),
          AppSpacing.addHeight(AppSpacing.lg),
          BulletPoints(bullets: [
            'To enhance security and protect your account, we require email verification before enabling this feature.',
            'Ensures only you can access your account.',
            'Helps in password recovery and important notifications.',
            'Prevents fraud and unauthorized access.',
          ]),
          AppSpacing.addHeight(AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                txt:'After enable this the authentication will only happen through',
              ),
              AppSpacing.addHeight(AppSpacing.sm),
              RichText(
                text:  TextSpan(
                  text: '*********@example.com.',
                  style: TextStyle(
                    color: context.colorScheme.error,
                    fontSize:AppTextTheme.fontSize12 ,
                    fontWeight:AppTextTheme.weightLight,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.addHeight(AppSpacing.lg),
          Obx(
            () => SwitchToggleRow(
              title: 'Password Authentication',
              value: controller.passwordEnabled.value,
              onChanged: controller.togglePassword,
            ),
          ),
          AppSpacing.addHeight(AppSpacing.sm),
          BulletPoints(bullets: [
            'To protect your financial data, we require a strong password for authentication.',
            'Prevents unauthorized access to your account.',
            'Enhances security for financial transactions.',
            'Required for logging in, making withdrawals, and changing account details.',
          ]),
          AppSpacing.addHeight(AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                txt:'After enable this the authentication will only happen through',
              ),
              AppSpacing.addHeight(AppSpacing.sm),
              RichText(
                text:  TextSpan(
                  text: 'Password',
                  style: TextStyle(
                    color: context.colors.white,
                    fontSize:AppTextTheme.fontSize12,
                    fontWeight: AppTextTheme.weightLight,
                  ),
                  children: [
                    TextSpan(
                      text: ' ************',
                      style: TextStyle(
                        color: context.colorScheme.primary,
                        fontSize: AppTextTheme.fontSize12,
                        fontWeight:  AppTextTheme.weightLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

