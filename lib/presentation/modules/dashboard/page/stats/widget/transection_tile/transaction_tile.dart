import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/app_common_helper.dart';
import 'package:wealthnxai/core/utils/date_time_helper.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.title,
    this.date,
    this.subTitle,
    required this.amount,
    this.leading,
    this.onTap,
  });

  final String title;
  final String? date;
  final double amount;
  final String? subTitle;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
            ],
            AppSpacing.addWidth(8),
            Expanded(
              child: Padding(
                padding: AppSpacing.paddingOnly(right: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                       txt: CommonAppHelper.formatCategoryName(title),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (date != null) ...[
                      const SizedBox(height: 4),
                      AppText(
                       txt:DateTimeConverter.toMonthDayYear(date!),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                    if (subTitle != null) ...[
                      const SizedBox(height: 4),
                      AppText(
                        txt:subTitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            FormattedNumberText(value: amount),

          ],
        ),
      ),
    );
  }
}