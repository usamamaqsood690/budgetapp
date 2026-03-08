// lib/presentation/modules/investment/page/investment_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/investment/controller/investment_controller.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/tabbar/custom_tab_bar.dart';
import 'package:wealthnxai/presentation/widgets/toggle_button/toggle_button.dart';

import 'overview_tab.dart';


class InvestmentPage extends StatelessWidget {
  InvestmentPage({super.key});

  final InvestmentController _controller = Get.find<InvestmentController>();
  //final connectivityController = Get.find<CheckPlaidConnectionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'Investments',
        automaticallyImplyLeading: true,
        actions: [
          //  if (connectivityController.isConnected.value == false) ...[
          ConnectAccountToggle(),
          // ] else ...[
          //   Container(
          //     margin: const EdgeInsets.only(right: 16),
          //     child: GestureDetector(
          //       onTap: () => Get.to(() => InvestmentSearch()),
          //       child: const Icon(Icons.search),
          //     ),
          //   ),
          // ],
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabBar(),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
      child: Obx(() => CustomTabBar(
        tabs: _controller.tabs,
        selectedTab: _controller.selectedTab.value,
        onTabChanged: _controller.selectTab,
      )),
    );
  }

  Widget _buildTabContent() {
    return Obx(() {
      switch (_controller.selectedTab.value) {
        case 'Overview':
          return OverviewTab();
        case 'Crypto':
          return SizedBox();
            //CryptoTab();
        case 'Stocks':
          return SizedBox();
            //StocksTab();
        default:
          return SizedBox();
      }
    });
  }
}