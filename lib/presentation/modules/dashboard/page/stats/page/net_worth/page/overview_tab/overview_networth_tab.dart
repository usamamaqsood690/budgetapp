import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/net_worth/controller/networth_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/chart_graph_section/chart_graph_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/pokemon_graph/pokemon_graph_section/pokemon_graph_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/stats_card/summary_list_section/summary_list_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/time_range_selector_section/time_range_selector_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/transection_tile/transaction_tile.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';
import 'package:wealthnxai/presentation/widgets/spacer/app_empty_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class OverviewNetworthTab extends GetView<NetWorthController> {
  const OverviewNetworthTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Net worth title & value
          AppText(txt: "Net Worth", style: context.textTheme.headlineSmall),
          Obx(() {
            final netWorthValue = controller.totalNetWorth;
            if (controller.isNetWorthDetailLoading.value) {
              return ShimmerBlock(width: 150, height: 30);
            }
            return FormattedNumberText(
              value: netWorthValue,
              hint: NumberHint.price,
              showSign: true,
              style: context.textTheme.headlineMedium,
            );
          }),
          AppSpacing.addHeight(AppSpacing.md),

          // Net worth chart
          ChartGraphSection(
            isLoading: controller.isNetWorthChartLoading,
            error: controller.netWorthChartError,
            data: controller.netWorthChartData,
          ),
          AppSpacing.addHeight(AppSpacing.sm),

          // Range selector for net worth chart
          TimeRangeSelectorSection(
            selectedRange: controller.netWorthGraphTimeRange,
            onRangeSelected: controller.setNetWorthChartRange,
          ),
          AppSpacing.addHeight(AppSpacing.sm),

          // Pokemon-style summary (Assets, Liabilities, Net Worth)
          PokemonGraphSection(
            controller: controller,
            title1: 'Assets',
            title2: 'Liabilities',
            title3: 'Net Worth',
          ),

          AppSpacing.addHeight(AppSpacing.xl),
          SummaryListSection(
            title: "Assets",
            listTile: Obx(() {
              final assets =
                  controller.netWorthDetail.value?.assets ?? [];

              if (assets.isEmpty) {
                return Empty(
                  title: "You don't have any assets yet",
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: assets.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return TransactionTile(
                    title: asset.name,
                    amount: asset.availableBalance,
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
            emptyMessage: "You don't have any assets yet",
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
