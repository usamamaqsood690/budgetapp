/// OTP Verification Controller - Presentation layer
/// Manages OTP verification screen state and business logic
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/domain/usecases/auth/register_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class OtpVerificationController extends GetxController {
  final VerifyOtpUseCase verifyOtpUseCase;
  final RegisterUseCase? registerUseCase;
  final AuthService authService = AuthService.instance;

  OtpVerificationController({
    required this.verifyOtpUseCase,
    this.registerUseCase,
  });

  // OTP input
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Reactive state
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // OTP verification parameters
  String? email;
  OtpVerificationType verificationType = OtpVerificationType.signup;
  VoidCallback? onResendOtp;

  // Signup data (for signup flow)
  String? name;
  String? password;

  @override
  void onInit() {
    super.onInit();
    // Get parameters from route arguments
    final args = Get.arguments;
    if (args != null) {
      if (args is Map) {
        email = args['email'] as String?;
        if (args['type'] != null) {
          verificationType = args['type'] as OtpVerificationType;
        }
        name = args['name'] as String?;
        password = args['password'] as String?;
        onResendOtp = args['onResendOtp'] as VoidCallback?;
      } else if (args is String) {
        email = args;
      }
    }
  }

  /// Verify OTP
  Future<void> verifyOtp() async {
    // Show loading dialog
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final otpValue = otpController.text.trim();

      if (verificationType == OtpVerificationType.signup) {
        final otpVerified = await _handleOtpVerification(otpValue);
        if (otpVerified) {
          // On success: perform signup and then close dialog in finally
          await _handleSignup();
        }
      } else if (verificationType == OtpVerificationType.forgotPassword) {
        final otpVerified = await _handleOtpVerification(otpValue);
        if (otpVerified) {
          // On success: clear field, close dialog, then navigate
          otpController.clear();
          Get.toNamed(
            Routes.CHANGEPASSWORD,
            arguments: {
              'email': email,
              'passwordChangeType': PasswordChangeType.newPassword,
            },
          );
        }
      } else if (verificationType == OtpVerificationType.recoverEmail) {
        final otpVerified = await _handleOtpVerification(otpValue);
        if (otpVerified) {
          otpController.clear();
          Get.offNamed(Routes.LOGIN,);
        }
      }
    } catch (e) {
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


  /// Handle signup logic
  Future<void> _handleSignup() async {
    if (registerUseCase == null) {
      AppSnackBar.showError(
        'Registration service not available',
        title: 'Error',
      );
      return;
    }

    final registerParams = RegisterParams(
      name: name!,
      email: email!,
      password: password!,
    );

    final registerResult = await registerUseCase!(registerParams);

    registerResult.fold(
      (failure) {
        errorMessage.value = failure.message;
        AppSnackBar.showError(failure.message, title: 'Registration Failed');
      },
      (user) async {
        await authService.setCurrentUser(user);
        AppSnackBar.showSuccess(
          'Account created successfully',
          title: 'Success',
        );
        Future.delayed(Duration(milliseconds: 5000));
        Get.offAllNamed(Routes.DASHBOARD);
      },
    );
  }

  /// Handle OTP verification for other flows
  /// Returns true if OTP verification succeeds, false otherwise
  Future<bool> _handleOtpVerification(String otpValue) async {
    final params = VerifyOtpParams(email: email!, otp: otpValue);
    final result = await verifyOtpUseCase(params);

    return result.fold(
      (failure) {
        Get.back();
        errorMessage.value = failure.message;
        AppSnackBar.showError(failure.message, title: 'Verification Failed');
        return false;
      },
      (message) {
        Get.back();
        if (verificationType != OtpVerificationType.signup) {
          AppSnackBar.showSuccess(
            message.message ?? 'OTP verified successfully',
            title: 'Success',
          );
        }
        return true;
      },
    );
  }

  /// Resend OTP
  void resendOtp() {
    otpController.clear();
    // Call the resend callback if provided
    if (onResendOtp != null) {
      onResendOtp!();
    } else {
      AppSnackBar.showInfo('Resend OTP functionality not configured');
    }
  }
}
