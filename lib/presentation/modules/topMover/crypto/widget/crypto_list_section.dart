// lib/presentation/modules/home/widget/crypto_list_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/controller/crypto_list_controller.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_list_shimmer.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/top_mover_list.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_empty.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class CryptoListSection extends StatelessWidget {
  final int itemLimit;

  CryptoListSection({super.key, this.itemLimit = 3});

  final CryptoListController _controller = Get.find<CryptoListController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildContent()],
    );
  }

  Widget _buildContent() {
    return Obx(() {
      // ✅ Use isTopAllLoading — unaffected by ViewAll tab fetches
      if (_controller.isTopAllLoading.value && _controller.topAllCoins.isEmpty) {
        return TopMoverListShimmer();
      }

      if (_controller.topAllCoins.isEmpty) {
        return Center(child: SectionEmpty(title: 'Empty List'));
      }

      return _buildOverviewList();
    });
  }

  Widget _buildOverviewList() {
    final coins = _controller.overviewTrendingCoins;

    if (coins.isEmpty) {
      return Center(child: SectionEmpty(title: 'Empty List'));
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: coins.length,
      itemBuilder: (context, index) {
        final coin = coins[index];
        return TopMoverList(
          onTap: () => _navigateToDetail(coin),
          name: coin.name,
          image: coin.image,
          price: double.parse(coin.currentPrice.toString()),
          priceChange: coin.priceChangePercentage24h,
          symbol: coin.symbol,
          showBorder: index != coins.length - 1,
        );
      },
    );
  }

  void _navigateToDetail(CryptoCoinEntity coin) {
    Get.toNamed(Routes.CRYPTODETAIL, arguments: {
      'coinId': coin.id ?? '',
      'coinEntity': coin,
      'coinSymbol': coin.symbol,
    });
  }
}