import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/intro/onboarding/controller/onboarding_page_controller.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';

/// Onboarding Screen
/// Displays app introduction slides with navigation options
class OnBoardingPage extends GetView<onBoardingController> {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                ImagePaths.onboardBackGround,
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  AppSpacing.addHeight(AppSpacing.lg),
                  Obx(
                    () => controller.myWidgetList[controller.currentPage.value],
                  ),
                  AppSpacing.addHeight(AppSpacing.xl),

                  /// Onboarding image pages
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: controller.pageController,
                            onPageChanged: (index) {
                              controller.currentPage.value = index;
                            },
                            children: [
                              controller.getIntroImage(ImagePaths.one),
                              controller.getIntroImage(ImagePaths.two),
                              controller.getIntroImage(ImagePaths.three),
                            ],
                          ),
                        ),
                        AppSpacing.addHeight(AppSpacing.xxl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding:AppSpacing.paddingSymmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ) ,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => controller.getProgressLine(
                    context,
                    color1: context.colors.onSurface,
                    color2:
                        controller.currentPage.value >= 1
                            ? context.colors.onSurface
                            : context.colors.surface,
                    color3:
                        controller.currentPage.value == 2
                            ? context.colors.onSurface
                            : context.colors.surface,
                  ),
                ),
                AppSpacing.addHeight(AppSpacing.xxl),
                AppButton(
                  onTap: () => Get.offNamed(Routes.LOGIN),
                  txt: 'Log In'.tr,
                ),
                AppSpacing.addHeight(AppSpacing.md),
                AppButton(
                  onTap: () => Get.offNamed(Routes.SIGNUP),
                  txt: 'Register'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
