import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/controller/cashflow_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/widgets/cashflow_transaction_list/cashflow_transaction_list.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/widgets/piechart/categories_pie_chart_section/categories_pie_chart_shimmer.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/widgets/piechart/piechart_graph.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/transection_tile/transaction_tile.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/presentation/widgets/spacer/app_empty_widget.dart';

/// Reusable widget for displaying categories pie chart and list
class CategoriesPieChartSection extends GetView<CashFlowController> {
  const CategoriesPieChartSection({
    super.key,
    required this.categories,
    required this.total,
    required this.totalLabel,
    required this.sectionTitle,
    required this.emptyMessage,
    required this.isLoading,
    required this.error,
  });

  final List<TransactionCategory> categories;
  final double total;
  final String totalLabel;
  final String sectionTitle;
  final String emptyMessage;
  final bool isLoading;
  final String error;

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (isLoading) {
      return CategoriesPieChartShimmer();
    }

    // Check if we have categories
    final hasCategories = categories.isNotEmpty;
    // If there's an error or no data
    if (error.isNotEmpty || (!hasCategories && !isLoading)) {
      return Container(
        padding: AppSpacing.paddingAll(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: context.colorScheme.outline),
          borderRadius: AppDimensions.borderRadiusMD,
        ),
        child: Empty(title: error.isNotEmpty ? error : emptyMessage, width: 70),
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.outline),
            borderRadius: AppDimensions.borderRadiusMD,
          ),
          child: PieChartGraph(
            categories: categories,
            total: total,
            totalLabel: totalLabel,
          ),
        ),
        Container(
          padding: AppSpacing.paddingAll(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.outline),
            borderRadius: AppDimensions.borderRadiusMD,
          ),
          child: Column(
            children: [
              SectionName(title: sectionTitle, titleOnTap: ''),
              if('Expense' == sectionTitle) ...[

                // Expense filter buttons (All, Recurring, Non Recurring)
                Obx(() {
                  final selectedFilter = controller.selectedExpenseFilter.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _ExpenseFilterChip(
                        label: 'All',
                        isSelected: selectedFilter == 'all',
                        onTap: () => controller.setExpenseFilter('all'),
                      ),
                      SizedBox(width: 8),
                      _ExpenseFilterChip(
                        label: 'Recurring',
                        isSelected: selectedFilter == 'recurring',
                        onTap: () => controller.setExpenseFilter('recurring'),
                      ),
                      SizedBox(width: 8),
                      _ExpenseFilterChip(
                        label: 'Non Recurring',
                        isSelected: selectedFilter == 'non_recurring',
                        onTap: () => controller.setExpenseFilter('non_recurring'),
                      ),
                    ],
                  );
                }),
              ],
              AppSpacing.addHeight(AppSpacing.sm),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return TransactionTile(
                      title: categories[index].name,
                      amount: categories[index].totalAmount,
                      leading: AppImageAvatar(
                        fallbackAsset: ImagePaths.bank_icon,
                        avatarUrl: categories[index].categoryIcon,
                        isCircular: true,
                        radius: 15,
                      ),
                      onTap: () {
                        Get.to(
                          () => const CategoryTransactionListPage(),
                          arguments: {'transaction': categories[index]},
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const AppDivider(),
                )
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpenseFilterChip extends StatelessWidget {
  const _ExpenseFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: AppSpacing.paddingSymmetric(
          vertical: AppSpacing.sm,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        backgroundColor: isSelected
            ? context.colorScheme.primary
            : Colors.transparent,
        foregroundColor: isSelected
            ? context.colorScheme.onPrimary
            : context.colorScheme.onSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.outline,
          ),
        ),
      ),
       child: Padding(
         padding:AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
         child: Text(label),
       ),
    );
  }
}