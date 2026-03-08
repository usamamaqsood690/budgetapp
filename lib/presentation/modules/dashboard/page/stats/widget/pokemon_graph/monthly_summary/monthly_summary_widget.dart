import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

/// Reusable Monthly Summary Widget
/// Displays income, expense, and cash flow summary
class MonthlySummaryWidget extends StatelessWidget {
  const MonthlySummaryWidget({
    super.key,
    this.monthTitle,
    this.yearTitle,
    required this.title1,
    this.value1,
    this.valuePercent1,
    required this.title2,
    this.value2,
    this.valuePercent2,
    required this.title3,
    this.value3,
    this.valuePercent3,
    this.onYearTap,
  });

  final String? monthTitle;
  final String? yearTitle;
  final String title1;
  final String title2;
  final String title3;
  final double? value1;
  final double? value2;
  final double? value3;
  final double? valuePercent1;
  final double? valuePercent2;
  final double? valuePercent3;
  final VoidCallback? onYearTap;

  @override
  Widget build(BuildContext context) {
    final String displayMonth =
        monthTitle ?? DateFormat('MMMM').format(DateTime.now());
    final String displayYear = yearTitle ?? '2026';
    final double income = value1 ?? 0.00;
    final double incomePct = valuePercent1 ?? 0.00;
    final double expense = value2 ?? 0.00;
    final double expensePct = valuePercent2 ?? 0.0;
    final double cashflow = value3 ?? 0.00;
    final double cashflowPct = valuePercent3 ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 40, 40, 40)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SectionName(
            title: displayMonth,
            titleOnTap: displayYear,
            onTap: onYearTap ?? () {},
          ),
          AppSpacing.addHeight(21),
          Column(
            children: [
              buildSummaryItem(
                title1,
                _buildSubtitle(incomePct),
                FormattedNumberText(
                  value: income,
                  hint: NumberHint.price,
                  showSign: true,
                  style: context.textTheme.bodyLarge,
                ),
                AppColorScheme.primaryColor,
                income == 0
                    ? null
                    : (income > 0 ? Icons.arrow_upward : Icons.arrow_downward),
                income >= 0 ? Colors.green : Colors.red,
                incomePct,
                context,
              ),
              AppDivider(),
              buildSummaryItem(
                title2,
                _buildSubtitle(expensePct),
                FormattedNumberText(
                  value: expense,
                  hint: NumberHint.price,
                  showSign: true,
                  style: context.textTheme.bodyLarge,
                ),
                AppColorScheme.primaryDark,
                expense == 0
                    ? null
                    : (expense > 0 ? Icons.arrow_upward : Icons.arrow_downward),
                expense >= 0 ? Colors.green : Colors.red,
                expensePct,
                context,
              ),
              AppDivider(),
              buildSummaryItem(
                title3,
                _buildSubtitle(cashflowPct),
                FormattedNumberText(
                  value: cashflow,
                  hint: NumberHint.price,
                  showSign: true,
                  style: context.textTheme.bodyLarge,
                ),
                AppColorScheme.primaryWhite,
                cashflow == 0
                    ? null
                    : (cashflow >= 0
                        ? Icons.arrow_upward
                        : Icons.arrow_downward),
                cashflow >= 0 ? Colors.green : Colors.red,
                cashflowPct,
                context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSummaryItem(
    String title,
    String subtitle,
    Widget amount,
    Color colorBox,
    IconData? icon,
    Color iconColor,
    double amountPercentage,
    BuildContext context,
  ) {
    return Container(
      margin: AppSpacing.paddingSymmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: colorBox,
            ),
          ),
          AppSpacing.addWidth(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(txt: title, style: context.bodyLarge),
                AppText(txt: subtitle, style: context.labelSmall),
              ],
            ),
          ),
          amount,
          if (icon != null) ...[
            const SizedBox(width: 12),
            Icon(icon, color: iconColor, size: 20),
          ] else ...[
            const SizedBox(width: 36),
          ],
        ],
      ),
    );
  }

  String _buildSubtitle(double percent) {
    final int absPercent = percent.toInt().abs();
    final String percentText = absPercent > 100 ? '100' : absPercent.toString();
    final String direction =
        percent >= 0 ? 'Increase from last month' : 'Decrease from last month';
    return '$percentText% $direction';
  }
}
