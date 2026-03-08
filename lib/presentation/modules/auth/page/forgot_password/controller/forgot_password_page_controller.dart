/// Forgot Password Controller - Presentation layer
/// Handles sending reset code to user's email and navigation to OTP screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/domain/usecases/auth/forget_password_sendotp_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/signup_sendotp_usecase.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final ForgetPasswordSendOtpUseCase forgotPasswordSendOtpUseCase;

  ForgotPasswordController({required this.forgotPasswordSendOtpUseCase});

  // Email input
  final emailController = TextEditingController();

  // Reactive state
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Send reset code to email
  Future<void> sendResetCode() async {
    // Show loading dialog
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final params = SignupSendOtpParams(email: emailController.text.trim());
      final result = await forgotPasswordSendOtpUseCase(params);

      result.fold(
        (failure) {
          Get.back();
          errorMessage.value = failure.message;
          AppSnackBar.showError(failure.message, title: 'Failed');
        },
        (response) {
          Get.back();
          AppSnackBar.showSuccess(response.message!, title: 'Success');
          Get.toNamed(
            Routes.OTP_VERIFICATION,
            arguments: {
              'email': emailController.text.trim(),
              'type': OtpVerificationType.forgotPassword,
              'onResendOtp': () => sendResetCode(),
            },
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
