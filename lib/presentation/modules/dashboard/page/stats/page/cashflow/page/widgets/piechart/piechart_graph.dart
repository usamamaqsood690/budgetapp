import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/core/utils/app_common_helper.dart';
import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

/// Reusable Pie Chart Widget for displaying category breakdowns
class PieChartGraph extends StatelessWidget {
  const PieChartGraph({
    super.key,
    required this.categories,
    required this.total,
    required this.totalLabel,
    this.centerSpaceRadius = 70,
    this.chartSize = 158,
    this.showTopCategories = true,
    this.topCategoriesCount = 4,
  });

  final List<TransactionCategory> categories;
  final double total;
  final String totalLabel;
  final double centerSpaceRadius;
  final double chartSize;
  final bool showTopCategories;
  final int topCategoriesCount;


  @override
  Widget build(BuildContext context) {
    if (total == 0 || categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final topCategories = categories.take(topCategoriesCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.addHeight(AppSpacing.md),
        Padding(
          padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
          child: Column(
            children: [
              SizedBox(
                width: chartSize,
                height: chartSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: centerSpaceRadius,
                        sections:CommonAppHelper.buildPieChartSections(categories, total),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            width: 0.5,
                          ),
                        ),
                        padding: EdgeInsets.all(Get.width * 0.07),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              maxLines: 1,
                             txt: totalLabel,
                            ),
                            FormattedNumberText(value: total),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (showTopCategories) ...[
              AppSpacing.addHeight(AppSpacing.md),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: topCategories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    childAspectRatio: 4.5,
                  ),
                  itemBuilder: (context, index) {
                    final category = topCategories[index];
                    final percentage = (category.totalAmount / total) * 100;
                    final categoryName = CommonAppHelper.formatCategoryName(category.name);

                    return Row(
                      children: [
                        Container(
                          width: 2,
                          height: 20,
                          decoration: BoxDecoration(
                            color: CommonAppHelper.fixedColors[index % CommonAppHelper.fixedColors.length],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        AppSpacing.addWidth(AppSpacing.xs),
                        Expanded(
                          child: AppText(
                            txt:categoryName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.labelSmall,
                          ),
                        ),
                        AppSpacing.addWidth(AppSpacing.sm),
                        Row(
                          children: [
                            FormattedNumberText(value: category.totalAmount,style:  context.textTheme.labelSmall?.copyWith(fontSize: 9),),
                            AppSpacing.addWidth(AppSpacing.xs),
                            Text('(', style: context.textTheme.labelSmall?.copyWith(fontSize: 9)),
                            FormattedNumberText(
                              value: percentage,
                              color: context.colorScheme.onPrimary,
                              hint: NumberHint.percentChange,
                              style: context.textTheme.labelSmall?.copyWith(fontSize: 9),
                            ),
                            Text(')', style: context.textTheme.labelSmall?.copyWith(fontSize: 9)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                // const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
