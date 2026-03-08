import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/domain/entities/stock/stock_entity.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/controller/stock_list_controller.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_tab_bar.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_list_shimmer.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_empty.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/top_mover_list.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class StockListScreen extends StatefulWidget {
  const StockListScreen({super.key});

  @override
  State<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  final StockListController _controller = Get.find<StockListController>();

  @override
  void initState() {
    super.initState();
    // ✅ Load ViewAll data only when this screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initViewAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: "Stock Today's List",
        onBackPressed: _onBack,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildSearchBar(),
            StockTabBar(controller: _controller),
            Expanded(child: _buildContent()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _onBack() {
    _controller.disposeViewAll();
    Get.back();
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AppTextField(
        controller: _controller.searchController,
        onChanged: _controller.onSearchChanged,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(bottom: 5),
          hintText: 'Search',
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromRGBO(46, 173, 165, 1)),
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          suffixIcon: Obx(() => _controller.searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
            onPressed: _controller.clearSearch,
          )
              : const SizedBox.shrink()),
        ),
      ),
    );
  }

  // ── Content ────────────────────────────────────────────────────────────────

  Widget _buildContent() {
    return Obx(() {
      if (_controller.isTabLoading.value || _controller.isInitialLoading()) {
        return TopMoverListShimmer();
      }

      if (_controller.errorMessage.isNotEmpty && _controller.stockList.isEmpty) {
        return _buildEmptyState('Something went wrong');
      }

      if (_controller.filteredStocks.isEmpty) {
        return _buildEmptyState(
          _controller.searchQuery.isNotEmpty ? 'No results found' : 'Empty List',
        );
      }

      return _buildStockList();
    });
  }

  Widget _buildEmptyState(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SectionEmpty(title: title),
          if (_controller.searchQuery.isNotEmpty)
            TextButton(
              onPressed: _controller.clearSearch,
              child: const Text('Clear search',
                  style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
    );
  }

  Widget _buildStockList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 300) {
          if (!_controller.isMoreLoading.value &&
              _controller.hasMoreData.value &&
              _controller.searchQuery.isEmpty) {
            _controller.fetchStocks(isLoadMore: true);
          }
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: _controller.onRefresh,
        color: const Color.fromRGBO(46, 173, 165, 1),
        backgroundColor: Colors.black,
        child: ListView.builder(
          controller: _controller.viewAllScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _controller.filteredStocks.length +
              (_controller.shouldShowLoadMore() &&
                  _controller.searchQuery.isEmpty
                  ? 1
                  : 0),
          itemBuilder: (context, index) {
            if (index >= _controller.filteredStocks.length) {
              return TopMoverListShimmer();
            }
            final stock = _controller.filteredStocks[index];
            return TopMoverList(
              onTap: () => _navigateToDetail(stock),
              name: stock.name,
              image: stock.imageUrl,
              price: double.parse(stock.price),
              priceChange: double.parse(stock.changePercentage),
              symbol: stock.symbol,
              showBorder: index != _controller.filteredStocks.length - 1,
            );
          },
        ),
      ),
    );
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _navigateToDetail(StockEntity stock) {
    Get.toNamed(Routes.STOCKSDETAIL, arguments: {'symbol': stock.symbol});
  }
}