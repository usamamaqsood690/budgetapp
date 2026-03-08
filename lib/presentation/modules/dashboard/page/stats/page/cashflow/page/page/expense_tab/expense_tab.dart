import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/controller/cashflow_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/chart_graph_section/chart_graph_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/time_range_selector_section/time_range_selector_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/widgets/piechart/categories_pie_chart_section/categories_pie_chart_section.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class ExpenseTab extends GetView<CashFlowController> {
  const ExpenseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            //Income Text
            AppText(txt: "Expense", style: context.textTheme.headlineSmall),
            Obx(() {
              final cashFlowValue =
                  controller.cashFlowDetail.value?.expenses ?? 0.0;
              if (controller.isCashFlowDetailLoading.value) {
                return ShimmerBlock(width: 150, height: 30);
              }
              return FormattedNumberText(
                value: cashFlowValue,
                hint: NumberHint.price,
                showSign: true,
                style: context.textTheme.headlineMedium,
              );
            }),
            // Graph Chart
            ChartGraphSection(
              isLoading: controller.isExpenseChartLoading,
              error: controller.expenseChartError,
              data: controller.expenseChartData,
            ),
            AppSpacing.addHeight(AppSpacing.sm),
            // Range selector row
            TimeRangeSelectorSection(
              selectedRange: controller.expenseGraphTimeRange,
              onRangeSelected: controller.setExpenseChartRange,
            ),
            AppSpacing.addHeight(AppSpacing.md),

            // Expense Categories Section
            Obx(() {
              return CategoriesPieChartSection(
                categories: controller.expenseCategories,
                total: controller.expenseTotal,
                totalLabel: "Total Expense",
                sectionTitle: "Expense",
                emptyMessage: "You don't have any expenses yet",
                isLoading: controller.isCashFlowDetailLoading.value,
                error: controller.cashFlowDetailError.value,
              );
            }),
        ],
      ),
    );
  }
}
