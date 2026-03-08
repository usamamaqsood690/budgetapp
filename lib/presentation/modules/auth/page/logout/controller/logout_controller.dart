import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/core/services/biometric_service.dart';
import 'package:wealthnxai/domain/usecases/drawer/logout_usercase.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';
import 'package:wealthnxai/routes/app_routes.dart';

/// Logout Controller
class LogoutController extends GetxController {
  LogoutController({required this.logoutUseCase});
  final LogoutUseCase logoutUseCase;
  final AuthService authService = AuthService.instance;

  final RxBool isLoading = false.obs;

  /// Call logout API and, on success, clear all local session/storage and navigate to login.
  Future<void> onLogoutTap() async {
    if (isLoading.value) return;

    isLoading.value = true;

    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    try {
      final result = await logoutUseCase();

      await result.fold(
            (failure) async {
          Get.back();
          AppSnackBar.showError(failure.message, title: 'Logout Failed');
        },
            (user) async {
          await authService.logout();
          Get.back();
          Get.offAllNamed(Routes.LOGIN);
        },
      );
    } catch (e) {
      Get.back();
      AppSnackBar.showError(e.toString(), title: 'Logout Failed');
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }


}
