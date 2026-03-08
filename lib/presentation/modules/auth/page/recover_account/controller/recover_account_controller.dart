import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/services/biometric_service.dart';
import 'package:wealthnxai/core/services/storage_service.dart';
import 'package:wealthnxai/domain/usecases/auth/send_recover_account_otp_usecase.dart';
import 'package:wealthnxai/domain/usecases/drawer/delete_account_usecase.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';
import 'package:wealthnxai/routes/app_routes.dart';

/// Recover Account Controller - Presentation layer
/// Handles sending a recovery OTP to user's email for account recovery.
class RecoverAccountController extends GetxController {
  final RecoverAccountOtpUseCase recoverAccountOtpUseCase;
  final DeleteAccountOtpUseCase deleteAccountOtpUseCase;
  final AccountType accountType;
  final BiometricService _biometricService = BiometricService.instance;
  final StorageService storageService = StorageService.instance;

  RecoverAccountController({
    required this.recoverAccountOtpUseCase,
    required this.deleteAccountOtpUseCase,
    required this.accountType,
  });

  /// Email input used by the recover account dialog
  final emailController = TextEditingController();

  /// Reactive state
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Request recovery OTP to be sent to the given email.
  Future<bool> requestRestoreOtp(String email) async {
    // Show loading dialog
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final params = RecoverAccountOtpParams(email: email.trim());
      final result = await recoverAccountOtpUseCase(params);

      return result.fold(
        (failure) {
          Get.back();
          Get.back();
          errorMessage.value = failure.message;
          AppSnackBar.showError(failure.message, title: 'Failed');
          return false;
        },
        (response) {
          Get.back();
          Get.back();
          AppSnackBar.showSuccess(
            response.message ?? 'code sent successfully',
            title: 'Success',
          );
          return true;
        },
      );
    } catch (e) {
      Get.back();
      Get.back();
      errorMessage.value = 'An unexpected error occurred';
      AppSnackBar.showError(
        'An unexpected error occurred. Please try again.',
        title: 'Error',
      );
      return false;
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) {
        Get.back();
        Get.back();
      }
    }
  }

  Future<void> submitRecoverAccount(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final bool success = await requestRestoreOtp(email);

    if (success) {
      Get.toNamed(
        Routes.OTP_VERIFICATION,
        arguments: {
          'email': email,
          'type': OtpVerificationType.recoverEmail,
          'onResendOtp': () => requestRestoreOtp(email),
        },
      );
    }
  }

  Future<void> submitDeleteAccount(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final storedEmail = await storageService.getUserEmail();
    final bool emailMatches =
        storedEmail?.trim().toLowerCase() == email.trim().toLowerCase();

    if (emailMatches) {
      try{
        isLoading.value = true;
        errorMessage.value = '';

        Get.dialog(
          const Center(child: AppLoadingWidget()),
          barrierDismissible: false,
        );
        final result = await deleteAccountOtpUseCase();

        return result.fold(
              (failure) {
            Get.back();
            Get.back();
            errorMessage.value = failure.message;
            AppSnackBar.showError(failure.message, title: 'Failed');
          },
              (response) async{
            Get.back();
            Get.back();
            AppSnackBar.showSuccess(
              response.message ?? 'delete account successfully',
              title: 'Success',
            );
            await _biometricService.clearCredentials();
            Get.offAllNamed(Routes.LOGIN);
          },
        );
      }catch(e){
        Get.back();
        Get.back();
        errorMessage.value = 'An unexpected error occurred';
        AppSnackBar.showError(
          'An unexpected error occurred. Please try again.',
          title: 'Error',
        );
      }
      finally{
        isLoading.value = false;
        if (Get.isDialogOpen == true) {
          Get.back();
        }
      }
    } else {
      AppSnackBar.showError('Mail not matched', title: 'Failed');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
