import 'package:get/get.dart';
import 'package:wealthnxai/core/services/biometric_service.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';

/// Controller for `AuthenticationPage` in the drawer.
/// Manages the Face ID / Fingerprint switch state.
// class AuthenticationPageController extends GetxController {
//   final BiometricService _biometricService = BiometricService.instance;
//
//   /// Whether biometric login is enabled from the settings screen.
//   /// (We keep this in memory; you can later persist it if needed.)
//   final RxBool faceIdEnabled = false.obs;
//
//   /// Toggle Face ID / Fingerprint setting.
//   Future<void> toggleFaceId(bool value) async {
//     // If user is trying to enable, make sure device supports biometrics.
//     if (value) {
//       final canUseBiometrics = await _biometricService.canUseBiometrics();
//       if (!canUseBiometrics) {
//         AppSnackBar.showInfo(
//           'This device does not support biometrics or it is not set up.',
//           title: 'Biometrics Unavailable',
//         );
//         // Keep switch off.
//         faceIdEnabled.value = false;
//         return;
//       }
//
//       AppSnackBar.showSuccess(
//         'Face ID / Fingerprint enabled. You can now login using biometrics.',
//         title: 'Biometrics Enabled',
//       );
//       faceIdEnabled.value = true;
//     } else {
//       // Turning off biometrics: just clear credentials and update state.
//       await _biometricService.clearCredentials();
//       faceIdEnabled.value = false;
//       AppSnackBar.showInfo(
//         'Face ID / Fingerprint has been disabled.',
//         title: 'Biometrics Disabled',
//       );
//     }
//   }
// }


import 'package:get/get.dart';
import 'package:wealthnxai/core/services/biometric_service.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';

/// Controller for `AuthenticationPage` in the drawer.
/// Manages the Face ID / Fingerprint switch state.
class AuthenticationPageController extends GetxController {
  final BiometricService _biometricService = BiometricService.instance;

  /// Whether biometric login is currently enabled.
  /// RxBool so the UI reacts automatically when the value changes.
  final RxBool faceIdEnabled = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Hydrate the flag from secure storage on controller creation.
    faceIdEnabled.value = await _biometricService.isBiometricEnabled();
  }

  /// Toggle Face ID / Fingerprint setting.
  Future<void> toggleFaceId(bool value) async {
    if (value) {
      // Guard – make sure the device actually supports biometrics.
      final canUseBiometrics = await _biometricService.canUseBiometrics();
      if (!canUseBiometrics) {
        AppSnackBar.showInfo(
          'This device does not support biometrics or it is not set up.',
          title: 'Biometrics Unavailable',
        );
        // Keep switch off – no state change, no persistence.
        return;
      }

      // Persist the enabled flag, then update reactive state.
      await _biometricService.setBiometricEnabled(true);
      faceIdEnabled.value = true;
      AppSnackBar.showSuccess(
        'Face ID / Fingerprint enabled. You can now login using biometrics.',
        title: 'Biometrics Enabled',
      );
    } else {
      // Turning off: wipe credentials + flag, then update reactive state.
      await _biometricService.disableBiometric();
      faceIdEnabled.value = false;
      AppSnackBar.showInfo(
        'Face ID / Fingerprint has been disabled.',
        title: 'Biometrics Disabled',
      );
    }
  }
}
