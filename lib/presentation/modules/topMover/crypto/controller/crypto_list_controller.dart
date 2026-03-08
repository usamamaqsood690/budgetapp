
// lib/presentation/modules/crypto/controller/crypto_list_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/domain/datasources/remote/crypto/crypto_remote_datasource.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';
import 'package:wealthnxai/domain/usecases/crypto/fetch_crypto_list_usecase.dart';
import 'package:wealthnxai/domain/usecases/crypto/search_crypto_usecase.dart';

extension CryptoTabExt on CryptoTab {
  CryptoListType get listType {
    switch (this) {
      case CryptoTab.trending: return CryptoListType.trending;
      case CryptoTab.gainers:  return CryptoListType.gainers;
      case CryptoTab.losers:   return CryptoListType.losers;
      case CryptoTab.newCoins: return CryptoListType.newCoins;
      case CryptoTab.all:      return CryptoListType.all;
    }
  }

  String get label {
    switch (this) {
      case CryptoTab.trending: return 'Trending';
      case CryptoTab.gainers:  return 'Gainers';
      case CryptoTab.losers:   return 'Losers';
      case CryptoTab.newCoins: return 'New';
      case CryptoTab.all:      return 'All';
    }
  }
}

class CryptoListController extends GetxController {
  final FetchCryptoListUseCase _fetchCryptoListUseCase =
  Get.find<FetchCryptoListUseCase>();
  final SearchCryptoUseCase _searchCryptoUseCase =
  Get.find<SearchCryptoUseCase>();

  // ── Scroll ────────────────────────────────────────────────────────────────
  late ScrollController scrollController;
  late ScrollController viewAllScrollController;

  // ── Search ────────────────────────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // ── Lists ─────────────────────────────────────────────────────────────────
  final RxList<CryptoCoinEntity> coinList = <CryptoCoinEntity>[].obs;
  final RxList<CryptoCoinEntity> filteredCoins = <CryptoCoinEntity>[].obs;

  /// Fetched ONCE on init — top coins from listType=All for the home widget.
  /// Never cleared by tab switches or search.
  final RxList<CryptoCoinEntity> topAllCoins = <CryptoCoinEntity>[].obs;
  final RxBool isTopAllLoading = false.obs;

  // ── Loading ───────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxBool isTabLoading = false.obs;

  // ── Pagination ────────────────────────────────────────────────────────────
  final RxBool hasMoreData = true.obs;
  final RxInt currentPage = 1.obs;
  final int pageSize = 20;

  // ── Tab ───────────────────────────────────────────────────────────────────
  final Rx<CryptoTab> selectedTab = CryptoTab.trending.obs;

  // ── Error ─────────────────────────────────────────────────────────────────
  final RxString errorMessage = ''.obs;

  // ── Internal flags ────────────────────────────────────────────────────────
  /// Tracks whether the ViewAll screen has been opened at least once.
  /// Prevents re-fetching on hot reload / re-navigation if data exists.
  bool _viewAllInitialized = false;

  Worker? _searchWorker;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    viewAllScrollController = ScrollController();
    scrollController.addListener(_onScroll);
    viewAllScrollController.addListener(_onViewAllScroll);
    _setupSearchDebounce();

    // ✅ Only fetch top-3 home snapshot here — nothing else.
    _fetchTopAllOnce();
  }

  @override
  void onClose() {
    scrollController.dispose();
    viewAllScrollController.dispose();
    searchController.dispose();
    _searchWorker?.dispose();
    super.onClose();
  }

  // ── Top All snapshot (home widget) ────────────────────────────────────────

  /// Fetches top coins from listType=All once for the home overview widget.
  Future<void> _fetchTopAllOnce() async {
    if (topAllCoins.isNotEmpty) return; // Already loaded — skip
    try {
      isTopAllLoading.value = true;
      final result = await _fetchCryptoListUseCase(
        listType: CryptoListType.all,
        page: 1,
        limit: 10,
      );
      result.fold(
            (failure) => debugPrint('❌ _fetchTopAllOnce: ${failure.message}'),
            (coins) => topAllCoins.assignAll(coins),
      );
    } catch (e) {
      debugPrint('❌ Exception _fetchTopAllOnce: $e');
    } finally {
      isTopAllLoading.value = false;
    }
  }

  // ── ViewAll lazy init ─────────────────────────────────────────────────────

  /// Call this from [CryptoListScreen.initState] or its binding.
  /// Loads the default tab list only when the user navigates to the ViewAll screen.
  Future<void> initViewAll() async {
    if (_viewAllInitialized && coinList.isNotEmpty) return;
    _viewAllInitialized = true;
    selectedTab.value = CryptoTab.trending;
    await _resetAndFetch();
  }

  /// Resets ViewAll state when user leaves the screen so next visit is fresh.
  void disposeViewAll() {
    _viewAllInitialized = false;
    coinList.clear();
    filteredCoins.clear();
    currentPage.value = 1;
    hasMoreData.value = true;
    clearSearch();
  }

  // ── Search debounce ───────────────────────────────────────────────────────

  void _setupSearchDebounce() {
    _searchWorker = debounce(
      searchQuery,
          (_) => _resetAndFetch(),
      time: const Duration(milliseconds: 400),
    );
  }

  // ── Scroll ────────────────────────────────────────────────────────────────

  void _onScroll() => _checkAndLoadMore(scrollController);
  void _onViewAllScroll() => _checkAndLoadMore(viewAllScrollController);

  void _checkAndLoadMore(ScrollController sc) {
    if (!sc.hasClients) return;
    final nearEnd = sc.position.pixels >= sc.position.maxScrollExtent - 300;
    if (nearEnd && !isMoreLoading.value && hasMoreData.value) {
      fetchCoins();
    }
  }

  void scrollToTop() {
    for (final sc in [scrollController, viewAllScrollController]) {
      if (sc.hasClients) {
        sc.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }
  }

  // ── Tab ───────────────────────────────────────────────────────────────────

  void selectTab(CryptoTab tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
    clearSearch();
    _resetAndFetch();
  }

  Future<void> switchTabWithShimmer(CryptoTab tab) async {
    if (selectedTab.value == tab) return;
    isTabLoading.value = true;
    selectedTab.value = tab;
    clearSearch();
    await Future.delayed(const Duration(milliseconds: 200));
    await _resetAndFetch();
    isTabLoading.value = false;
  }

  String getTabTitle(CryptoTab tab) => tab.label;

  // ── Fetch ─────────────────────────────────────────────────────────────────

  Future<void> _resetAndFetch() async {
    currentPage.value = 1;
    hasMoreData.value = true;
    coinList.clear();
    filteredCoins.clear();
    await fetchCoins(isFirstLoad: true);
  }

  Future<void> fetchCoins({bool isFirstLoad = false}) async {
    try {
      if (isFirstLoad) {
        isLoading.value = true;
      } else {
        if (!hasMoreData.value || isMoreLoading.value) return;
        isMoreLoading.value = true;
      }
      errorMessage.value = '';

      final result = searchQuery.value.isNotEmpty
          ? await _searchCryptoUseCase(
        query: searchQuery.value,
        page: currentPage.value,
        limit: pageSize,
      )
          : await _fetchCryptoListUseCase(
        listType: selectedTab.value.listType,
        page: currentPage.value,
        limit: pageSize,
      );

      result.fold(
            (failure) {
          errorMessage.value = failure.message;
          debugPrint('❌ fetchCoins: ${failure.message}');
        },
            (coins) {
          if (isFirstLoad) {
            coinList.assignAll(coins);
          } else {
            coinList.addAll(coins);
          }
          filteredCoins.assignAll(coinList);
          hasMoreData.value = coins.length >= pageSize;
          if (hasMoreData.value) currentPage.value++;
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to load coins';
      debugPrint('❌ Exception fetchCoins: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  // ── Search ────────────────────────────────────────────────────────────────

  void onSearchChanged(String value) => searchQuery.value = value.trim();

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  // ── Refresh ───────────────────────────────────────────────────────────────

  Future<void> onRefresh() => _resetAndFetch();

  // ── Getters ───────────────────────────────────────────────────────────────

  /// Top 3 from All — used by home overview widget, unaffected by tabs/search
  List<CryptoCoinEntity> get overviewTrendingCoins =>
      topAllCoins.take(3).toList();

  /// Top 6 from All — used by home section widget
  List<CryptoCoinEntity> get homeTrendingCoins =>
      topAllCoins.take(6).toList();

  bool isInitialLoading() => isLoading.value && coinList.isEmpty;
  bool shouldShowLoadMore() => isMoreLoading.value || hasMoreData.value;
}