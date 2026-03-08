import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/controller/cashflow_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/widgets/cashflow_header/cashflow_summary_card.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/chart_graph_section/chart_graph_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/pokemon_graph/pokemon_graph_section/pokemon_graph_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/time_range_selector_section/time_range_selector_section.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class OverviewTab extends GetView<CashFlowController> {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            AppText(txt: "Cash Flow", style: context.textTheme.headlineSmall),
            Obx(() {
              final cashFlowValue =
                  controller.cashFlowDetail.value?.cashFlow ?? 0.0;
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
            AppSpacing.addHeight(AppSpacing.md),
            _CashFlowSummarySection(controller: controller),
            AppSpacing.addHeight(AppSpacing.md),
            ChartGraphSection(
              isLoading: controller.isCashFlowChartLoading,
              error: controller.cashFlowChartError,
              data: controller.cashFlowChartData,
            ),
            AppSpacing.addHeight(AppSpacing.sm),
            TimeRangeSelectorSection(
              selectedRange: controller.cashFlowGraphTimeRange,
              onRangeSelected: controller.setCashFLowChartRange,
            ),
            AppSpacing.addHeight(AppSpacing.sm),
            PokemonGraphSection(
              controller: controller,
              title1: 'Income',
              title2: 'Expense',
              title3: 'Cash Flow',
            ),
            AppSpacing.addHeight(AppSpacing.xl),
        ],
      ),
    );
  }
}

class _CashFlowSummarySection extends StatelessWidget {
  final CashFlowController controller;
  const _CashFlowSummarySection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final income = controller.cashFlowDetail.value?.income ?? 0.0;
      final expenses = controller.cashFlowDetail.value?.expenses ?? 0.0;
      final incomePercent = controller.cashFlowDetail.value?.incomePercentChange ?? 0.0;
      final expensePercent = controller.cashFlowDetail.value?.expensePercentChange?? 0.0;

      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePaths.tt),
            fit: BoxFit.contain,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: CashFlowSummaryCard(
                title: 'Income',
                amount: income,
                percentText: CashFlowSummaryCard.formatPercentText(
                  incomePercent,
                ),
                subtitle: CashFlowSummaryCard.getSubtitle(incomePercent),
                image: CashFlowSummaryCard.getDirectionIcon(incomePercent),
                iconPath: ImagePaths.cashIn,
                accentColor: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CashFlowSummaryCard(
                title: 'Expenses',
                amount: expenses,
                percentText: CashFlowSummaryCard.formatPercentText(
                  expensePercent,
                ),
                subtitle: CashFlowSummaryCard.getSubtitle(expensePercent),
                image: CashFlowSummaryCard.getDirectionIcon(expensePercent),
                iconPath: ImagePaths.cashOut,
                accentColor: Colors.red,
              ),
            ),
          ],
        ),
      );
    });
  }
}
