import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/subscription_summary/subscription_summary_shimmer.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class SubscriptionSummary extends GetView<ScheduleController> {
  const SubscriptionSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final border = Border.all(color: context.colors.grey, width: AppDimensions.borderWidthThin);
    final radius =AppDimensions.radiusMD;

    return Obx(() {
      final scheduleData = controller.scheduleData.value;

      // Show loading state
      if (controller.isLoading.value) {
        return Container(
          padding:AppSpacing.paddingSymmetric(vertical: AppSpacing.md,horizontal: AppSpacing.sm) ,
          decoration: BoxDecoration(border: border, borderRadius: BorderRadius.circular(radius)),
          child: subscriptionSummaryShimmer(),
        );
      }

      // Show error state
      if (controller.errorMessage.value.isNotEmpty) {
        return Container(
          padding: AppSpacing.paddingSymmetric(vertical: AppSpacing.md,horizontal: AppSpacing.sm) ,
          decoration: BoxDecoration(border: border, borderRadius: BorderRadius.circular(radius)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(height: 8),
                AppText(
                  txt:controller.errorMessage.value,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => controller.refreshScheduleData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      // Show data (even if amounts are 0)
      final monthlyAmount = scheduleData?.monthlyAmount ?? 0.0;
      final todayAmount = scheduleData?.dailyAmount ?? 0.0;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        decoration: BoxDecoration(border: border, borderRadius: BorderRadius.circular(radius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Expanded(
              child: InfoBox(
                value: "\$${monthlyAmount.toStringAsFixed(2)}",
                label: "Monthly Amount",
                isPrice: true,
              ),
            ),
            summaryDividerAsset(),
            Expanded(
              child: InfoBox(
                value: "\$${todayAmount.toStringAsFixed(2)}",
                label: "Today's Amount",
                isPrice: true,
              ),
            ),
            summaryDividerAsset(),
            Expanded(
              child: InfoBox(
                value: controller.scheduleData.value?.totalSubscription.toString() ?? '0',
                label: "Total Subscriptions",
                showSign: false,
                isPrice: false,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class InfoBox extends StatelessWidget {
  final String value;
  final String label;
  final bool showSign;
  final bool isPrice;

  const InfoBox({super.key, required this.value, required this.label,this.showSign = true,required this.isPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child:  FormattedNumberText(
            value: value,
            hint:isPrice? NumberHint.price:NumberHint.plain,
            showSign: showSign,
            style:  context.textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 6),
        Flexible(
          child: AppText(
            txt: label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
             style:  context.textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}



