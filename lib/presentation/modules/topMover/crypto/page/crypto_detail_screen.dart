// lib/presentation/modules/crypto/page/crypto_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/controller/crypto_detail_controller.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/widget/crypto_chart_view.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/widget/crypto_detail_widget.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_appbar.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_chart_view.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_detail_shimmer.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_new_section.dart';

class CryptoDetailScreen extends StatelessWidget  {
  const CryptoDetailScreen({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String coinId = args['coinId'] ?? '';
    final CryptoCoinEntity? coinEntity = args['coinEntity'];
    final String? coinSymbol = args['coinSymbol'];

    final controller = Get.find<CryptoDetailController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init(coinId: coinId.toString(), prefetchedCoin: coinEntity);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final coin = controller.coinDetail.value ?? coinEntity;
          return TopMoverAppBar(
            title: coin?.name,
            symbol: coin?.symbol,
            imageUrl: coin?.image,
            onBackPressed: () {
              controller.isMarketStatsExpanded.value = false;
              Get.back();
            },
          );
        }),
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────────────────────────────────
        if (controller.isDetailLoading.value &&
            controller.coinDetail.value == null) {
          return const TopMoverDetailShimmer();
        }

        // ── Error ────────────────────────────────────────────────────────────
        if (controller.errorMessage.isNotEmpty &&
            controller.coinDetail.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                AppSpacing.addHeight(12),
                const Text(
                  'No Market Data Available',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                AppSpacing.addHeight(16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EADA5),
                  ),
                  onPressed: controller.refreshProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // ── Content ──────────────────────────────────────────────────────────
        final detail = controller.coinDetail.value;

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          color: const Color(0xFF2EADA5),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Price + 4 stats ────────────────────────────────
                      CryptoDetailTopSection(detail: detail),
                      AppSpacing.addHeight(20),

                      // ── Chart ──────────────────────────────────────────


                      SizedBox(
                        height: 300,
                        child: TopMoverChartView(controller: controller),
                      ),
                      AppSpacing.addHeight(13),

                      // ── Range + mode tabs ──────────────────────────────
                      CryptoChartTabs(controller: controller),
                      AppSpacing.addHeight(30),

                      // ── Market Stats ───────────────────────────────────
                      CryptoMarketStatsSection(
                        detail: detail,
                        controller: controller,
                      ),
                      AppSpacing.addHeight(21),
                    ],
                  ),
                ),

                // ── Wealth Genie Banner ────────────────────────────────────
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    ImagePaths.cryptodetl,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacing.addHeight(21),

                      // ── About ──────────────────────────────────────────
                      CryptoAboutSection(description: detail?.description),
                      AppSpacing.addHeight(21),

                      // ── News ───────────────────────────────────────────
                      TopMoverNewsSection(symbol: coinSymbol.toString()),

                      AppSpacing.addHeight(60),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
