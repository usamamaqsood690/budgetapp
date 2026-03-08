// lib/presentation/modules/crypto/page/crypto_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/controller/crypto_list_controller.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/widget/crypto_tab_bar.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_list_shimmer.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_empty.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/top_mover_list.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  final CryptoListController _controller = Get.find<CryptoListController>();

  @override
  void initState() {
    super.initState();
    // ✅ Trigger ViewAll data load only when this screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initViewAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: "Crypto Today's List",
        onBackPressed: _onBack,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildSearchBar(),
            CryptoTabBar(controller: _controller),
            const SizedBox(height: 12),
            Expanded(child: _buildContent()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _onBack() {
    _controller.clearSearch();
    // ✅ Reset ViewAll state so next open always fetches fresh
    _controller.disposeViewAll();
    Get.back();
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: AppSpacing.paddingVertical(AppSpacing.spacing8),
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
            borderSide:
            const BorderSide(color: Color.fromRGBO(46, 173, 165, 1)),
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          prefixIconConstraints:
          const BoxConstraints(minWidth: 40, minHeight: 40),
          suffixIcon: Obx(() => _controller.searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
            onPressed: () {
              _controller.clearSearch();
              _controller.onRefresh();
            },
          )
              : const SizedBox.shrink()),
        ),
      ),
    );
  }

  // ── Content ────────────────────────────────────────────────────────────────

  Widget _buildContent() {
    return Obx(() {
      if (_controller.isInitialLoading()) {
        return TopMoverListShimmer();
      }

      if (_controller.errorMessage.isNotEmpty && _controller.coinList.isEmpty) {
        return Center(child: SectionEmpty(title: 'Something went wrong'));
      }

      if (_controller.searchQuery.isNotEmpty &&
          _controller.filteredCoins.isEmpty &&
          !_controller.isLoading.value) {
        return Center(child: SectionEmpty(title: 'No results found'));
      }

      if (_controller.filteredCoins.isEmpty) {
        return Center(child: SectionEmpty(title: 'Empty List'));
      }

      return _buildCoinList();
    });
  }

  Widget _buildCoinList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 300) {
          if (!_controller.isMoreLoading.value && _controller.hasMoreData.value) {
            _controller.fetchCoins();
          }
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: _controller.onRefresh,
        color: const Color.fromRGBO(46, 173, 165, 1),
        child: ListView.builder(
          controller: _controller.viewAllScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _controller.filteredCoins.length +
              (_controller.shouldShowLoadMore() ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _controller.filteredCoins.length) {
              return TopMoverListShimmer();
            }
            final coin = _controller.filteredCoins[index];
            return TopMoverList(
              name: coin.name,
              symbol: coin.symbol,
              image: coin.image,
              price: double.parse(coin.currentPrice.toString()),
              priceChange: coin.priceChangePercentage24h,
              onTap: () => _navigateToDetail(coin),
            );
          },
        ),
      ),
    );
  }

  void _navigateToDetail(CryptoCoinEntity coin) {
    Get.toNamed(
      Routes.CRYPTODETAIL,
      arguments: {
        'coinId': coin.id ?? '',
        'coinEntity': coin,
        'coinSymbol': coin.symbol,
      },
    );
  }
}