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

class AssetsTab extends GetView<NetWorthController> {
  const AssetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Assets title & total
          AppText(txt: "Assets", style: context.textTheme.headlineSmall),
          Obx(() {
            final assetsValue = controller.totalAssets;
            if (controller.isNetWorthDetailLoading.value) {
              return ShimmerBlock(width: 150, height: 30);
            }

            return FormattedNumberText(
              value: assetsValue,
              hint: NumberHint.price,
              showSign: false,
              style: context.textTheme.headlineMedium,
            );
          }),
          AppSpacing.addHeight(AppSpacing.md),

          // Assets chart
          ChartGraphSection(
            isLoading: controller.isAssetsChartLoading,
            error: controller.assetsChartError,
            data: controller.assetsChartData,
          ),
          AppSpacing.addHeight(AppSpacing.sm),

          // Range selector row
          TimeRangeSelectorSection(
            selectedRange: controller.assetsGraphTimeRange,
            onRangeSelected: controller.setAssetsChartRange,
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
                    AppDivider(),
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
        ],
      ),
    );
  }
}
