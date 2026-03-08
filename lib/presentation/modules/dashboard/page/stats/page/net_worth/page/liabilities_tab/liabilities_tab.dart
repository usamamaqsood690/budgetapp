import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/net_worth/controller/networth_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/chart_graph_section/chart_graph_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/stats_card/summary_list_section/summary_list_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/time_range_selector_section/time_range_selector_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/transection_tile/transaction_tile.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';
import 'package:wealthnxai/presentation/widgets/spacer/app_empty_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class LiabilitiesTab extends GetView<NetWorthController> {
  const LiabilitiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Liabilities title & total
          AppText(
            txt: "Liabilities",
            style: context.textTheme.headlineSmall,
          ),
          Obx(() {
            final liabilitiesValue = controller.totalLiabilities;
            if (controller.isNetWorthDetailLoading.value) {
              return ShimmerBlock(width: 150, height: 30);
            }
            return FormattedNumberText(
              value: liabilitiesValue,
              hint: NumberHint.price,
              showSign: false,
              style: context.textTheme.headlineMedium,
            );
          }),
          AppSpacing.addHeight(AppSpacing.md),

          // Liabilities chart
          ChartGraphSection(
            isLoading: controller.isLiabilitiesChartLoading,
            error: controller.liabilitiesChartError,
            data: controller.liabilitiesChartData,
          ),
          AppSpacing.addHeight(AppSpacing.sm),

          // Range selector row
          TimeRangeSelectorSection(
            selectedRange: controller.liabilitiesGraphTimeRange,
            onRangeSelected: controller.setLiabilitiesChartRange,
          ),
          AppSpacing.addHeight(AppSpacing.xl),
          SummaryListSection(
            title: "Liabilities",
            listTile: Obx(() {
              final assets =
                  controller.netWorthDetail.value?.liabilities ?? [];

              if (assets.isEmpty) {
                return Empty(
                  title: "You don't have any liabilities yet",
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: assets.length,
                separatorBuilder: (_, __) =>
                AppDivider(),
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return TransactionTile(
                    title: asset.name,
                    amount: asset.amount,
                    subTitle: '***${"${asset.accountNumber} ${asset.bankName}"}',
                    leading: AppImageAvatar(
                      fallbackAsset: ImagePaths.bank_icon,
                      avatarUrl: asset.bankLogo,
                      isCircular: true,
                      radius: 20,
                    ),
                  );
                },
              );
            }),
            emptyMessage: "You don't have any transactions yet",
          ),
          AppSpacing.addHeight(21),
        ],
      ),
    );
  }
}
