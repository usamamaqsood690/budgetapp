import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/net_worth/controller/networth_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/net_worth/page/assets_tab/assets_tab.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/net_worth/page/liabilities_tab/liabilities_tab.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/net_worth/page/overview_tab/overview_networth_tab.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/tabbar/custom_tab_bar.dart';

class NetWorthPage extends GetView<NetWorthController> {
  const NetWorthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Net Worth"),
      body: Column(
        children: [
          Obx(() {
            final tabs = NetWorthTab.values;
            final selected = controller.selectedTab.value;
            return CustomTabBar(
              tabs: tabs.map(controller.getTabTitle).toList(),
              selectedTab: controller.getTabTitle(selected),
              onTabChanged: (label) {
                final tab = tabs.firstWhere(
                      (t) => controller.getTabTitle(t) == label,
                  orElse: () => NetWorthTab.overview,
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
                  case NetWorthTab.overview:
                    return controller.refreshOverviewTab();
                  case NetWorthTab.assets:
                    return controller.refreshAssetsTab();
                  case NetWorthTab.liabilities:
                    return controller.refreshLiabilitiesTab();
                }
              }

              return RefreshIndicator(
                onRefresh: refreshFunction,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Builder(
                    builder: (context) {
                      switch (selectedTab) {
                        case NetWorthTab.assets:
                          return const AssetsTab();
                        case NetWorthTab.liabilities:
                          return const LiabilitiesTab();
                        case NetWorthTab.overview:
                          return const OverviewNetworthTab();
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
