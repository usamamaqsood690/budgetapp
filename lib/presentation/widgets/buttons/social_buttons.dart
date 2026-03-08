import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';

/// Signup Social Buttons Widget
/// Reusable social signup buttons (Google, Apple)
class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            onTap: onGoogleTap,
            addWidget: Image.asset(
              ImagePaths.googleauth,
              width: AppDimensions.radiusXXL,
              fit: BoxFit.contain,
            ),
            txt: 'Google'.tr,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                context.colors.transparent,
              ),
              side: WidgetStateProperty.all(
                BorderSide(color: context.colors.grey, width: 0.5),
              ),
            ),
          ),
        ),
        if (Platform.isIOS) ...[
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: AppButton(
              onTap: onAppleTap,
              addWidget: CircleAvatar(
                radius: AppDimensions.radiusLG,
                backgroundColor: context.colorScheme.onSurface,
                child: Image.asset(
                  ImagePaths.apple,
                  width: AppDimensions.radiusLG,
                  fit: BoxFit.contain,
                ),
              ),
              txt: 'Apple'.tr,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  context.colors.transparent,),
                side: WidgetStateProperty.all(
                  BorderSide(color: context.colors.grey, width: 0.5),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
