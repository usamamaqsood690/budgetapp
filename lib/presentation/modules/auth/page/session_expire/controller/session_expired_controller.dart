import 'package:get/get.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/core/services/storage_service.dart';
import 'package:wealthnxai/routes/app_routes.dart';
import 'package:wealthnxai/presentation/modules/auth/page/session_expire/widget/session_expire_dialog.dart';

/// SessionExpiredController
/// Central place to handle 401 (unauthorized) → session expired flow.
class SessionExpiredController extends GetxController {
  static SessionExpiredController? _instance;
  static SessionExpiredController get instance {
    _instance ??= SessionExpiredController._internal();
    return _instance!;
  }

  SessionExpiredController._internal();

  final StorageService _storageService = StorageService.instance;
  final AuthService _authService = AuthService.instance;

  /// In-memory guard to avoid multiple dialogs overlapping when multiple
  /// requests fail with 401 at the same time.
  bool _isSessionDialogShowing = false;

  /// Handle an unauthorized (401) response from the API.
  ///
  /// This:
  /// - Checks the persisted "session dialog allowed" flag
  /// - Shows the dialog only once per expired session
  /// - Logs out on confirm and navigates to LOGIN
  Future<void> handleUnauthorized() async {
    try {
      // Check whether we are allowed to show the session-expired dialog
      final isAllowed = await _storageService.isSessionDialogAllowed();

      if (!isAllowed || _isSessionDialogShowing) return;

      _isSessionDialogShowing = true;

      // Prevent any further dialogs for this expired session
      await _storageService.setSessionDialogAllowed(false);

      // Show the dedicated session-expired dialog
      await SessionExpireDialog.show(
        onConfirm: () async {
          // Clear local session data
          await _authService.logout();

          // Prepare for the next authenticated session
          await _storageService.setSessionDialogAllowed(true);

          // Navigate user back to login screen
          if (Get.currentRoute != Routes.LOGIN) {
            Get.offAllNamed(Routes.LOGIN);
          }

          _isSessionDialogShowing = false;
        },
      );
    } catch (_) {
      // In case of any error, ensure flag is reset so future attempts can work
      _isSessionDialogShowing = false;
    }
  }
}
