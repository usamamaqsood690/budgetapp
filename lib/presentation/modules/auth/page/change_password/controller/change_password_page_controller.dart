import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/core/services/biometric_service.dart';
import 'package:wealthnxai/core/utils/validators.dart';
import 'package:wealthnxai/domain/usecases/drawer/change_password_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/set_new_password_usecase.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';
import 'package:wealthnxai/routes/app_routes.dart';

/// Change Password Controller - Presentation layer
/// Handles submitting new password in forgot-password + OTP flow.
class ChangePasswordController extends GetxController {
  // Inputs
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // UI state
  final RxBool isPasswordVisible = true.obs;
  final RxBool isNewPasswordValid = false.obs;
  final RxBool isConfirmPasswordValid = false.obs;
  final RxBool hasNewPasswordText = false.obs;
  final RxBool hasConfirmPasswordText = false.obs;
  final RxBool isLoading = false.obs;

  // Flow type (forgot password reset vs. in-app change password)
  PasswordChangeType passwordChangeType = PasswordChangeType.newPassword;

  // Use case
  final NewPasswordUseCase newPasswordUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  //param
  String? email;

  //Services
  final AuthService authService = AuthService.instance;
  final BiometricService biometricService = BiometricService.instance;

  ChangePasswordController({
    required this.newPasswordUseCase,
    required this.changePasswordUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    // Get parameters from route arguments
    final args = Get.arguments;
    if (args is Map) {
      if (args['email'] is String) {
        email = args['email'] as String;
      }
      if (args['passwordChangeType'] is PasswordChangeType) {
        passwordChangeType = args['passwordChangeType'] as PasswordChangeType;
      }
    } else if (args is String) {
      // Backwards compatibility if only email string is passed
      email = args;
    }

    // Add listeners to update validation state
    newPasswordController.addListener(() {
      final text = newPasswordController.text;
      hasNewPasswordText.value = text.isNotEmpty;
      onNewPasswordChanged(text);
    });

    confirmPasswordController.addListener(() {
      final text = confirmPasswordController.text;
      hasConfirmPasswordText.value = text.isNotEmpty;
      onConfirmPasswordChanged(text);
    });
  }

  /// Update validation state for new password as user types
  void onNewPasswordChanged(String value) {
    isNewPasswordValid.value =
        Validators.validateStrongPassword(value) == null;
  }

  /// Update validation state for confirm password as user types
  void onConfirmPasswordChanged(String value) {
    isConfirmPasswordValid.value =
        Validators.validateConfirmPassword(
          value,
          newPasswordController.text,
        ) ==
        null;
  }

  /// Submit new password to reset endpoint
  Future<void> submitNewPassword() async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (Validators.validateConfirmPassword(confirmPassword, newPassword) !=
        null) {
      AppSnackBar.showError('Password Not Match', title: 'Error');
      return;
    }

    if (email == null || email!.isEmpty) {
      AppSnackBar.showError('Missing email for password reset', title: 'Error');
      return;
    }
    isLoading.value = true;
    // Show loading dialog
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    try {
      final params = NewPasswordUseCaseParams(
        email: email!,
        newPassword: newPassword,
      );

      final result = await newPasswordUseCase(params);

      result.fold(
        (failure) {
          Get.back();
          AppSnackBar.showError(failure.message, title: 'Error');
        },
        (response) async {
          Get.back();
          newPasswordController.clear();
          confirmPasswordController.clear();
          hasNewPasswordText.value = false;
          hasConfirmPasswordText.value = false;
          isNewPasswordValid.value = false;
          isConfirmPasswordValid.value = false;

          AppSnackBar.showSuccess(
            response.message ?? 'set new password successfully',
            title: 'Success',
          );
          // Clear all session and storage data before navigating to login
          await authService.logout();
          await biometricService.clearCredentials();
          // Navigate back to login
          Get.offAllNamed(Routes.LOGIN);
        },
      );
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  /// Submit change password to reset password
  Future<void> submitChangePassword() async {
    final currentPassword = currentPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    final newPassword = newPasswordController.text;

    if (Validators.validateConfirmPassword(confirmPassword, newPassword) !=
        null) {
      AppSnackBar.showError('Password Not Match', title: 'Error');
      return;
    }

    isLoading.value = true;
    // Show loading dialog
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    try {
      final params = ChangePasswordUseCaseParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      final result = await changePasswordUseCase(params);

      result.fold(
        (failure) {
          Get.back();
          AppSnackBar.showError(failure.message, title: 'Error');
        },
        (response) async {
          Get.back();
          await biometricService.updateBioPassword(newPasswordController.text);
          newPasswordController.clear();
          confirmPasswordController.clear();
          currentPasswordController.clear();
          hasNewPasswordText.value = false;
          hasConfirmPasswordText.value = false;
          isNewPasswordValid.value = false;
          isConfirmPasswordValid.value = false;

          AppSnackBar.showSuccess(
            response.message ?? 'Change password successfully',
            title: 'Success',
          );
        },
      );
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }
}
