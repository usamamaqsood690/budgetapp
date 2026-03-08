import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/utils/app_common_helper.dart';
import 'package:wealthnxai/core/utils/date_time_helper.dart';
import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';
import 'package:wealthnxai/domain/usecases/schedule/add_schedule_usecase.dart';
import 'package:wealthnxai/domain/usecases/schedule/edit_schedule_usecase.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';

/// Add Schedule Controller - Presentation layer
/// Manages add/edit schedule form state and business logic
class AddScheduleController extends GetxController {
  final AddScheduleUseCase addScheduleUseCase;
  final EditScheduleUseCase editScheduleUseCase;
  AddScheduleController({
    required this.addScheduleUseCase,
    required this.editScheduleUseCase,
  });

  final formKey = GlobalKey<FormState>();

  /// Form Controllers
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();

  /// Form State
  final Rx<RecurrenceIntervalType?> recurrence = Rx<RecurrenceIntervalType?>(
    null,
  );
  final Rx<String?> selectedCategory = Rx<String?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxBool isSaving = false.obs;

  /// Form Type (create or edit)
  ScheduleFormType formType = ScheduleFormType.create;
  RecurringItem? editingItem;

  /// Available categories - defined in controller
  static const List<String> availableCategories = [
    'FOOD_AND_DRINK',
    'TRANSPORTATION',
    'SHOPPING',
    'ENTERTAINMENT',
    'BILLS_AND_UTILITIES',
    'GENERAL_MERCHANDISE',
    'GENERAL_SERVICES',
    'GOVERNMENT_AND_NON_PROFIT',
    'HOME_IMPROVEMENT',
    'MEDICAL',
    'PERSONAL_CARE',
    'TRAVEL',
    'OTHER',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    final args = Get.arguments;
    if (args is Map) {
      formType =
          (args['formType'] as ScheduleFormType?) ?? ScheduleFormType.create;
      editingItem = args['item'] as RecurringItem?;

      if (editingItem != null) {
        _populateFormForEdit(editingItem!);
      }
    }
  }

  void _populateFormForEdit(RecurringItem item) {
    titleController.text = item.name;
    amountController.text = item.amount.toInt().toString();
    descriptionController.text = item.description;
    recurrence.value = _recurrenceFromApi(item.recurrenceInterval);
    selectedCategory.value = item.category.toUpperCase();
    selectedDate.value = item.date;
    dateController.text = DateTimeConverter.toShortDate(item.date);
  }

  /// Convert API recurrence string to enum - defined in controller
  RecurrenceIntervalType? _recurrenceFromApi(String value) {
    final upper = value.toUpperCase();
    for (final v in RecurrenceIntervalType.values) {
      if (_getRecurrenceApiValue(v) == upper) return v;
    }
    return null;
  }

  /// Get recurrence API value - defined in controller
  String _getRecurrenceApiValue(RecurrenceIntervalType type) {
    switch (type) {
      case RecurrenceIntervalType.daily:
        return 'DAILY';
      case RecurrenceIntervalType.weekly:
        return 'WEEKLY';
      case RecurrenceIntervalType.monthly:
        return 'MONTHLY';
      case RecurrenceIntervalType.yearly:
        return 'YEARLY';
    }
  }

  /// Get recurrence label - defined in controller
  String getRecurrenceLabel(RecurrenceIntervalType type) {
    switch (type) {
      case RecurrenceIntervalType.daily:
        return 'Daily';
      case RecurrenceIntervalType.weekly:
        return 'Weekly';
      case RecurrenceIntervalType.monthly:
        return 'Monthly';
      case RecurrenceIntervalType.yearly:
        return 'Yearly';
    }
  }
  void setRecurrence(RecurrenceIntervalType? value) {
    recurrence.value = value;
  }

  void setCategory(String? value) {
    selectedCategory.value = value;
  }

  /// Get category label - defined in controller
  String getCategoryLabel(String category) {
    return CommonAppHelper.getCategoryLabel(category);
  }

  /// Get category icon - defined in controller
  IconData getCategoryIcon(String category) {
    return CommonAppHelper.getCategoryIcon(category);
  }

  /// Get category color - defined in controller
  Color getCategoryColor(String category) {
    return CommonAppHelper.getCategoryColor(category);
  }

  /// Validate form before submission
  bool _validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return false;
    return true;
  }

  /// Prepare common form data
  Map<String, dynamic> _prepareFormData() {
    final parsedAmount = double.tryParse(amountController.text) ?? 0.00;

    return {
      'name': titleController.text.trim(),
      'category': selectedCategory.value ?? 'OTHER',
      'amount': parsedAmount,
      'date': DateTimeConverter.toISODate(selectedDate.value!),
      'recurrenceInterval': recurrence.value != null
          ? _getRecurrenceApiValue(recurrence.value!)
          : _getRecurrenceApiValue(RecurrenceIntervalType.monthly),
      'description': descriptionController.text.isEmpty
          ? null
          : descriptionController.text,
      'isRecurring': false,
    };
  }

  /// Add new schedule
  Future<bool> addSchedule() async {
    if (!_validateForm()) return false;

    isSaving.value = true;
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    try {
      final formData = _prepareFormData();
      final result = await addScheduleUseCase(
        AddScheduleParams(
          name: formData['name'] as String,
          category: formData['category'] as String,
          amount: formData['amount'] as double,
          date: formData['date'] as String,
          recurrenceInterval: formData['recurrenceInterval'] as String?,
          description: formData['description'] as String?,
          isRecurring: false,
        ),
      );

      return result.fold(
        (failure) {
          Get.back();
          AppSnackBar.showError(failure.message, title: 'Error');
          return false;
        },
        (response) {
          Get.back();
          Get.back();
          AppSnackBar.showSuccess(
            response.message ?? 'Schedule created',
            title: 'Success',
          );
          _refreshScheduleData();
          return true;
        },
      );
    } catch (e) {
      Get.back();
      AppSnackBar.showError(
        'An unexpected error occurred: ${e.toString()}',
        title: 'Error',
      );
      return false;
    } finally {
      isSaving.value = false;
      // Ensure dialog is closed even if something went wrong
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  /// Edit existing schedule
  Future<bool> editSchedule() async {
    if (isSaving.value) return false;
    if (!_validateForm()) return false;
    if (editingItem == null) {
      AppSnackBar.showError('No schedule item to edit', title: 'Error');
      return false;
    }
    isSaving.value = true;
    Get.dialog(
      const Center(child: AppLoadingWidget()),
      barrierDismissible: false,
    );

    try {
      final formData = _prepareFormData();

      final result = await editScheduleUseCase(
        EditScheduleParams(
          id: editingItem!.id,
          name: formData['name'] as String,
          category: formData['category'] as String,
          amount: formData['amount'] as double,
          date: formData['date'] as String,
          recurrenceInterval: formData['recurrenceInterval'] as String,
          description: formData['description'] as String?,
        ),
      );

      return result.fold(
        (failure) {
          Get.back();
          AppSnackBar.showError(failure.message, title: 'Error');
          return false;
        },
        (response) {
          Get.back();
          Get.back();
          AppSnackBar.showSuccess(
            response.message ?? 'Schedule updated',
            title: 'Success',
          );
          _refreshScheduleData();
          return true;
        },
      );
    } catch (e) {
      Get.back();
      AppSnackBar.showError(
        'An unexpected error occurred: ${e.toString()}',
        title: 'Error',
      );
      return false;
    } finally {
      isSaving.value = false;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  /// Refresh schedule data after save/update
  void _refreshScheduleData() {
    try {
      final scheduleController = Get.find<ScheduleController>();
      // Use the selected date if provided, otherwise keep current date
      final targetDate =
          selectedDate.value ?? scheduleController.currentDate.value;

      // Update controller's current date
      scheduleController.currentDate.value = targetDate;

      // Rebuild calendar models so main & mini calendars reflect the new date
      scheduleController.rebuildFor(targetDate);

      // Refresh data for that date & month
      scheduleController.fetchScheduleByDateTime(targetDate);
      scheduleController.fetchMonthCalender(targetDate);

      // Update upcoming schedule list
      scheduleController.fetchUpcomingSchedule();
    } catch (e) {
      // ScheduleController might not be registered, ignore
      print('Error refreshing schedule data: $e');
    }
  }

  /// Clear all form fields
  void clearFields() {
    titleController.clear();
    amountController.clear();
    dateController.clear();
    descriptionController.clear();
    recurrence.value = null;
    selectedCategory.value = null;
    selectedDate.value = null;
  }

  /// Reset form
  void resetForm() {
    formKey.currentState?.reset();
    clearFields();
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    super.onClose();
  }


  Future<void> selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2900),
    );
    if (picked != null) {
      setDate(picked);
    }
  }
  void setDate(DateTime picked) {
    selectedDate.value = picked;
    dateController.text = DateTimeConverter.toISOShortDate(picked);
  }
}
