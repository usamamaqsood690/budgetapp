import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wealthnxai/data/models/schedule/get_monthly_calender_response_model.dart/get_monthly_calender_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_upcoming_schedule_model/get_upcoming_schedule_model.dart';
import 'package:wealthnxai/domain/usecases/schedule/delete_schedule_usecase.dart';
import 'package:wealthnxai/domain/usecases/schedule/get_monthly_calender_usecase.dart';
import 'package:wealthnxai/domain/usecases/schedule/get_schedule_usecase.dart';
import 'package:wealthnxai/domain/usecases/schedule/get_upcoming_schedule_usecase.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';

/// Schedule Controller - Presentation layer
/// Manages schedule screen state and business logic
class ScheduleController extends GetxController {
  final GetUpcomingScheduleUseCase getUpcomingScheduleUseCase;
  final GetScheduleUseCase getScheduleUseCase;
  final GetMonthlyCalenderUseCase getMonthlyCalenderUseCase;
  final DeleteScheduleUseCase deleteScheduleUseCase;

  ScheduleController({
    required this.getUpcomingScheduleUseCase,
    required this.getScheduleUseCase,
    required this.getMonthlyCalenderUseCase,
    required this.deleteScheduleUseCase,
  });

  // Calendar UI state
  final selectedIndex = 0.obs;
  final monthDays = <Map<String, dynamic>>[].obs;
  final isSwitchingMonth = false.obs;
  final scrollController = ScrollController();
  final currentDate = DateTime.now().obs;
  final showMore = false.obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingExpense = false.obs;
  final RxBool isLoadingCalender = false.obs;
  final RxString errorMessage = ''.obs;

  // Data state - using new models
  final Rx<RecurringExpensesBody?> scheduleData = Rx<RecurringExpensesBody?>(
    null,
  );
  final Rx<UpcomingRecurringBody?> upcomingScheduleData =
      Rx<UpcomingRecurringBody?>(null);
  final Rx<MonthlyRecurringExpensesBody?> monthlyCalenderData =
      Rx<MonthlyRecurringExpensesBody?>(null);

  // Legacy compatibility - maps to new models
  final Rx<GetScheduleResponse?> expenseRecurring = Rx<GetScheduleResponse?>(
    null,
  );

  // Calendar dates
  final monthCalenderDates = <MonthCalendarDate>[].obs;
  // Schedule lists
  final upcomingSchedules = <RecurringItem>[].obs;
  // Reactive recurring expenses list for safe index management
  final recurringExpensesList = <RecurringItem>[].obs;

  // Viewport state for horizontal calendar scrolling
  double _viewportWidth = 0;
  double _itemExtent = 0;
  double _edge = 0;
  int _itemCount = 0;
  int? _pendingCenterIndex;

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Update recurring expense at index safely
  void updateRecurringExpense(int index, RecurringItem updatedItem) {
    if (index >= 0 && index < recurringExpensesList.length) {
      recurringExpensesList[index] = updatedItem;
      recurringExpensesList.refresh();

      // Update scheduleData if it exists
      if (scheduleData.value != null) {
        final updatedList = List<RecurringItem>.from(recurringExpensesList);
        scheduleData.value = RecurringExpensesBody(
          date: scheduleData.value!.date,
          monthlyAmount: scheduleData.value!.monthlyAmount,
          dailyAmount: scheduleData.value!.dailyAmount,
          totalSubscription: updatedList.length,
          recurringList: updatedList,
        );
        scheduleData.refresh();
      }
    }
  }

  /// Delete recurring expense at index safely
  void deleteRecurringExpenseAtIndex(int index) {
    if (index >= 0 && index < recurringExpensesList.length) {
      final item = recurringExpensesList[index];
      deleteSchedule(item.id);
    }
  }

  /// Select a day in the strip and fetch its schedules.
  Future<void> selectDay(int index) async {
    if (index < 0 || index >= monthDays.length) return;
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    final selectedDay = monthDays[index]['fullDate'] as DateTime?;
    if (selectedDay == null) return;

    _pendingCenterIndex = index;
    _centerIfReady(animated: true);

    await fetchScheduleByDateTime(selectedDay);
  }

  /// Rebuilds monthDays and scroll target for [anchor] month.
  void rebuildFor(DateTime anchor) {
    final firstDay = DateTime(anchor.year, anchor.month, 1);
    final lastDay = DateTime(anchor.year, anchor.month + 1, 0);
    final firstWeekday = firstDay.weekday;
    final days = <Map<String, dynamic>>[];
    // Add padding for full calendar view
    for (int i = 0; i < (firstWeekday - 1); i++) {
      days.add({
        'day': '',
        'date': '',
        'price': '',
        'dots': 0,
        'fullDate': null,
      });
    }
    // Add actual days
    for (int i = 0; i < lastDay.day; i++) {
      final day = firstDay.add(Duration(days: i));
      days.add({
        'day': DateFormat('E').format(day),
        'date': DateFormat('dd').format(day),
        'price': i % 3 == 0 ? '\$${(i + 1) * 50}' : '',
        'dots': (i % 4),
        'fullDate': day,
      });
    }
    monthDays.value = days;
    final today = DateTime(anchor.year, anchor.month, anchor.day);
    final anchorIndex = days.indexWhere(
      (d) => d['fullDate'] != null && DateUtils.isSameDay(d['fullDate'], today),
    );
    selectedIndex.value = anchorIndex >= 0 ? anchorIndex : 0;
    _pendingCenterIndex = selectedIndex.value;
  }

  /// Move month by [step] and fetch the schedules for the new month (day=1).
  Future<void> changeMonth(int step) async {
    if (isSwitchingMonth.value) return;

    isSwitchingMonth.value = true;
    try {
      final newMonth = DateTime(
        currentDate.value.year,
        currentDate.value.month + step,
        1,
      );
      currentDate.value = newMonth;
      // Rebuild UI first
      rebuildFor(newMonth);
      // Fetch both APIs in parallel for better performance
      await Future.wait([
        fetchMonthCalender(newMonth),
        fetchScheduleByDateTime(newMonth),
      ]);
    } catch (e) {
      // Error changing month
    } finally {
      isSwitchingMonth.value = false;
    }
  }

  /// Set month & year explicitly and fetch that month (day=1).
  Future<void> goToMonthYear(int year, int month) async {
    if (isSwitchingMonth.value) return;

    isSwitchingMonth.value = true;

    try {
      final date = DateTime(year, month, 1);
      currentDate.value = date;

      // Rebuild UI first
      rebuildFor(date);
      fetchMonthCalender(date);
      fetchScheduleByDateTime(date);
    } catch (e) {
      // Error navigating to month/year
    } finally {
      isSwitchingMonth.value = false;
    }
  }

  /// Call this from the widget's LayoutBuilder whenever layout changes.
  void updateViewport({
    required double viewportWidth,
    required double itemExtent,
    required double edge,
    required double gap,
    required int itemCount,
  }) {
    _viewportWidth = viewportWidth;
    _itemExtent = itemExtent;
    _edge = edge;
    _itemCount = itemCount;
    // _gap = gap;
    _centerIfReady(animated: true);
  }

  void _centerIfReady({required bool animated}) {
    if (!scrollController.hasClients) return;
    if (_viewportWidth <= 0 || _itemExtent <= 0 || _itemCount <= 0) return;

    // Ensure index is valid
    final idx = (_pendingCenterIndex ?? selectedIndex.value).clamp(
      0,
      _itemCount - 2,
    );

    // Center the target item
    final itemCenterX = _edge + (idx * _itemExtent);
    double target = itemCenterX - (_viewportWidth) - 300;

    // Limit scroll range
    final contentWidth = _edge * 2 + _itemExtent * _itemCount;
    final maxScroll = (contentWidth - _viewportWidth).clamp(0, double.infinity);

    if (target < 0) target = 0;
    if (target > maxScroll) target = maxScroll.toDouble();

    _pendingCenterIndex = null;

    if (animated) {
      scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      scrollController.jumpTo(target);
    }
  }

  void changeCalender() {
    showMore.value = !showMore.value;
  }

  /// Delete schedule by ID using use case pattern
  Future<void> deleteSchedule(String id) async {
    try {
      isLoadingExpense.value = true;
      errorMessage.value = '';
      // Show loading dialog
      Get.dialog(
        const Center(child: AppLoadingWidget()),
        barrierDismissible: false,
      );

      final result = await deleteScheduleUseCase(DeleteScheduleParams(id: id));

      result.fold(
        (failure) {
          Get.back();
          errorMessage.value = failure.message;
          AppSnackBar.showError(failure.message, title: 'Error');
        },
        (response) {
          Get.back();
          if (response.status == true) {
            // Safely remove from reactive list
            final index = recurringExpensesList.indexWhere(
              (item) => item.id == id,
            );
            if (index >= 0 && index < recurringExpensesList.length) {
              recurringExpensesList.removeAt(index);
            }

            // Update scheduleData if it exists
            if (scheduleData.value != null) {
              final updatedList = List<RecurringItem>.from(
                scheduleData.value!.recurringList,
              )..removeWhere((item) => item.id == id);

              scheduleData.value = RecurringExpensesBody(
                date: scheduleData.value!.date,
                monthlyAmount: scheduleData.value!.monthlyAmount,
                dailyAmount: scheduleData.value!.dailyAmount,
                totalSubscription: updatedList.length,
                recurringList: updatedList,
              );
            }

            // Remove from upcoming schedules
            upcomingSchedules.removeWhere((item) => item.id == id);

            // Refresh reactive lists
            recurringExpensesList.refresh();
            upcomingSchedules.refresh();
            scheduleData.refresh();

            // Refresh calendar data after deletion
            fetchMonthCalender(currentDate.value);

            AppSnackBar.showSuccess(
              response.message ?? 'Schedule removed successfully',
              title: 'Success',
            );
          } else {
            AppSnackBar.showError(
              response.message ?? 'Failed to delete schedule',
              title: 'Error',
            );
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to delete schedule';
      AppSnackBar.showError('Something went wrong', title: 'Error');
    } finally {
      isLoadingExpense.value = false;
      errorMessage.value = '';
    }
  }

  /// Refresh upcoming schedule data (use case pattern)
  Future<void> refreshSchedule() async {
    await fetchUpcomingSchedule();
  }

  /// Refresh schedule data (use case pattern)
  Future<void> refreshScheduleData() async {
    await fetchScheduleByDateTime(currentDate.value);
  }

  /// Fetch upcoming schedules from API (use case pattern)
  Future<void> fetchUpcomingSchedule() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getUpcomingScheduleUseCase();

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          upcomingScheduleData.value = null;
        },
        (data) {
          upcomingScheduleData.value = data;
          upcomingSchedules.value = data.scheduleList;
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to load upcoming schedule data';
      upcomingScheduleData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch schedules from API (use case pattern)
  Future<void> fetchScheduleByDateTime(DateTime selectedDateTime) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await getScheduleUseCase(
        GetScheduleParams(dateTime: selectedDateTime),
      );

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          scheduleData.value = null;
          recurringExpensesList.clear();
        },
        (data) {
          scheduleData.value = data;
          // Update reactive list for safe index management
          recurringExpensesList.value = data.recurringList;
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to load schedule data';
      scheduleData.value = null;
      recurringExpensesList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch schedules for the provided [month] (month precision) using use case.
  Future<void> fetchMonthCalender(DateTime monthDateTime) async {
    try {
      isLoadingCalender.value = true;
      errorMessage.value = '';

      final int monthNumber = monthDateTime.month;
      final int yearNumber = monthDateTime.year;

      final result = await getMonthlyCalenderUseCase(
        GetMonthlyCalenderDataParams(month: monthNumber, year: yearNumber),
      );

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          monthlyCalenderData.value = null;
          monthCalenderDates
            ..clear()
            ..refresh();
        },
        (data) {
          // Save full monthly calendar body
          monthlyCalenderData.value = data;

          // Extract dates with categories for mini calendar UI
          final calendar = data.monthCalendar;
          monthCalenderDates
            ..clear()
            ..addAll(
              calendar.dates.isEmpty ||
                      calendar.dates.every((e) => e.category.isEmpty)
                  ? const []
                  : calendar.dates,
            );

          // Force UI refresh
          monthCalenderDates.refresh();
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to load month calendar';
      monthCalenderDates.value = [];
      monthlyCalenderData.value = null;
    } finally {
      isLoadingCalender.value = false;
    }
  }
}
