import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';

/// Login Header Widget
/// Reusable header section with welcome text and help icon
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key, this.onHelpTap});

  final VoidCallback? onHelpTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              txt: "Welcome back.".tr,
              textAlign: TextAlign.center,
              style: context.headlineLarge,
            ),
            GestureDetector(
              onTap: onHelpTap ?? () {
                Get.toNamed(
                  Routes.SUPPORT,
                  arguments: {'isShowRecoverEmail': true},
                );
              },
              child: Image.asset(
                ImagePaths.help_support,
                width: AppDimensions.iconXXL,
                height: AppDimensions.iconXXL,
              ),
            ),
          ],
        ),
        AppText(
          txt: "login To Account".tr,
          textAlign: TextAlign.center,
          style: context.bodyLarge,
        ),
      ],
    );
  }
}
