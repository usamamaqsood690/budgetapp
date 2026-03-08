/// News Controller - GetX State Management (Clean Architecture)
/// Located in: lib/presentation/modules/News/controller/news_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wealthnxai/domain/entities/news_entity/news_entity.dart';
import 'package:wealthnxai/domain/repositories/news_repository/news_repository.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class NewsController extends GetxController {
  // Use injected repository from binding
  final NewsRepository _newsRepository = Get.find<NewsRepository>();

  // ==================== Scroll Controllers ====================

  late ScrollController viewAllScrollController;
  late ScrollController trendingScrollController;
  late ScrollController recentStoriesScrollController;

  // ==================== Observable Variables ====================

  // Main news lists
  final RxList<NewsEntity> newsList = <NewsEntity>[].obs;
  final RxList<NewsEntity> pressStocksList = <NewsEntity>[].obs;
  final RxList<NewsEntity> pressCryptoList = <NewsEntity>[].obs;

  // Loading states - Initial loading
  final RxBool isLoading = false.obs;
  final RxBool isPressStocksLoading = false.obs;
  final RxBool isPressCryptoLoading = false.obs;
  final RxBool isTabLoading = false.obs;

  // Loading states - Load more (pagination)
  final RxBool isMoreLoading = false.obs;
  final RxBool isMorePressStocksLoading = false.obs;
  final RxBool isMorePressCryptoLoading = false.obs;

  // Pagination - Has more data
  final RxBool hasMoreData = true.obs;
  final RxBool hasMoreStocks = true.obs;
  final RxBool hasMoreCrypto = true.obs;

  // Pagination - Current pages
  final RxInt currentPage = 1.obs;
  final RxInt stocksPage = 1.obs;
  final RxInt cryptoPage = 1.obs;
  final int pageSize = 10;

  // Category selection
  final RxInt selectedCategoryIndex = 0.obs;

  // Error handling
  final RxString errorMessage = ''.obs;

  // ==================== Symbol News Variables ====================

  // Dedicated observables for stock detail symbol news
  // These are isolated from the News tab observables above
  final RxList<NewsEntity> symbolNewsList = <NewsEntity>[].obs;
  final RxBool isSymbolLoading = false.obs;
  final RxString symbolErrorMessage = ''.obs;

  // ==================== News Detail Variables ====================

  final Rx<NewsEntity?> selectedNews = Rx<NewsEntity?>(null);
  final RxString selectedNewsTag = ''.obs;
  final RxString selectedNewsRelativeTime = ''.obs;
  final RxBool isDescriptionExpanded = false.obs;

  // ==================== Getters ====================

  List<NewsEntity> get trending6 => newsList.take(6).toList();

  List<NewsEntity> get allMix6 {
    final stocks = pressStocksList.take(3).toList();
    final crypto = pressCryptoList.take(3).toList();
    return [...stocks, ...crypto];
  }

  // ==================== Lifecycle ====================

  @override
  void onInit() {
    super.onInit();
    _initScrollControllers();
    _initializeData();
  }

  @override
  void onClose() {
    _disposeScrollControllers();
    super.onClose();
  }

  // ==================== Scroll Controller Methods ====================

  void _initScrollControllers() {
    viewAllScrollController = ScrollController();
    trendingScrollController = ScrollController();
    recentStoriesScrollController = ScrollController();
    _addScrollListeners();
  }

  void _disposeScrollControllers() {
    viewAllScrollController.dispose();
    trendingScrollController.dispose();
    recentStoriesScrollController.dispose();
  }

  void _addScrollListeners() {
    trendingScrollController.addListener(handleTrendingPagination);
    recentStoriesScrollController.addListener(handleRecentStoriesPagination);
  }

  void scrollToTopViewAll() {
    if (viewAllScrollController.hasClients) {
      viewAllScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void scrollToTopTrending() {
    if (trendingScrollController.hasClients) {
      trendingScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void scrollToTopRecentStories() {
    if (recentStoriesScrollController.hasClients) {
      recentStoriesScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // ==================== Trending Page Methods ====================

  void initializeTrendingData() {
    if (newsList.isEmpty && !isLoading.value) {
      fetchPaginatedNews(isFirstLoad: true);
    }
  }

  void handleTrendingPagination() {
    if (!trendingScrollController.hasClients) return;

    final nearEnd = trendingScrollController.position.pixels >=
        trendingScrollController.position.maxScrollExtent - 300;

    if (nearEnd && !isMoreLoading.value && hasMoreData.value) {
      fetchPaginatedNews();
    }
  }

  // ==================== Recent Stories Page Methods ====================

  void initializeRecentStoriesData() {
    if (pressStocksList.isEmpty) {
      fetchPressRelease(type: 'stock', isFirstLoad: true);
    }
    if (pressCryptoList.isEmpty) {
      fetchPressRelease(type: 'crypto', isFirstLoad: true);
    }
  }

  void handleRecentStoriesPagination() {
    if (!recentStoriesScrollController.hasClients) return;

    final nearEnd = recentStoriesScrollController.position.pixels >=
        recentStoriesScrollController.position.maxScrollExtent - 300;
    if (!nearEnd) return;

    final idx = selectedCategoryIndex.value;

    if (idx == 1) {
      if (hasMoreStocks.value && !isMorePressStocksLoading.value) {
        fetchPressRelease(type: 'stock');
      }
    } else if (idx == 2) {
      if (hasMoreCrypto.value && !isMorePressCryptoLoading.value) {
        fetchPressRelease(type: 'crypto');
      }
    } else {
      final canStocks = hasMoreStocks.value && !isMorePressStocksLoading.value;
      final canCrypto = hasMoreCrypto.value && !isMorePressCryptoLoading.value;

      if (canStocks) fetchPressRelease(type: 'stock');
      if (canCrypto) fetchPressRelease(type: 'crypto');
    }
  }

  bool isRecentStoriesInitialLoading(int idx) {
    if (idx == 1) {
      return isPressStocksLoading.value && pressStocksList.isEmpty;
    } else if (idx == 2) {
      return isPressCryptoLoading.value && pressCryptoList.isEmpty;
    } else {
      return (isPressStocksLoading.value && pressStocksList.isEmpty) ||
          (isPressCryptoLoading.value && pressCryptoList.isEmpty);
    }
  }

  Future<void> onRecentStoriesRefresh(int idx) async {
    if (idx == 1) {
      await fetchPressRelease(type: 'stock', isFirstLoad: true);
    } else if (idx == 2) {
      await fetchPressRelease(type: 'crypto', isFirstLoad: true);
    } else {
      await fetchPressRelease(type: 'stock', isFirstLoad: true);
      await fetchPressRelease(type: 'crypto', isFirstLoad: true);
    }
  }

  bool shouldShowRecentStoriesLoader(int idx) {
    if (idx == 1) {
      return isMorePressStocksLoading.value || hasMoreStocks.value;
    } else if (idx == 2) {
      return isMorePressCryptoLoading.value || hasMoreCrypto.value;
    } else {
      return isMorePressStocksLoading.value ||
          hasMoreStocks.value ||
          isMorePressCryptoLoading.value ||
          hasMoreCrypto.value;
    }
  }

  List<NewsEntity> getRecentStoriesItems(int idx) {
    if (idx == 1) {
      return pressStocksList.toList();
    } else if (idx == 2) {
      return pressCryptoList.toList();
    } else {
      final merged = [...pressStocksList, ...pressCryptoList];

      merged.sort((a, b) {
        DateTime pa, pb;
        try {
          pa = DateTime.parse(a.publishedDate ?? '').toLocal();
        } catch (_) {
          pa = DateTime.fromMillisecondsSinceEpoch(0);
        }
        try {
          pb = DateTime.parse(b.publishedDate ?? '').toLocal();
        } catch (_) {
          pb = DateTime.fromMillisecondsSinceEpoch(0);
        }
        return pb.compareTo(pa);
      });

      return merged;
    }
  }

  // ==================== Data Initialization ====================

  Future<void> _initializeData() async {
    await fetchPaginatedNews(isFirstLoad: true);
    await fetchPressRelease(type: 'stock', isFirstLoad: true);
    await fetchPressRelease(type: 'crypto', isFirstLoad: true);
  }

  // ==================== API Methods ====================

  /// Fetch general/trending news with pagination
  Future<void> fetchPaginatedNews({bool isFirstLoad = false}) async {
    try {
      if (isFirstLoad) {
        isLoading.value = true;
        currentPage.value = 1;
        hasMoreData.value = true;
      } else {
        if (!hasMoreData.value || isMoreLoading.value) return;
        isMoreLoading.value = true;
      }

      errorMessage.value = '';

      final result = await _newsRepository.fetchGeneralNews(
        page: currentPage.value,
        limit: pageSize,
      );

      result.fold(
            (failure) {
          errorMessage.value = failure.message;
          debugPrint('❌ Error fetching news: ${failure.message}');
        },
            (news) {
          if (isFirstLoad) {
            newsList.assignAll(news);
          } else {
            newsList.addAll(news);
          }
          hasMoreData.value = news.length >= pageSize;
          currentPage.value++;
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to load news';
      debugPrint('❌ Exception fetching news: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  /// Fetch stock or crypto news with pagination
  /// [type] should be 'stock' or 'crypto'
  Future<void> fetchPressRelease({
    required String type,
    bool isFirstLoad = false,
  }) async {
    try {
      final isCrypto = type == 'crypto';

      if (isFirstLoad) {
        if (isCrypto) {
          isPressCryptoLoading.value = true;
          cryptoPage.value = 1;
          hasMoreCrypto.value = true;
        } else {
          isPressStocksLoading.value = true;
          stocksPage.value = 1;
          hasMoreStocks.value = true;
        }
      } else {
        if (isCrypto) {
          if (!hasMoreCrypto.value || isMorePressCryptoLoading.value) return;
          isMorePressCryptoLoading.value = true;
        } else {
          if (!hasMoreStocks.value || isMorePressStocksLoading.value) return;
          isMorePressStocksLoading.value = true;
        }
      }

      final page = isCrypto ? cryptoPage.value : stocksPage.value;

      final result = isCrypto
          ? await _newsRepository.fetchCryptoNews(
        page: page,
        limit: pageSize,
      )
          : await _newsRepository.fetchStockNews(
        page: page,
        limit: pageSize,
      );

      result.fold(
            (failure) {
          errorMessage.value = failure.message;
          debugPrint('❌ Error fetching $type news: ${failure.message}');
        },
            (news) {
          if (isCrypto) {
            if (isFirstLoad) {
              pressCryptoList.assignAll(news);
            } else {
              pressCryptoList.addAll(news);
            }
            hasMoreCrypto.value = news.length >= pageSize;
            cryptoPage.value++;
          } else {
            if (isFirstLoad) {
              pressStocksList.assignAll(news);
            } else {
              pressStocksList.addAll(news);
            }
            hasMoreStocks.value = news.length >= pageSize;
            stocksPage.value++;
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to load $type news';
      debugPrint('❌ Exception fetching $type news: $e');
    } finally {
      if (type == 'crypto') {
        isPressCryptoLoading.value = false;
        isMorePressCryptoLoading.value = false;
      } else {
        isPressStocksLoading.value = false;
        isMorePressStocksLoading.value = false;
      }
    }
  }

  /// Fetch news by specific symbol (e.g., AAPL, BTC)
  /// Uses dedicated symbolNewsList — does NOT affect News tab data
  Future<void> fetchNewsBySymbol({
    required String symbol,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      isSymbolLoading.value = true;      // ✅ isolated from isLoading
      symbolErrorMessage.value = '';     // ✅ isolated from errorMessage
      symbolNewsList.clear();            // ✅ clear previous symbol data

      final result = await _newsRepository.fetchNewsBySymbol(
        symbol: symbol,
        page: page,
        limit: limit,
      );

      result.fold(
            (failure) {
          symbolErrorMessage.value = failure.message;
          debugPrint('❌ Error fetching news for $symbol: ${failure.message}');
        },
            (news) {
          symbolNewsList.assignAll(news); // ✅ isolated from newsList
        },
      );
    } catch (e) {
      symbolErrorMessage.value = 'Failed to load news for $symbol';
      debugPrint('❌ Exception fetching news by symbol: $e');
    } finally {
      isSymbolLoading.value = false;     // ✅ isolated from isLoading
    }
  }

  // ==================== Category Methods ====================

  Future<void> selectCategory(int index) async {
    selectedCategoryIndex.value = index;

    switch (index) {
      case 0:
        if (pressStocksList.isEmpty) {
          await fetchPressRelease(type: 'stock', isFirstLoad: true);
        }
        if (pressCryptoList.isEmpty) {
          await fetchPressRelease(type: 'crypto', isFirstLoad: true);
        }
        break;
      case 1:
        if (pressStocksList.isEmpty) {
          await fetchPressRelease(type: 'stock', isFirstLoad: true);
        }
        break;
      case 2:
        if (pressCryptoList.isEmpty) {
          await fetchPressRelease(type: 'crypto', isFirstLoad: true);
        }
        break;
    }
  }

  Future<void> switchCategoryWithShimmer(int index) async {
    if (selectedCategoryIndex.value == index) return;

    isTabLoading.value = true;
    selectedCategoryIndex.value = index;

    await Future.delayed(const Duration(milliseconds: 300));

    switch (index) {
      case 0:
        if (pressStocksList.isEmpty) {
          await fetchPressRelease(type: 'stock', isFirstLoad: true);
        }
        if (pressCryptoList.isEmpty) {
          await fetchPressRelease(type: 'crypto', isFirstLoad: true);
        }
        break;
      case 1:
        if (pressStocksList.isEmpty) {
          await fetchPressRelease(type: 'stock', isFirstLoad: true);
        }
        break;
      case 2:
        if (pressCryptoList.isEmpty) {
          await fetchPressRelease(type: 'crypto', isFirstLoad: true);
        }
        break;
    }

    isTabLoading.value = false;
  }

  // ==================== Loading State Helpers ====================

  bool isInitialLoading(int idx) {
    if (idx == 0) {
      return isLoading.value && newsList.isEmpty;
    } else if (idx == 1) {
      return isPressStocksLoading.value && pressStocksList.isEmpty;
    } else {
      return isPressCryptoLoading.value && pressCryptoList.isEmpty;
    }
  }

  Future<void> onRefresh(int idx) async {
    if (idx == 0) {
      await fetchPaginatedNews(isFirstLoad: true);
      await selectCategory(0);
    } else if (idx == 1) {
      await fetchPressRelease(type: 'stock', isFirstLoad: true);
    } else {
      await fetchPressRelease(type: 'crypto', isFirstLoad: true);
    }
  }

  List<NewsEntity> getItemsForCurrentTab() {
    final tab = selectedCategoryIndex.value;
    if (tab == 1) {
      return pressStocksList.take(6).toList();
    } else if (tab == 2) {
      return pressCryptoList.take(6).toList();
    } else {
      return allMix6;
    }
  }

  // ==================== Utility Methods ====================

  String formatRelativeTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else if (difference.inDays < 30) {
        return '${(difference.inDays / 7).floor()}w ago';
      } else if (difference.inDays < 365) {
        return '${(difference.inDays / 30).floor()}mo ago';
      } else {
        return '${(difference.inDays / 365).floor()}y ago';
      }
    } catch (e) {
      return '';
    }
  }

  Future<void> refreshAllNews() async {
    await fetchPaginatedNews(isFirstLoad: true);
    await fetchPressRelease(type: 'stock', isFirstLoad: true);
    await fetchPressRelease(type: 'crypto', isFirstLoad: true);
  }

  void clearAllData() {
    newsList.clear();
    pressStocksList.clear();
    pressCryptoList.clear();
    currentPage.value = 1;
    stocksPage.value = 1;
    cryptoPage.value = 1;
    hasMoreData.value = true;
    hasMoreStocks.value = true;
    hasMoreCrypto.value = true;
    errorMessage.value = '';
  }

  /// Clear symbol-specific news data
  void clearSymbolNews() {
    symbolNewsList.clear();
    symbolErrorMessage.value = '';
    isSymbolLoading.value = false;
  }

  // ==================== News Detail Methods ====================

  void navigateToNewsDetail(NewsEntity news, {String? tag}) {
    selectedNews.value = news;
    selectedNewsTag.value = tag ?? '';
    selectedNewsRelativeTime.value = formatRelativeTime(news.publishedDate);
    isDescriptionExpanded.value = false;

    Get.toNamed(Routes.NEWS_DETAIL);
  }

  void toggleDescriptionExpanded() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  String formatDateWithRelative(String? rawDate, String relativeText) {
    if (rawDate == null || rawDate.isEmpty) {
      return relativeText.isNotEmpty ? relativeText : '';
    }

    try {
      final d = DateTime.parse(rawDate).toLocal();
      final formattedDate = "${d.month}-${d.day}-${d.year}";
      if (relativeText.isNotEmpty) {
        return "$formattedDate • $relativeText";
      }
      return formattedDate;
    } catch (_) {
      return relativeText.isNotEmpty ? relativeText : rawDate;
    }
  }

  void clearSelectedNews() {
    selectedNews.value = null;
    selectedNewsTag.value = '';
    selectedNewsRelativeTime.value = '';
    isDescriptionExpanded.value = false;
  }
}