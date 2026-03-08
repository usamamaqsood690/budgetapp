import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/app_common_helper.dart';
import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/schdule_list_card/group_list_schdule_list.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/schdule_list_card/schedule_card.dart';
import 'package:wealthnxai/presentation/widgets/state_manager/app_state_builder.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class ScheduleListSection extends GetView<ScheduleController> {
  const ScheduleListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(() {
        // Use reactive list from controller for safe index management
        final expenses = controller.recurringExpensesList.toList();
        final isLoading = controller.isLoading.value;
        final hasError = controller.errorMessage.value.isNotEmpty;
        final errorMessage = controller.errorMessage.value;

        return AppStateBuilder<List<RecurringItem>>(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          isEmpty: expenses.isEmpty && !isLoading && !hasError,
          emptyMessage: 'No Task yet. Start Schedule to see details here',
          errorTitle: 'Failed to load schedules',
          onRetry: () => controller.refreshScheduleData(),
          data: expenses,
          dataWidget: (data) => buildGroupedExpenses(context, data),
          emptyWidget: Padding(
            padding: AppSpacing.paddingSymmetric(
                horizontal: AppSpacing.sm),
            child: Container(
              padding: AppSpacing.paddingSymmetric(vertical: AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.grey,
                    width: AppDimensions.borderWidthThin),
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppDimensions.radiusMD)),
              ),
              child: Center(
                child: AppText(
                  txt: "No Task yet. Start Schedule to see details here",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}