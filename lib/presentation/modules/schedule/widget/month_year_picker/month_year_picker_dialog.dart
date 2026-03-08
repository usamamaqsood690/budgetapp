import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/widgets/dialogs/app_dialog.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class MonthYearPickerDialog extends StatefulWidget {
  final ScheduleController controller;

  const MonthYearPickerDialog({super.key, required this.controller});

  @override
  State<MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  late final int currentYear;
  late final int currentMonth;

  late int selectedYear;
  late int selectedMonth; // 1..12

  List<int> _visibleMonthsForYear(int year) {
    if (year < currentYear) {
      return List<int>.generate(12, (i) => i + 1); // All months
    }
    return List<int>.generate(currentMonth, (i) => i + 1);
  }

  List<int> get _years =>
      List<int>.generate(currentYear - 2000 + 1, (i) => 2000 + i);

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;

    final anchor = widget.controller.currentDate.value;
    selectedYear = anchor.year > currentYear ? currentYear : anchor.year;
    selectedMonth = anchor.month;

    final visibleMonths = _visibleMonthsForYear(selectedYear);
    if (!visibleMonths.contains(selectedMonth)) {
      selectedMonth =
          visibleMonths.isNotEmpty ? visibleMonths.last : currentMonth;
    }

    monthController = FixedExtentScrollController(
      initialItem: _visibleMonthsForYear(selectedYear).indexOf(selectedMonth),
    );
    yearController = FixedExtentScrollController(
      initialItem: selectedYear - 2000,
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthsForYear = _visibleMonthsForYear(selectedYear);
    return AppDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                txt: 'Select Month & Year',
                style: TextStyle(
                  fontSize: AppTextTheme.fontSize18,
                  fontWeight: AppTextTheme.weightSemiBold,
                  color: context.colors.onSurface,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: context.colors.onSurface.withOpacity(0.7),
                  size: 22,
                ),
                onPressed: () => Get.back(),
                tooltip: 'Close',
              ),
            ],
          ),
          AppSpacing.addHeight(AppSpacing.md),

          // Month and Year Labels
          Row(
            children: [
              Expanded(
                child: Center(
                  child: AppText(
                    txt: 'Month',
                    style: TextStyle(
                      fontSize: AppTextTheme.fontSize14,
                      color: context.colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: AppText(
                    txt: 'Year',
                    style: TextStyle(
                      fontSize: AppTextTheme.fontSize14,
                      color: context.colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.addHeight(AppSpacing.sm),

          // Month and Year Pickers
          SizedBox(
            height: AppSpacing.responTextHeight(150),
            child: Row(
              children: [
                // MONTH WHEEL
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    controller: monthController,
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      if (monthsForYear.isEmpty) return;
                      setState(() => selectedMonth = monthsForYear[index]);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount:
                          monthsForYear.isEmpty ? 1 : monthsForYear.length,
                      builder: (context, index) {
                        if (monthsForYear.isEmpty) {
                          return Center(
                            child: AppText(
                              txt: '—',
                              style: TextStyle(
                                color: context.colors.onSurface.withOpacity(
                                  0.38,
                                ),
                              ),
                            ),
                          );
                        }
                        final m = monthsForYear[index];
                        final isSel = m == selectedMonth;
                        return AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color:
                                isSel
                                    ? context.colors.onSurface
                                    : context.colors.onSurface.withOpacity(
                                      0.54,
                                    ),
                            fontSize:
                                isSel
                                    ? AppTextTheme.fontSize18
                                    : AppTextTheme.fontSize16,
                            fontWeight:
                                isSel
                                    ? AppTextTheme.weightBold
                                    : AppTextTheme.weightRegular,
                          ),
                          child: Center(
                            child: AppText(
                              txt: DateFormat.MMMM().format(DateTime(2000, m)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // YEAR WHEEL
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    controller: yearController,
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedYear = _years[index];
                        final newMonths = _visibleMonthsForYear(selectedYear);

                        if (!newMonths.contains(selectedMonth)) {
                          selectedMonth =
                              newMonths.isNotEmpty
                                  ? newMonths.last
                                  : currentMonth;
                        }

                        // Snap month wheel to valid index
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final idx = _visibleMonthsForYear(
                            selectedYear,
                          ).indexOf(selectedMonth);
                          if (idx >= 0) monthController.jumpToItem(idx);
                        });
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _years.length,
                      builder: (context, index) {
                        final y = _years[index];
                        final isSel = y == selectedYear;
                        return AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color:
                                isSel
                                    ? context.colors.onSurface
                                    : context.colors.onSurface.withOpacity(
                                      0.54,
                                    ),
                            fontSize:
                                isSel
                                    ? AppTextTheme.fontSize18
                                    : AppTextTheme.fontSize16,
                            fontWeight:
                                isSel
                                    ? AppTextTheme.weightBold
                                    : AppTextTheme.weightRegular,
                          ),
                          child: Center(child: AppText(txt: '$y')),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.addHeight(AppSpacing.sm),

          // OK Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                widget.controller.goToMonthYear(selectedYear, selectedMonth);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: AppText(
                txt: 'Ok',
                style: TextStyle(
                  color: context.colors.onPrimary,
                  fontSize: AppTextTheme.fontSize16,
                  fontWeight: AppTextTheme.weightMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
