import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/services/feedback_service.dart';
import 'package:wealthnxai/data/datasources/remote/drawer_remote_datasource/feedback_remote_datasource_impl/feedback_remote_datasource_impl.dart';
import 'package:wealthnxai/data/network/network_info_impl.dart';
import 'package:wealthnxai/data/repositories/drawer_repository_impl/feedback_repository_impl/feedback_repository_impl.dart';
import 'package:wealthnxai/domain/usecases/drawer/feedback_usecase.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';

class FeedbackController extends GetxController {
  FeedbackController({
    FeedbackDialogService? feedbackService,
    FeedbackUseCase? feedbackUseCase,
  }) : _feedbackService = feedbackService ?? FeedbackDialogService(),
       _feedbackUseCase =
           feedbackUseCase ??
           FeedbackUseCase(
             repository: FeedbackRepositoryImpl(
               remoteDataSource: FeedbackRemoteDataSourceImpl(
                 apiClient: Get.find<ApiClient>(),
               ),
               networkInfo: NetworkInfoImpl.instance,
             ),
           );

  final FeedbackDialogService _feedbackService;
  final FeedbackUseCase _feedbackUseCase;

  final RxList<String> feedbackOptions =
      <String>[
        "Smooth Experience",
        "The app feels slow",
        "I really like the AI features",
        "Some features don't work as expected",
        "The layout feels confusing",
        "Other",
      ].obs;
  final RxInt selectedOption = (-1).obs;
  final TextEditingController descriptionController = TextEditingController();
  final RxString errorMessage = ''.obs;

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  /// Toggle the selected option when user taps on an item.
  void toggleOption(int index) {
    if (selectedOption.value == index) {
      selectedOption.value = -1;
    } else {
      selectedOption.value = index;
    }

    // Clear custom text if "Other" is no longer selected.
    if (selectedOption.value != feedbackOptions.indexOf("Other")) {
      descriptionController.clear();
    }
  }

  /// Submit feedback.
  Future<void> submitFeedback() async {
    final int index = selectedOption.value;
    if (index < 0 || index >= feedbackOptions.length) {
      AppSnackBar.showError(
        'Please select an option before submitting',
        title: 'Feedback',
      );
      return;
    }

    final String option = feedbackOptions[index];
    final String description = descriptionController.text;

    final String feedType = option;
    final String? feedDescription =
        option == "Other" && description.isNotEmpty ? description : null;

    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: AppLoadingWidget()),
        barrierDismissible: false,
      );
      // Submit feedback via use case
      final result = await _feedbackUseCase(
        FeedbackParams(feedType: feedType, feedDescription: feedDescription),
      );

      result.fold(
        (failure) {
          Get.back();
          Get.back();
          AppSnackBar.showError(failure.message, title: 'Error');
        },
        (response) {
          Get.back();
          Get.back();
          AppSnackBar.showSuccess(
            (response.message != null && response.message!.isNotEmpty)
                ? response.message!
                : 'Thank you for your feedback!',
            title: 'Success',
          );

          // Mark feedback dialog as shown for this user
          _feedbackService
              .getCurrentUserId()
              .then((userId) {
                if (userId != null) {
                  _feedbackService.markFeedbackDialogAsShown(userId);
                }
              })
              .catchError((e) {
                debugPrint('Error while marking feedback dialog as shown: $e');
              });
        },
      );
    }
    catch (e) {
      Get.back();
      Get.back();
      errorMessage.value = 'An unexpected error occurred';
      AppSnackBar.showError(
        'An unexpected error occurred. Please try again.',
        title: 'Error',
      );
    } finally {
      await onDialogDismissed();
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  /// Called when the dialog is dismissed either via close icon or programmatically.
  Future<void> onDialogDismissed() async {
    descriptionController.clear();
    selectedOption.value = -1;
  }
}
