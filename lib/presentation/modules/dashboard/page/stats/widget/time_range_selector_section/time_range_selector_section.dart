import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:wealthnxai/presentation/widgets/chips/app_chips.dart';

/// Reusable time range selector widget
class TimeRangeSelectorSection extends StatelessWidget {
  /// Reactive selected time range
  final RxString selectedRange;
  
  /// Callback when a range is selected
  final Function(String) onRangeSelected;

  /// Available time ranges
  static const _ranges = ['1M', '3M', '6M', '1Y', 'YTD'];

  const TimeRangeSelectorSection({
    super.key,
    required this.selectedRange,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _ranges
            .map(
              (range) => AppChips(
                label: range,
                isSelected: selectedRange.value == range,
                onTap: () => onRangeSelected(range),
              ),
            )
            .toList(),
      ),
    );
  }
}