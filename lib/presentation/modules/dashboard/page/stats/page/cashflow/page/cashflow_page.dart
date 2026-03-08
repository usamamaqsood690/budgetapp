import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/controller/cashflow_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/page/expense_tab/expense_tab.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/page/income_tab/income_tab.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/page/overview_tab/overview_tab.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/tabbar/custom_tab_bar.dart';

class CashFlowPage extends GetView<CashFlowController> {
  const CashFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Cash Flow"),
      body: Column(
        children: [
          Obx(() {
            final tabs = CashFlowTab.values;
            final selected = controller.selectedTab.value;
            return CustomTabBar(
              tabs: tabs.map(controller.getTabTitle).toList(),
              selectedTab: controller.getTabTitle(selected),
              onTabChanged: (label) {
                final tab = tabs.firstWhere(
                  (t) => controller.getTabTitle(t) == label,
                  orElse: () => CashFlowTab.overview,
                );
                controller.selectTab(tab);
              },
              selectedColor: context.colorScheme.onSurface,
              unselectedColor: context.colorScheme.onTertiaryContainer,
              borderColor: context.colorScheme.outline,
            );
          }),
          AppSpacing.addHeight(AppSpacing.md),
          Expanded(
            child: Obx(() {
              final selectedTab = controller.selectedTab.value;
              Future<void> refreshFunction() {
                switch (selectedTab) {
                  case CashFlowTab.income:
                    return controller.refreshIncomeTab();
                  case CashFlowTab.expense:
                    return controller.refreshExpenseTab();
                  case CashFlowTab.overview:
                    return controller.refreshOverviewTab();
                }
              }

              return RefreshIndicator(
                onRefresh: refreshFunction,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Builder(
                    builder: (context) {
                      switch (selectedTab) {
                        case CashFlowTab.income:
                          return const IncomeTab();
                        case CashFlowTab.expense:
                          return const ExpenseTab();
                        case CashFlowTab.overview:
                          return const OverviewTab();
                      }
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
