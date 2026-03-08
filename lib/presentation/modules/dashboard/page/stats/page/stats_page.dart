import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/controller/plaid_connection_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/widget/financial_snapshot.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/controller/stats_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/chart_graph_section/chart_graph_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/networth_top_section/networth_graph_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/stats_card/budget_card/budget_card.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/stats_card/cashflow_card/cashflow_card.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/stats_card/networth_card/networth_card.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/stats_card/schedule_card/schedule_card.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/stats_card/summary_list_section/summary_list_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/transection_tile/transaction_tile.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/time_range_selector_section/time_range_selector_section.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/spacer/app_empty_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class StatsPage extends GetView<StatsController> {
   StatsPage({super.key});

  final ScheduleController _scheduleController =
  Get.find<ScheduleController>();
   final PlaidConnectionController _checkPlaidConnectionController =
   Get.find<PlaidConnectionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Stats",
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchStatsSummary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               FinancialSnapshot(showTitle: false),
              AppSpacing.addHeight(30),
              const NetWorthSection(),
              ChartGraphSection(
                isLoading: controller.isNetWorthChartLoading,
                error: controller.netWorthChartError,
                data: controller.netWorthChartData,
              ),
              AppSpacing.addHeight(AppSpacing.sm),
              TimeRangeSelectorSection(
                selectedRange: controller.netWorthGraphTimeRange,
                onRangeSelected: controller.setNetWorthChartRange,
              ),
              AppSpacing.addHeight(AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                       Get.toNamed(Routes.NETWORTH);
                      },
                      child: NetWorthSummaryCard(
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                        onTap: (){
                          if( (_scheduleController
                              .upcomingScheduleData
                              .value
                              ?.currentMonthTotal ??
                              0.0) ==
                              0.0 && _checkPlaidConnectionController.plaidResponse.value?.body.isPlaidConnected == true){
                            Get.toNamed(Routes.ADD_SCHEDULE);
                          }else{
                            Get.toNamed(Routes.SCHEDULE);
                          }
                        },
                        child: ScheduleSummeryCard()),
                  ),
                ],
              ),
              AppSpacing.addHeight(21),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Get.toNamed(Routes.BUDGET);
                      },
                      child: BudgetSummeryCard(),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Get.toNamed(Routes.CASHFLOW);
                      },
                      child: CashFlowSummeryCard(),
                    ),
                  ),
                ],
              ),
              AppSpacing.addHeight(21),
              SummaryListSection(
                title: "Transactions",
                listTile: Obx(() {
                  final transactions =
                      controller.statsModel.value?.body.transactions ?? [];

                  if (transactions.isEmpty) {
                    return Empty(
                      title: "You don't have any transactions yet",
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    separatorBuilder: (_, __) =>
                        AppDivider(),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];

                      return TransactionTile(
                        title: transaction.title,
                        amount: transaction.amount,
                        date: transaction.date,
                        leading: AppImageAvatar(
                          fallbackAsset: ImagePaths.bank_icon,
                          avatarUrl: transaction.logoUrl,
                          isCircular: true,
                          radius: 20,
                        ),
                      );
                    },
                  );
                }),
                showViewAll: true,
                emptyMessage: "You don't have any transactions yet",
                onViewAll: () {
                  Get.toNamed(Routes.TRANSACTIONS);
                },
              ),
              AppSpacing.addHeight(21),
            ],
          ),
        ),
      ),
    );
  }
}