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

class IncomeTab extends GetView<CashFlowController> {
  const IncomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            //Income Text
            AppText(txt: "Income", style: context.textTheme.headlineSmall),
            Obx(() {
              final cashFlowValue =
                  controller.cashFlowDetail.value?.income ?? 0.0;
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
              isLoading: controller.isIncomeChartLoading,
              error: controller.incomeChartError,
              data: controller.incomeChartData,
            ),
            AppSpacing.addHeight(AppSpacing.sm),
            // Range selector row
            TimeRangeSelectorSection(
              selectedRange: controller.incomeGraphTimeRange,
              onRangeSelected: controller.setIncomeChartRange,
            ),
            AppSpacing.addHeight(AppSpacing.lg),

            // Income Categories Section
            Obx(() {
              return CategoriesPieChartSection(
                categories: controller.incomeCategories,
                total: controller.incomeTotal,
                totalLabel: "Total  Income",
                sectionTitle: "Income",
                emptyMessage: "You don't have any income yet",
                isLoading: controller.isCashFlowDetailLoading.value,
                error: controller.cashFlowDetailError.value,
              );
            }),
        ],
      ),
    );
  }
}
