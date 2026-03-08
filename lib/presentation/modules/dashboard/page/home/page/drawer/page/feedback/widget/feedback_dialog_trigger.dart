import 'dart:async';
import 'package:get/get.dart';
import 'package:wealthnxai/core/services/feedback_service.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/feedback/controller/feedback_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/feedback/feeback_dialog.dart';

class FeedbackDialogTrigger {
  static Timer? _timer;
  static final FeedbackDialogService _feedbackService = FeedbackDialogService();

  /// Shows feedback dialog after 5 minutes if not shown before for the current user
  static Future<void> triggerAfterLogin() async {
    _timer?.cancel();

    // Get current user ID
    final userId = await _feedbackService.getCurrentUserId();
    if (userId == null) {
      return;
    }
    // Check if this user has already seen the feedback dialog
    bool hasShown = await _feedbackService.hasShownFeedbackDialog(userId);
    if (hasShown) {
      return;
    }

    // Set timer for 5 minutes (300 seconds)
    _timer = Timer(const Duration(seconds: 300), () async {
      // Double-check before showing
      final currentUserId = await _feedbackService.getCurrentUserId();

      if (currentUserId == null) {
        return;
      }

      bool hasShownAgain = await _feedbackService.hasShownFeedbackDialog(
        currentUserId,
      );

      if (!hasShownAgain && Get.context != null) {
        // Mark as shown immediately so it never appears again for this user,
        // even if they close the app without interacting with the dialog.
        await _feedbackService.markFeedbackDialogAsShown(currentUserId);

        _showFeedbackDialog();
      } else {
       ///Feedback dialog already shown. Skipping...
      }
    });
  }

  /// Show the feedback dialog
  static void _showFeedbackDialog() {
    Get.dialog(
      FeedbackScreenDialog(
        onPressed: () async {
          final controller = Get.find<FeedbackController>();
          await controller.onDialogDismissed();
          Get.back();
        },
      ),
      barrierDismissible: false,
    );
  }

  /// Cancel the timer (call this if user logs out before the 5 minutes elapse)
  static void cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
