import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/app_common_helper.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/controller/transaction_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/widget/filter_page_widget/selection_item_tile.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/widget/filter_page_widget/filter_item_tile.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';

class TransactionFilterScreen extends GetView<TransactionsController> {
  const TransactionFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBar(title: 'Filter'),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal:AppSpacing.md),
                  child: Column(
                    children: [
                      // addHeight(8),
                      FilterItemTile(
                        icon: ImagePaths.dateIcon,
                        title: 'Dates',
                        subtitle: controller.getDateRangeDisplay(),
                        onTap: () => _showDatePicker(),
                      ),
                      const AppDivider(),
                      FilterItemTile(
                        icon: ImagePaths.moneyIcon,
                        title: 'Amount',
                        subtitle: controller.getAmountRangeDisplay(),
                        onTap: () {
                          _showAmountPicker();
                        },
                      ),
                      const AppDivider(),
                      FilterItemTile(
                        icon: ImagePaths.categoryIcon,
                        title: 'Categories',
                        subtitle: controller.getCategoriesDisplay(),
                        onTap:
                            () => _showSelectionBottomSheet(
                              title: 'Category',
                              subtitle: 'Select these types for categories.',
                              options: controller.categories,
                              selectedValues: controller.selectedCategories,
                              isSingleSelect: false,
                              showAllOption: false,
                              onSave: (selected) {
                                controller.toggleCategory(selected);
                              },
                              showIcon: true,
                              isCategory: true,
                            ),
                      ),
                      const AppDivider(),
                      FilterItemTile(
                        icon: ImagePaths.sortByIcon,
                        title: 'Sort By',
                        subtitle: controller.getSortByDisplay(),
                        onTap: () => _showSortByPicker(),
                      ),
                      const AppDivider(),
                      FilterItemTile(
                        icon: ImagePaths.transTypeIcon,
                        title: 'Transaction Type',
                        subtitle: controller.getTransactionTypeDisplay(),
                        onTap:
                            () => _showSelectionBottomSheet(
                              title: 'Transaction Type',
                              subtitle: 'Select these types for Transactions.',
                              options: controller.transactionTypes,
                              selectedValues:
                                  controller.selectedTransactionType,
                              isSingleSelect: false,
                              showAllOption: true,
                              onSave: (selected) {
                                controller.setTransactionType(selected);
                              },
                              showIcon: false,
                              isCategory: false,
                            ),
                      ),
                      const AppDivider(),
                      FilterItemTile(
                        icon: ImagePaths.bank_icon,
                        title: 'Financial Accounts',
                        subtitle: controller.getAccountsDisplay(),
                        onTap:
                            () => _showSelectionBottomSheet(
                              title: 'Financial Accounts',
                              subtitle: 'Select these types for accounts.',
                              options: controller.financialAccounts,
                              selectedValues: controller.selectedAccounts,
                              isSingleSelect: false,
                              showAllOption: true,
                              onSave: (selected) {
                                controller.setAccounts(selected);
                              },
                              showIcon: true,
                              isCategory: false,
                            ),
                      ),
                      // addHeight(20),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    onTap: () {
                      controller.applyFilters();
                      Get.back();
                    },
                    txt: 'Apply Filters',
                  ),
                  // addHeight(12),
                  AppButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    onTap: () {
                      controller.resetFilters();
                      Get.back();
                    },
                    txt: 'Reset Filters',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    _showRadioBottomSheet(
      title: 'Date Range',
      subtitle: 'Select date range for transactions.',
      options: controller.dates,
      selectedValue:
          controller.selectedDate.value.isEmpty
              ? 'All time'
              : controller.selectedDate.value,
      onSave: (selected) {
        controller.selectedDate.value = selected;

        // Calculate date range based on selection
        DateTime now = DateTime.now();
        DateTime startDate;
        DateTime endDate = now;

        switch (selected) {
          case 'Last 7 days':
            startDate = now.subtract(const Duration(days: 7));
            controller.setDateRange(
              DateTimeRange(start: startDate, end: endDate),
            );
            break;
          case 'Last 30 days':
            startDate = now.subtract(const Duration(days: 30));
            controller.setDateRange(
              DateTimeRange(start: startDate, end: endDate),
            );
            break;
          case 'Last 90 days':
            startDate = now.subtract(const Duration(days: 90));
            controller.setDateRange(
              DateTimeRange(start: startDate, end: endDate),
            );
            break;
          case 'This month':
            startDate = DateTime(now.year, now.month, 1);
            controller.setDateRange(
              DateTimeRange(start: startDate, end: endDate),
            );
            break;
          case 'Last month':
            startDate = DateTime(now.year, now.month - 1, 1);
            endDate = DateTime(now.year, now.month, 0);
            controller.setDateRange(
              DateTimeRange(start: startDate, end: endDate),
            );
            break;
          case 'All time':
          default:
            controller.setDateRange(null);
            break;
        }
      },
    );
  }

  void _showSortByPicker() {
    _showRadioBottomSheet(
      title: 'Sort by',
      subtitle: 'Select these types for Sorting',
      options: controller.sortOptions,
      selectedValue: controller.selectedSortBy.value,
      onSave: (selected) {
        controller.setSortBy(selected);
      },
    );
  }

  void _showAmountPicker() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade700, width: 1.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Select Amount Range',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Select these types for Amounts.',
                                style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 28,
                            child: AppButton(
                              // margin: EdgeInsets.zero,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(
                                  46,
                                  173,
                                  165,
                                  1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              txt: "Save",
                              // textStyle: const TextStyle(
                              //   color: Colors.white,
                              //   fontSize: 12,
                              //   fontWeight: FontWeight.w500,
                              // ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    // CRITICAL FIX: Ensure min and max are valid, use defaults if not
                    final minValue =
                        (controller.lowAmountRange > 0)
                            ? controller.lowAmountRange
                            : 0.0;
                    final maxValue =
                        (controller.highAmountRange > minValue)
                            ? controller.highAmountRange
                            : 10000.0;

                    final savedRange = controller.selectedAmountRange.value;

                    // Ensure values are within valid range
                    final validatedRange =
                        savedRange != null
                            ? RangeValues(
                              savedRange.start.clamp(minValue, maxValue),
                              savedRange.end.clamp(minValue, maxValue),
                            )
                            : RangeValues(minValue, maxValue);

                    // Update controller if values were clamped
                    if (savedRange != validatedRange) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.selectedAmountRange.value = validatedRange;
                      });
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${validatedRange.start.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '\$${validatedRange.end.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2.0,
                            // activeTrackColor: CustomAppTheme.primaryColor,
                            inactiveTrackColor: Colors.grey.shade700,
                            thumbColor: Colors.white,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8.0,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 16.0,
                            ),
                            // overlayColor: CustomAppTheme.primaryColor
                            //     .withOpacity(0.2),
                            rangeThumbShape: const RoundRangeSliderThumbShape(
                              enabledThumbRadius: 8.0,
                            ),
                            rangeTrackShape:
                                const RoundedRectRangeSliderTrackShape(),
                            valueIndicatorColor: Colors.grey.shade600,
                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            showValueIndicator: ShowValueIndicator.always,
                          ),
                          child: RangeSlider(
                            values: validatedRange,
                            min: minValue,
                            max: maxValue,
                            divisions: 100,
                            labels: RangeLabels(
                              '\$${validatedRange.start.toStringAsFixed(0)}',
                              '\$${validatedRange.end.toStringAsFixed(0)}',
                            ),
                            onChanged: (RangeValues values) {
                              controller.selectedAmountRange.value = values;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSelectionBottomSheet({
    required String title,
    required String subtitle,
    required List<CustomModelForIconWithHeading> options,
    required List<CustomModelForIconWithHeading> selectedValues,
    required bool isSingleSelect,
    required Function(List<CustomModelForIconWithHeading>) onSave,
    bool showAllOption = false,
    required bool showIcon,
    required bool isCategory,
  }) {
    final tempSelected = List<CustomModelForIconWithHeading>.from(selectedValues,);

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Check if all accounts are selected by comparing lists
            bool isAllSelected =
                showAllOption &&
                tempSelected.length == options.length &&
                tempSelected.every((item) => options.contains(item));

            return Container(
              height: Get.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade700, width: 0.5),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 56,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header with title and save button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: 32,
                              child: AppButton(
                                // margin: EdgeInsets.zero,
                                // padding: EdgeInsets.only(left: 20),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(
                                    46,
                                    173,
                                    165,
                                    1,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                txt: "Save",
                                // textStyle: const TextStyle(
                                //   color: Colors.white,
                                //   fontSize: 13,
                                //   fontWeight: FontWeight.w500,
                                // ),
                                onTap: () {
                                  onSave(tempSelected);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable list
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // All option (only for multi-select with showAllOption)
                          if (showAllOption && !isSingleSelect) ...[
                            SelectionItemTile(
                              label: 'All Accounts',
                              isSelected: isAllSelected,
                              showIcon: showIcon,
                              onTap: () {
                                setModalState(() {
                                  if (isAllSelected) {
                                    // If all selected, deselect all
                                    tempSelected.clear();
                                  } else {
                                    // If not all selected, select all
                                    tempSelected.clear();
                                    tempSelected.addAll(options);
                                  }
                                });
                              },
                              isCategory: isCategory,
                            ),
                            Divider(
                              color: Colors.grey.withOpacity(0.2),
                              height: 1,
                            ),
                          ],

                          // Individual options
                          ...options.map((option) {
                            bool isSelected = tempSelected.contains(option);
                            return SelectionItemTile(
                              urlLogo: option.logoName,
                              label:CommonAppHelper.formatCategoryName(option.name) ,
                              isSelected: isSelected,
                              showIcon: showIcon,
                              onTap: () {
                                setModalState(() {
                                  if (isSingleSelect) {
                                    tempSelected.clear();
                                    tempSelected.add(option);
                                  } else {
                                    if (isSelected) {
                                      // Deselect the option
                                      tempSelected.remove(option);
                                    } else {
                                      // Select the option
                                      tempSelected.add(option);
                                    }
                                    // Note: We don't automatically select/deselect "All"
                                    // The isAllSelected check at the top will handle the display
                                  }
                                });
                              },
                              isCategory: isCategory,
                            );
                          }).toList(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRadioBottomSheet({
    required String title,
    required String subtitle,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSave,
  }) {
    String tempSelected = selectedValue;

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade700, width: 0.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Add spacing between title and button
                        Expanded(
                          child: SizedBox(
                            height: 32,
                            width: 50,
                            child: AppButton(
                              // margin: EdgeInsets.zero,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(
                                  46,
                                  173,
                                  165,
                                  1,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              txt: "Save",
                              // textStyle: const TextStyle(
                              //   color: Colors.white,
                              //   fontSize: 13,
                              //   fontWeight: FontWeight.w500,
                              // ),
                              onTap: () {
                                onSave(tempSelected);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Radio options
                  ...options.map((option) {
                    bool isSelected = tempSelected == option;
                    return InkWell(
                      onTap: () {
                        setModalState(() {
                          tempSelected = option;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              // horizontal: marginSide(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.white54,
                                      width: 2,
                                    ),
                                  ),
                                  child:
                                      isSelected
                                          ? Center(
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                          : null,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey.withOpacity(0.2),
                            height: 1,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}



