import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/core/services/biometric_service.dart';
import 'package:wealthnxai/domain/usecases/auth/complete_google_auth_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/apple_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/google_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/login_usecase.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/feedback/widget/feedback_dialog_trigger.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/toast/app_toast.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class LoginController extends GetxController {
  final LoginUseCase loginUseCase;
  final GoogleUseCase googleSignInUseCase;
  final CompleteGoogleAuthUseCase completeGoogleAuthUseCase;
  final AppleUseCase appleSignInUseCase;
  final AuthService authService = AuthService.instance;
  final BiometricService _biometricService = BiometricService.instance;

  LoginController({
    required this.loginUseCase,
    required this.googleSignInUseCase,
    required this.completeGoogleAuthUseCase,
    required this.appleSignInUseCase,
  });

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Reactive state
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Sign in method (called from login screen after form validation)
  Future<void> signIn() async {
    isLoading.value = true;
    errorMessage.value = '';
    // Show loading dialog
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    try {
      final params = LoginParams(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final result = await loginUseCase(params);

      result.fold(
        (failure) {
          Get.back();
          errorMessage.value = failure.message;
           AppToast.showError(failure.message);
         // AppSnackBar.showError(failure.message, title: 'Login Failed',isDismissible: false);



          // emailController.clear();
          // passwordController.clear();
        },
        (user) async {
          await authService.setCurrentUser(user);
          await _biometricService.enableBiometric(
            emailController.text.trim(),
            passwordController.text,
            await _biometricService.isBiometricEnabled(),
          );
          FeedbackDialogTrigger.triggerAfterLogin();
          Get.back();
          AppSnackBar.showSuccess('Login successful', title: 'Success');
          Get.offAllNamed(Routes.DASHBOARD);
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = 'An unexpected error occurred';
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

  /// Sign in with biometric credentials (internal helper method)
  Future<void> signInBio(String email, String password) async {
    final isBioEnabled = await _biometricService.isBiometricEnabled();
    if (!isBioEnabled) {
      Get.back();
      AppSnackBar.showInfo(
        'Biometric authentication is not enabled.',
        title: 'Info',
      );
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';

    // Show loading dialog
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );
    try {
      final params = LoginParams(email: email, password: password);
      final result = await loginUseCase(params);

      result.fold(
        (failure) {
          Get.back();
          errorMessage.value = failure.message;
          AppSnackBar.showError(failure.message, title: 'Login Failed');
        },
        (user) async {
          Get.back();
          await authService.setCurrentUser(user);
          AppSnackBar.showSuccess('Login successful', title: 'Success');
          // Start 5-minute feedback dialog timer after successful biometric login.
          FeedbackDialogTrigger.triggerAfterLogin();
          Future.delayed(Duration(milliseconds: 5000));
          Get.offAllNamed(Routes.DASHBOARD);
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = 'An unexpected error occurred';
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

  /// Login with biometrics (Face ID / Fingerprint)
  Future<void> loginWithBiometrics() async {
    isLoading.value = true;
    errorMessage.value = '';

    // Show loading dialog
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    try {
      // 1. Check if device can use biometrics
      final canUseBiometrics = await _biometricService.canUseBiometrics();
      if (!canUseBiometrics) {
        Get.back();
        AppSnackBar.showInfo(
          'This device does not support biometric authentication or it is not set up.',
          title: 'Biometrics Unavailable',
        );
        return;
      }

      // 2. Trigger the real OS-level biometric prompt
      final didAuthenticate = await _biometricService.authenticate();
      if (!didAuthenticate) {
        Get.back();
        AppSnackBar.showInfo(
          'Biometric authentication was cancelled or failed.',
          title: 'Authentication Failed',
        );
        return;
      }

      // 3. Unlock stored credentials from secure storage
      final (email, password) = await _biometricService.readCredentials();

      if (email == null || password == null) {
        Get.back();
        AppSnackBar.showInfo(
          'No saved credentials found. Please login with Email & Password first.',
          title: 'Login Required',
        );
        return;
      }

      // 4. Perform a real login using the unlocked credentials
      await signInBio(email, password);
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Biometric auth error: $e');
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  /// Common handler for social sign-in (Google / Apple) to avoid code duplication
  Future<void> _handleSocialSignIn({
    required Future<dynamic> Function() signInUseCase,
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
      final result = await signInUseCase();

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
                '${provider.name.capitalizeFirst} sign-in cancelled by user',
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
                'Password is required to complete ${provider.name.capitalizeFirst} sign in',
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
                // Start 5-minute feedback dialog timer after successful completion of social auth.
                FeedbackDialogTrigger.triggerAfterLogin();
                Future.delayed(Duration(milliseconds: 5000));
                Get.offAllNamed(Routes.DASHBOARD);
              },
            );
            return;
          }

          Get.back();
          isLoading.value = false;
          errorMessage.value = failure.message;
          print("${failure.message}");
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
          // Start 5-minute feedback dialog timer after successful social login.
          FeedbackDialogTrigger.triggerAfterLogin();
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
  Future<void> signInWithGoogle() async {
    await _handleSocialSignIn(
      signInUseCase: googleSignInUseCase,
      newUserPrefix: 'NEW_GOOGLE_USER|',
      provider: SocialPlatformAuthProvider.google,
    );
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    await _handleSocialSignIn(
      signInUseCase: appleSignInUseCase,
      newUserPrefix: 'NEW_APPLE_USER|',
      provider: SocialPlatformAuthProvider.apple,
    );
  }
}
