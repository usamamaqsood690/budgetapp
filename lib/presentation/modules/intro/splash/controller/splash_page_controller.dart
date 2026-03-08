import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  final AuthService authService = AuthService.instance;

  bool isLoggedIn = false;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    animationController.forward();

    initializeAndNavigate();
  }

  Future<void> initializeAndNavigate() async {
    isLoggedIn = await authService.checkSession();
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(isLoggedIn ? Routes.DASHBOARD : Routes.ONBOARDING);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
