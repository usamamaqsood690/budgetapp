import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/services/biometric_service.dart';

/// Controller for the social (Google/Apple) password setup screen.
class SocialPasswordSetupController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    // Initialize text fields from arguments
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String email = args['email'] as String? ?? '';
    final String name = args['name'] as String? ?? '';

    emailController.text = email;
    nameController.text = name;
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final BiometricService _biometricService = BiometricService.instance;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Called when the user taps "Continue".
  /// Returns a map with email, name, and password to the caller.
  Future<void> onContinue() async {
    isLoading.value = true;

    final result = {
      'email': emailController.text.trim(),
      'name': nameController.text.trim(),
      'password': passwordController.text,
    };

    // Save credentials for biometric login.
    await _biometricService.saveCredentials(
      result['email'] as String,
      result['password'] as String,
    );

    Get.back(result: result);
  }

  SocialPlatformAuthProvider _providerFromArgs() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final raw = (args['provider'] as String?)?.toLowerCase() ?? 'google';
    return raw == 'apple'
        ? SocialPlatformAuthProvider.apple
        : SocialPlatformAuthProvider.google;
  }

  String subtitle() {
    final provider = _providerFromArgs();
    switch (provider) {
      case SocialPlatformAuthProvider.google:
        return 'You are login through Google Account'.tr;
      case SocialPlatformAuthProvider.apple:
        return 'You are login through Apple Account'.tr;
    }
  }

  void onCancel() {
    Get.back(result: null);
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
