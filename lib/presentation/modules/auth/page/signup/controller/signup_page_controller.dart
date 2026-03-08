/// Signup Controller - Presentation layer
/// Manages signup screen state and business logic
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/domain/usecases/auth/apple_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/complete_google_auth_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/google_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/signup_sendotp_usecase.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class SignupController extends GetxController {
  final SignupSendOtpUseCase signupSendOtpUseCase;
  final GoogleUseCase googleSignUpUseCase;
  final CompleteGoogleAuthUseCase completeGoogleAuthUseCase;
  final AppleUseCase appleSignUpUseCase;
  final AuthService authService = AuthService.instance;
  SignupController({
    required this.signupSendOtpUseCase,
    required this.googleSignUpUseCase,
    required this.appleSignUpUseCase,
    required this.completeGoogleAuthUseCase
  });

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Reactive state
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isAgreed = false.obs;
  final RxString errorMessage = ''.obs;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle terms agreement
  void toggleTermsAgreement(bool? value) {
    isAgreed.value = value ?? false;
  }

  /// Sign up send OTP
  Future<void> signupSendOtp() async {
    // Show loading dialog
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final params = SignupSendOtpParams(email: emailController.text.trim());
      final result = await signupSendOtpUseCase(params);

      result.fold(
        (failure) {
          Get.back();
          errorMessage.value = failure.message;
          AppSnackBar.showError(failure.message, title: 'Sign Up Failed');
        },
        (response) {
          Get.back();
          AppSnackBar.showSuccess(
            response.message ?? 'OTP sent to your email',
            title: 'Success',
          );

          Get.toNamed(
            Routes.OTP_VERIFICATION,
            arguments: {
              'email': emailController.text.trim(),
              'type': OtpVerificationType.signup,
              'name': nameController.text.trim(),
              'password': passwordController.text,
              'onResendOtp': () => signupSendOtp(),
            },
          );
        },
      );
    }
    catch (e) {
      Get.back();
      isLoading.value = false;
      errorMessage.value = e.toString();
      AppSnackBar.showError(
        'An unexpected error occurred. Please try again.',
        title: 'Error',
      );
    }
    finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  /// Show error dialog
  void showErrorDialog(String message) {
    AppSnackBar.showError(message, title: 'Error');
  }


  /// Common handler for social sign-up (Google / Apple) to avoid code duplication
  Future<void> _handleSocialSignUp({
    required Future<dynamic> Function() signUpUseCase,
    required String newUserPrefix,
    required SocialPlatformAuthProvider provider,
  }) async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: AppLoadingWidget()),
        barrierDismissible: false,
      );
      isLoading.value = true;
      errorMessage.value = '';

      // Call use case - all social Sign-In logic is handled in data layer
      final result = await googleSignUpUseCase();

      result.fold(
            (failure) async {
          // Special-case: first time social user (signaled from data layer)
          if (failure.message.startsWith(newUserPrefix)) {
            Get.back(); // close loader
            isLoading.value = false;

            final parts = failure.message.split('|');
            // Format: NEW_xxx_USER|uid|name|email
            final String userId = parts.length > 1 ? parts[1] : '';
            final String name = parts.length > 2 ? parts[2] : '';
            final String email = parts.length > 3 ? parts[3] : '';
            final String idToken = parts.length > 4 ? parts[4] : '';

            // Navigate to the social password setup screen and wait for result
            final result = await Get.toNamed(
              Routes.SOCIAL_PASSWORD_SETUP,
              arguments: {
                'email': email,
                'name': name,
                'provider': provider.name,
              },
            );
            final screenResult = result as Map<String, dynamic>?;

            if (screenResult == null) {
              // User cancelled
              AppSnackBar.showError(
                '${provider.name.capitalizeFirst} sign-up cancelled by user',
                title: 'Authentication Failed',
              );
              return;
            }

            final completedEmail =
                (screenResult['email'] as String?)?.trim() ?? email;
            final completedName =
                (screenResult['name'] as String?)?.trim() ?? name;
            final completedPassword =
                (screenResult['password'] as String?) ?? '';

            if (completedPassword.isEmpty) {
              AppSnackBar.showError(
                'Password is required to complete ${provider.name.capitalizeFirst} sign up',
                title: 'Authentication Failed',
              );
              return;
            }

            // Call backend social auth with password to finalize account
            isLoading.value = true;
            Get.dialog(
              const Center(child: AppLoadingWidget()),
              barrierDismissible: false,
            );

            final completeResult = await completeGoogleAuthUseCase(
              CompleteGoogleAuthParams(
                userId: userId,
                userName: completedName,
                email: completedEmail,
                password: completedPassword,
                idToken: idToken
              ),
            );

            completeResult.fold(
                  (f) {
                Get.back();
                isLoading.value = false;
                AppSnackBar.showError(
                  f.message,
                  title: 'Authentication Failed',
                );
              },
                  (userEntity) async {
                Get.back();
                isLoading.value = false;
                await authService.setCurrentUser(userEntity);
                AppSnackBar.showSuccess('Login successful', title: 'Success');
                Future.delayed(Duration(milliseconds: 5000));
                Get.offAllNamed(Routes.DASHBOARD);
              },
            );
            return;
          }

          Get.back();
          isLoading.value = false;
          errorMessage.value = failure.message;
          AppSnackBar.showError(
            failure.message,
            title: 'Authentication Failed',
          );
        },
            (userEntity) async {
          // Existing social user → normal flow
          await authService.setCurrentUser(userEntity);
          Get.back();
          isLoading.value = false;
          AppSnackBar.showSuccess('Login successful', title: 'Success');
          Future.delayed(Duration(milliseconds: 5000));
          Get.offAllNamed(Routes.DASHBOARD);
        },
      );
    } catch (e) {
      Get.back();
      isLoading.value = false;
      errorMessage.value = e.toString();
      AppSnackBar.showError(
        'An unexpected error occurred. Please try again.',
        title: 'Error',
      );
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  /// Sign in with Google
  Future<void> signUpWithGoogle() async {
    await _handleSocialSignUp(
      signUpUseCase: googleSignUpUseCase,
      newUserPrefix: 'NEW_GOOGLE_USER|',
      provider: SocialPlatformAuthProvider.google,
    );
  }

  /// Sign in with Apple
  Future<void> signUpWithApple() async {
    await _handleSocialSignUp(
      signUpUseCase: googleSignUpUseCase,
      newUserPrefix: 'NEW_APPLE_USER|',
      provider: SocialPlatformAuthProvider.apple,
    );
  }
}
