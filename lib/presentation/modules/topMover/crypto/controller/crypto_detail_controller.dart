
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_chart_plus_deeping/entity/k_line_entity.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_chart_entity.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';
import 'package:wealthnxai/domain/usecases/crypto/fetch_crypto_chart_usecase.dart';
import 'package:wealthnxai/domain/usecases/crypto/fetch_crypto_profile_usecase.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_chart_interface.dart';

// ✅ ChartMode enum removed — now lives in topmover_chart_interface.dart

class CryptoDetailController extends GetxController implements TopMoverChartInterface {
  final FetchCryptoProfileUseCase _fetchCryptoProfileUseCase =
  Get.find<FetchCryptoProfileUseCase>();
  final FetchCryptoChartUseCase _fetchCryptoChartUseCase =
  Get.find<FetchCryptoChartUseCase>();

  // ── Coin detail ───────────────────────────────────────────────────────────
  final Rx<CryptoCoinEntity?> coinDetail = Rx<CryptoCoinEntity?>(null);
  final RxBool isDetailLoading = false.obs;
  final RxBool isMarketStatsExpanded = false.obs;
  final Rxn<KLineEntity> selectedCandle = Rxn<KLineEntity>();
  final RxDouble currentPrice = 0.0.obs;

  // ── TopMoverChartInterface ────────────────────────────────────────────────
  @override
  final RxList<KLineEntity> chartData = <KLineEntity>[].obs;

  @override
  final RxBool isChartLoading = false.obs;

  @override
  final RxBool isChartFit = true.obs;

  @override
  final Rx<ChartMode> chartMode = ChartMode.line.obs;

  @override
  final RxString selectedRange = '1 D'.obs;

  @override
  final RxString errorMessage = ''.obs;

  @override
  List<String> get chartDateFormat {
    switch (selectedRange.value) {
      case '1 D':
        return ['HH', ':', 'mm'];
      case '7 D':
      case '1 M':
        return ['dd', ' ', 'M'];
      case '6 M':
      case '1 Y':
        return ['M', ' ', 'yyyy'];
      case 'YTD':
        return ['yyyy'];
      default:
        return ['dd', ' ', 'M'];
    }
  }

  @override
  void setRange(String label) {
    selectedRange.value = label;
    clearSelection();
    fetchChartData(days: _rangeToDays[label] ?? '1');
  }

  @override
  void setMode(ChartMode mode) => chartMode.value = mode;

  // ─────────────────────────────────────────────────────────────────────────

  String _coinId = '';
  Timer? _refreshTimer;

  static const Map<String, String> _rangeToDays = {
    '1 D': '1',
    '7 D': '7',
    '1 M': '30',
    '6 M': '180',
    '1 Y': '365',
    'YTD': 'max',
  };

  // ── Init ──────────────────────────────────────────────────────────────────

  Future<void> init({
    required String coinId,
    CryptoCoinEntity? prefetchedCoin,
  }) async {
    _coinId = coinId;
    if (prefetchedCoin != null) coinDetail.value = prefetchedCoin;

    await Future.wait([
      fetchCryptoProfile(coinId: coinId),
      fetchChartData(days: '1'),
    ]);

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 20),
          (_) => fetchChartData(days: _rangeToDays[selectedRange.value] ?? '1'),
    );
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  // ── Profile ───────────────────────────────────────────────────────────────

  Future<void> fetchCryptoProfile({required String coinId}) async {
    try {
      if (coinDetail.value == null) isDetailLoading.value = true;
      errorMessage.value = '';
      final result = await _fetchCryptoProfileUseCase(coinId: coinId);
      result.fold(
            (failure) => errorMessage.value = failure.message,
            (coin) => coinDetail.value = coin,
      );
    } catch (e) {
      errorMessage.value = 'Failed to load coin details';
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> refreshProfile() => fetchCryptoProfile(coinId: _coinId);

  // ── Chart ─────────────────────────────────────────────────────────────────

  Future<void> fetchChartData({required String days}) async {
    if (_coinId.isEmpty) return;
    try {
      isChartLoading.value = true;
      final result = await _fetchCryptoChartUseCase(
        coinId: _coinId,
        days: days,
      );
      result.fold(
            (failure) => debugPrint('❌ chart: ${failure.message}'),
            (entities) => chartData.value = _toKLine(entities),
      );
    } catch (e) {
      debugPrint('❌ fetchChartData: $e');
    } finally {
      isChartLoading.value = false;
    }
  }

  List<KLineEntity> _toKLine(List<CryptoChartEntity> entities) {
    return entities
        .map((e) => KLineEntity.fromCustom(
      time: e.time,
      open: e.open,
      high: e.high,
      low: e.low,
      close: e.close,
      vol: 0,
    ))
        .toList()
      ..sort((a, b) => (a.time ?? 0).compareTo(b.time ?? 0));
  }

  // ── Chart interactions ────────────────────────────────────────────────────

  void selectCandle(KLineEntity candle) {
    selectedCandle.value = candle;
    currentPrice.value = candle.close ?? 0.0;
  }

  void clearSelection() {
    selectedCandle.value = null;
    currentPrice.value = 0.0;
  }
}