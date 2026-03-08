import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import '../controller/home_controller.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Center(
      child: Column(
        spacing: 4,
        children: [
          Obx(
            () => AppText(
              txt: 'Hi ${controller.currentUser.value?.name ?? ''}',
              style: TextStyle(
                fontSize: AppSpacing.responTextWidth(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.spacing8,
            children: [
              Image.asset(ImagePaths.leftStar, width: 16, height: 24),
              AppText(
                txt: 'Generate Prompt',
                style: TextStyle(
                  fontSize: AppSpacing.responTextWidth(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Image.asset(ImagePaths.rightStar, width: 16, height: 24),
            ],
          ),
        ],
      ),
    );
  }
}
