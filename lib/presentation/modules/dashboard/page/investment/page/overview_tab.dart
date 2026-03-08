// lib/presentation/modules/investment/page/overview_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/news/page/news_section.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/page/crypto_list_screen.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/widget/crypto_list_section.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/page/stock_list_screen.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_list_section.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTotalInvestmentSection(),
            AppSpacing.addHeight(16),
            _buildTodayListSection(),
            AppSpacing.addHeight(16),
            NewsSection(),
          ],
        ),
      ),
    );
  }
  Widget buildChartSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 0.25),
      ),
      child: Column(
        children: [
         // buildSpendGraph(),
          AppSpacing.addHeight(16),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // _overviewController.buildTab('1 M'),
                // _overviewController.buildTab('3 M'),
                // _overviewController.buildTab('6 M'),
                // _overviewController.buildTab('1 Y'),
                // _overviewController.buildTab('YTD'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalInvestmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Investment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Obx(() {
            //   if (_overviewController.isLoading.value) {
            //     // Show shimmer effect while loading
            //     return Shimmer.fromColors(
            //       baseColor: Colors.black,
            //       highlightColor: Colors.grey[700]!,
            //       child: Container(
            //         height: 30,
            //         width: 120, // Adjust width as needed
            //         color: Colors.white,
            //       ),
            //     );
            //   } else {
            //     // Show the actual text when not loading
            //     return
            AppText(
              txt: "\$0.00",
              // (() {
              //   final rawValue =
              //       _overviewController.totalInvestment_overview;
              //   final double val =
              //       double.tryParse(rawValue.toString()) ?? 0.0;
              //   return val < 0
              //       ? '-\$${numberFormatPoint.format(val.abs())}'
              //       : '\$${numberFormatPoint.format(val)}';
              // })(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
            //   }
            // }),
            // Obx(
            //       () =>
            AppText(
              txt: '(1M)',
              //  ' (${_overviewController.selectedTab.value})',
              // '${_overviewController.chartResponse.value?.body.percentageChangeOverview.toStringAsFixed(2) ?? '0.00'}% (${_overviewController.selectedTab.value})',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodayListSection() {
    return Column(
      children: [
        SectionName(title: "Today's List", titleOnTap: '', onTap: () {}),
        const SizedBox(height: 16),
        SectionName(
          title: 'Crypto',
          titleOnTap: 'View All',
          fontSize: AppSpacing.responTextWidth(AppSpacing.spacing12),
          onTapColor: Color(0xFFD6D6D6),
          onTap: () => Get.to(() => CryptoListScreen()),
        ),
        const SizedBox(height: 16),
        CryptoListSection(),
        const SizedBox(height: 16),
        SectionName(
          title: 'Stocks',
          titleOnTap: 'View All',
          fontSize: AppSpacing.responTextWidth(AppSpacing.spacing12),
          onTapColor: Color(0xFFD6D6D6),
          onTap: () => Get.to(() => StockListScreen()),
        ),
        const SizedBox(height: 16),
        StockListSection(),
      ],
    );
  }
}
