import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/domain/entities/stock/stock_entity.dart';
import 'package:wealthnxai/domain/usecases/stock/get_stock_list_usecase.dart';
import 'package:wealthnxai/domain/usecases/stock/stock_list_params.dart';

class StockListController extends GetxController {
  final GetStockListUseCase getStockListUseCase;

  StockListController({required this.getStockListUseCase});

  // ── State ─────────────────────────────────────────────────────────────────
  final stockList = <StockEntity>[].obs;
  final filteredStocks = <StockEntity>[].obs;
  final trendingStocks = <StockEntity>[].obs;

  final isLoading = false.obs;
  final isTabLoading = false.obs;
  final isMoreLoading = false.obs;
  final isTrendingLoading = false.obs;
  final hasMoreData = true.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final selectedTab = StockTab.all.obs;

  // ── Controllers ───────────────────────────────────────────────────────────
  final searchController = TextEditingController();
  final viewAllScrollController = ScrollController();

  // ── Pagination ────────────────────────────────────────────────────────────
  int _currentPage = 1;
  static const int _pageLimit = 20;

  // ── Internal flags ────────────────────────────────────────────────────────
  bool _viewAllInitialized = false;

  Timer? _debounceTimer;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    // ✅ Only fetch top-3 home snapshot here — nothing else
    fetchTrendingOverview();
  }

  @override
  void onClose() {
    searchController.dispose();
    viewAllScrollController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  // ── ViewAll lazy init ─────────────────────────────────────────────────────

  /// Call from StockListScreen.initState — loads the list only when screen opens
  Future<void> initViewAll() async {
    if (_viewAllInitialized && stockList.isNotEmpty) return;
    _viewAllInitialized = true;
    selectedTab.value = StockTab.all;
    _resetPagination();
    await fetchStocks();
  }

  /// Call on back press — resets so next open is always fresh
  void disposeViewAll() {
    _viewAllInitialized = false;
    stockList.clear();
    filteredStocks.clear();
    _currentPage = 1;
    hasMoreData.value = true;
    clearSearch();
  }

  // ── Trending overview (home widget) ───────────────────────────────────────

  Future<void> fetchTrendingOverview() async {
    if (trendingStocks.isNotEmpty) return; // Already loaded — skip
    try {
      isTrendingLoading.value = true;
      final params = StockListParams(listType: 'All', page: 1, limit: 3);
      final result = await getStockListUseCase(params);
      result.fold(
            (failure) => errorMessage.value = failure.message,
            (stocks) => trendingStocks.assignAll(stocks),
      );
    } finally {
      isTrendingLoading.value = false;
    }
  }

  // ── Tab ───────────────────────────────────────────────────────────────────

  String getTabTitle(StockTab tab) {
    switch (tab) {
      case StockTab.all:      return 'All';
      case StockTab.trending: return 'Trending';
      case StockTab.gainers:  return 'Gainers';
      case StockTab.losers:   return 'Losers';
    }
  }

  String _getListType(StockTab tab) {
    switch (tab) {
      case StockTab.all:      return 'All';
      case StockTab.trending: return 'Trending';
      case StockTab.gainers:  return 'Gainers';
      case StockTab.losers:   return 'Losers';
    }
  }

  void selectTab(StockTab tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
    isTabLoading.value = true;
    _resetPagination();
    fetchStocks();
  }

  // ── Fetch ─────────────────────────────────────────────────────────────────

  Future<void> fetchStocks({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (isMoreLoading.value || !hasMoreData.value) return;
      isMoreLoading.value = true;
    } else {
      if (!isTabLoading.value) isLoading.value = true;
    }

    errorMessage.value = '';

    final params = StockListParams(
      listType: _getListType(selectedTab.value),
      search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      page: _currentPage,
      limit: _pageLimit,
    );

    final result = await getStockListUseCase(params);

    result.fold(
          (failure) => errorMessage.value = failure.message,
          (newStocks) {
        if (isLoadMore) {
          stockList.addAll(newStocks);
        } else {
          stockList.assignAll(newStocks);
        }
        hasMoreData.value = newStocks.length == _pageLimit;
        if (newStocks.isNotEmpty) _currentPage++;
        _applyFilter();
      },
    );

    isLoading.value = false;
    isTabLoading.value = false;
    isMoreLoading.value = false;
  }

  // ── Search ────────────────────────────────────────────────────────────────

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _debounceTimer?.cancel();
    if (query.isEmpty) {
      _resetPagination();
      fetchStocks();
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _resetPagination();
      fetchStocks();
    });
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _resetPagination();
    fetchStocks();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _applyFilter() => filteredStocks.assignAll(stockList);

  void _resetPagination() {
    _currentPage = 1;
    hasMoreData.value = true;
    stockList.clear();
    filteredStocks.clear();
  }

  bool isInitialLoading() => isLoading.value && stockList.isEmpty;
  bool shouldShowLoadMore() => isMoreLoading.value || hasMoreData.value;

  List<StockEntity> getTrendingItems({int limit = 3}) =>
      trendingStocks.take(limit).toList();

  // ── Refresh ───────────────────────────────────────────────────────────────

  Future<void> onRefresh() async {
    _resetPagination();
    await fetchStocks();
  }
}