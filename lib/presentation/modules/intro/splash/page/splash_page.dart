import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/presentation/modules/intro/splash/controller/splash_page_controller.dart';

/// Splash Screen
/// Initial loading screen with app logo animation
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Get.find<SplashController>();
    final logoSize = AppDimensions.iconXXL * 20;

    return Scaffold(
      body: Container(
        height: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(ImagePaths.grad1),
        //     fit: BoxFit.contain,
        //     alignment: Alignment.bottomRight,
        //   ),
        // ),
        child: Center(
          child: ScaleTransition(
            scale: splashController.animation,
            child: FadeTransition(
              opacity: splashController.animation,
              child: Image.asset(
                ImagePaths.budgetiapplogo,
                width: logoSize,
                height: logoSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
