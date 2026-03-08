// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:k_chart_plus_deeping/entity/k_line_entity.dart';
// import 'package:k_chart_plus_deeping/k_chart_widget.dart';
// import 'package:wealthnxai/core/constants/app_images_path.dart';
// import 'package:wealthnxai/core/themes/app_spacing.dart';
// import 'package:wealthnxai/presentation/modules/topMover/stock/controller/stock_detail_controller.dart';
// import 'package:wealthnxai/presentation/modules/topMover/stock/widget/candle_page.dart';
// import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_detail_widget/stock_about_section.dart';
// import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_detail_widget/stock_chart_tab.dart';
// import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_detail_widget/stock_detail_top_section.dart';
// import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_detail_widget/stock_market_stats_section.dart';
// import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_detail_widget/stock_position_section.dart';
// import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_appbar.dart';
// import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_chart_interface.dart';
// import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_chart_view.dart';
// import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_detail_shimmer.dart';
// import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_new_section.dart';
// import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
//
//
// class StockDetailNewScreen extends StatelessWidget   {
//   StockDetailNewScreen({
//     Key? key,
//
//   }) : super(key: key);
//
//   // // ── TopMoverChartInterface ───────────────────────────────────────────────
//   //
//   // @override
//   // final RxBool isChartLoading = false.obs;
//   //
//   // @override
//   // final RxBool isChartFit = true.obs;
//   //
//   // @override
//   // final RxString selectedRange = '1 D'.obs;
//   //
//   // @override
//   // final Rx<ChartMode> chartMode = ChartMode.line.obs;
//   //
//   // @override
//   // final RxString errorMessage = ''.obs;
//   //
//   // @override
//   // List<KLineEntity> get chartData => chartData; // your internal chart list
//   //
//   // @override
//   // List<String> get chartDateFormat => TimeFormat.yearMONTHDAY; // or your format
//   //
//   // @override
//   // void setRange(String range) {
//   //   selectedRange.value = range;
//   //   fetchChartData(); // your existing fetch method
//   // }
//   //
//   // @override
//   // void setMode(ChartMode mode) {
//   //   chartMode.value = mode;
//   // }
//   @override
//   Widget build(BuildContext context) {
//     final args = Get.arguments as Map<String, dynamic>? ?? {};
//     final String symbol = args['symbol'] ?? '';
//     final String? typePortfolio = args['typePortfolio'];
//     final Map<String, String>? assetPosition = args['assetPosition'];
//     // final controller = Get.put(
//     //   StockDetailController(
//     //     getStockDetailUseCase: Get.find(),
//     //     getStockGraphUseCase: Get.find(),
//     //     symbol: symbol,
//     //   ),
//     // );
//     final controller = Get.find<StockDetailController>();
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(kToolbarHeight),
//         child: Obx(() {
//           final detail = controller.stockDetail.value;
//           return TopMoverAppBar(
//             title: detail?.name ?? symbol,
//             symbol: symbol,
//             imageUrl: detail?.image,
//             onBackPressed: () {
//               controller.isMarketStatsExpanded.value = false;
//               Get.back();
//             },
//           );
//         }),
//       ),
//       body: Obx(() {
//         // ── Loading ──────────────────────────────────────────────────────
//         if (controller.isDetailLoading.value &&
//             controller.stockDetail.value == null) {
//           return const TopMoverDetailShimmer();
//         }
//
//         // ── Error ────────────────────────────────────────────────────────
//         if (controller.errorMessage.isNotEmpty &&
//             controller.stockDetail.value == null) {
//           return const Center(
//             child: AppText(
//               txt: 'No Market Data Available',
//               style: TextStyle(color: Colors.white),
//             ),
//           );
//         }
//
//         // ── Content ──────────────────────────────────────────────────────
//         final detail = controller.stockDetail.value;
//
//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   children: [
//                     // Top: price + change + 4 stats
//                     StockDetailTopSection(detail: detail),
//                     AppSpacing.addHeight(20),
//
//                     // Chart
//                     // SizedBox(
//                     //   height: 300,
//                     //   child: TopMoverChartView(
//                     //     controller: controller,
//                     //   ),
//                     // ),
//                     SizedBox(
//                       height: 300,
//                       child: Obx(() {
//                         final isLine =
//                             controller.chartMode.value == ChartMode.line;
//                         return CandlePage(isLine: isLine);
//                       }),
//                     ),
//                     AppSpacing.addHeight(13),
//
//                     // Time range + mode tabs
//                     StockChartTabs(controller: controller),
//                     AppSpacing.addHeight(30),
//
//                     // Portfolio position (optional)
//                     if (typePortfolio == 'portfolio' &&
//                         assetPosition != null) ...[
//                       StockPositionSection(assetPosition: assetPosition!),
//                       AppSpacing.addHeight(30),
//                     ],
//
//                     // Market stats
//                     StockMarketStatsSection(
//                       detail: detail,
//                       controller: controller,
//                     ),
//                     AppSpacing.addHeight(21),
//                   ],
//                 ),
//               ),
//
//               // Wealth Genie Banner
//               GestureDetector(
//                 onTap: () => Get.back(),
//                 child: Image.asset(
//                   ImagePaths.cryptodetl,
//                   width: double.infinity,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   children: [
//                     AppSpacing.addHeight(21),
//
//                     // About
//                     StockAboutSection(detail: detail),
//                     AppSpacing.addHeight(21),
//                     // New Section
//                     TopMoverNewsSection(symbol: symbol),
//
//                     AppSpacing.addHeight(60),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/controller/stock_detail_controller.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_detail_widget/stock_about_section.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_detail_widget/stock_chart_tab.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_detail_widget/stock_detail_top_section.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_detail_widget/stock_market_stats_section.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_detail_widget/stock_position_section.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_appbar.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_chart_view.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_detail_shimmer.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_new_section.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class StockDetailNewScreen extends StatelessWidget {
  const StockDetailNewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String symbol = args['symbol'] ?? '';
    final String? typePortfolio = args['typePortfolio'];
    final Map<String, String>? assetPosition = args['assetPosition'];

    // ✅ Controller registered via StockBinding — just find it here
    final controller = Get.find<StockDetailController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final detail = controller.stockDetail.value;
          return TopMoverAppBar(
            title: detail?.name ?? symbol,
            symbol: symbol,
            imageUrl: detail?.image,
            onBackPressed: () {
              controller.isMarketStatsExpanded.value = false;
              Get.back();
            },
          );
        }),
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────────────────────────────
        if (controller.isDetailLoading.value &&
            controller.stockDetail.value == null) {
          return const TopMoverDetailShimmer();
        }

        // ── Error ────────────────────────────────────────────────────────
        if (controller.errorMessage.isNotEmpty &&
            controller.stockDetail.value == null) {
          return const Center(
            child: AppText(
              txt: 'No Market Data Available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // ── Content ──────────────────────────────────────────────────────
        final detail = controller.stockDetail.value;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Top: price + change + 4 stats
                    StockDetailTopSection(detail: detail),
                    AppSpacing.addHeight(20),

                    // ✅ Chart — using TopMoverChartView with controller
                    SizedBox(
                      height: 300,
                      child: TopMoverChartView(
                        controller: controller,
                      ),
                    ),
                    AppSpacing.addHeight(13),

                    // Time range + mode tabs
                    StockChartTabs(controller: controller),
                    AppSpacing.addHeight(30),

                    // Portfolio position (optional)
                    if (typePortfolio == 'portfolio' &&
                        assetPosition != null) ...[
                      StockPositionSection(assetPosition: assetPosition!),
                      AppSpacing.addHeight(30),
                    ],

                    // Market stats
                    StockMarketStatsSection(
                      detail: detail,
                      controller: controller,
                    ),
                    AppSpacing.addHeight(21),
                  ],
                ),
              ),

              // Wealth Genie Banner
              GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  ImagePaths.cryptodetl,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    AppSpacing.addHeight(21),

                    // About
                    StockAboutSection(detail: detail),
                    AppSpacing.addHeight(21),

                    // News Section
                    TopMoverNewsSection(symbol: symbol),
                    AppSpacing.addHeight(60),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}