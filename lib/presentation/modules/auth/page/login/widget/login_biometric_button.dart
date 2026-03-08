import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

/// Login Biometric Button Widget
/// Reusable biometric authentication button (Face ID / Fingerprint)
class LoginBiometricButton extends StatelessWidget {
  const LoginBiometricButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: AppText(
            txt: "Login with touch ID".tr,
            style: context.bodyMedium
          ),
        ),
        AppSpacing.addHeight(AppSpacing.sm),
        GestureDetector(
          onTap: onTap,
          child: Center(
            child: Container(
              padding:AppSpacing.paddingAll(AppTextTheme.fontSize10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.colorScheme.onSurface,
                  width: 0.5,
                ),
              ),
              child: Image.asset(
                Platform.isIOS ? ImagePaths.faceId : ImagePaths.fingureprint,
                width: AppTextTheme.fontSize24,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
