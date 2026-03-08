import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/controller/cashflow_controller.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class CashFlowSummaryCard extends GetView<CashFlowController> {
  final String title;
  final double amount;
  final String percentText;
  final String subtitle;
  final String iconPath;
  final Color accentColor;
  final  IconData image;

  const CashFlowSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentText,
    required this.subtitle,
    required this.iconPath,
    required this.accentColor,
    required this.image,

  });
  // ── Helper Functions ──

  /// Returns formatted percent string like "+12%" or "-5%"
  static String formatPercentText(double percent) {
    final cappedPercent = percent > 100 ? 100 : percent;

    final formatted = cappedPercent.toStringAsFixed(0);
    return cappedPercent >= 0 ? '+$formatted%' : '$formatted%';
  }
  /// Returns subtitle based on percent direction
  static String getSubtitle(double percent) {
    return percent >= 0 ? ' Increased Recently' : ' Decreased Recently';
  }

  /// Returns arrow icon based on percent direction
  static IconData getDirectionIcon(double percent) {
    return percent >= 0 ? Icons.arrow_upward : Icons.arrow_downward;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.xs,vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Title row
          Row(
            children: [
              AppImageAvatar(fallbackAsset: iconPath,isCircular: false,),
              AppSpacing.addWidth(AppSpacing.sm),
              Flexible(
                child: AppText(
                  txt: title,
                  style:context.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppSpacing.addHeight(AppSpacing.sm),

          // Amount
          Obx(() {
            if(controller.isCashFlowDetailLoading.value) {
              return ShimmerBlock(width: 100, height: 20);
            }
            return FormattedNumberText(
              value: amount,
              hint:NumberHint.price,
              showSign: true,
              style:  context.textTheme.bodyLarge,
            );
          }),

          AppSpacing.addHeight(AppSpacing.xs),

          // Percent + Subtitle row
          Obx(() {
            if (controller.isCashFlowDetailLoading.value) {
              return ShimmerBlock(width: 120, height: 14);
            }

            return Row(
              children: [
                AppText(
                  txt: percentText,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: AppText(
                    txt: subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                percentText != '0%'
                    ? Row(
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: accentColor,
                      ),
                      child: Icon(
                        image,
                        color: context.colorScheme.surface,
                        size: 14,
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
              ],
            );
          }),
        ],
      ),
    );
  }
}