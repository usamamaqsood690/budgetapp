import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/domain/entities/stock/stock_entity.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/controller/stock_list_controller.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_list_shimmer.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/top_mover_list.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_empty.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class StockListSection extends StatelessWidget {
  final int itemLimit;

  StockListSection({super.key, this.itemLimit = 3});

  final StockListController _controller = Get.find<StockListController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildContent()],
    );
  }

  Widget _buildContent() {
    return Obx(() {
      // Check trending list specifically
      if (_controller.isLoading.value && _controller.trendingStocks.isEmpty) {
        return TopMoverListShimmer();
      }

      if (_controller.trendingStocks.isEmpty) {
        return Center(child: SectionEmpty(title: 'No Trending Stocks'));
      }

      return _buildRegularList();
    });
  }

  Widget _buildRegularList() {
    // Call the new specific getter
    final stocks = _controller.getTrendingItems(limit: itemLimit);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return TopMoverList(
          onTap: () => _navigateToDetail(stock),
          name: stock.name,
          image: stock.imageUrl,
          price: double.parse(stock.price),
          priceChange: double.parse(stock.changePercentage),
          symbol: stock.symbol,
          showBorder: index != stocks.length - 1,
        );
      },
    );
  }

  void _navigateToDetail(StockEntity stock) {
    Get.toNamed(Routes.STOCKSDETAIL, arguments: {
      'symbol': stock.symbol,
    });
  }
}