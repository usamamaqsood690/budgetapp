import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_chart_plus_deeping/entity/k_line_entity.dart';
import 'package:k_chart_plus_deeping/k_chart_widget.dart';
import 'package:wealthnxai/domain/entities/stock/stock_detail_entity.dart';
import 'package:wealthnxai/domain/usecases/stock/get_stock_detail_usecase.dart';
import 'package:wealthnxai/domain/usecases/stock/get_stock_graph_usecase.dart';
import 'package:wealthnxai/domain/usecases/stock/stock_detail_params.dart';
import 'package:wealthnxai/domain/usecases/stock/stock_graph_params.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_chart_interface.dart';

import '../../../../../core/constants/app_enums.dart';

class StockDetailController extends GetxController implements TopMoverChartInterface {
  // ─── Dependencies ──────────────────────────────────────────────────────────
  final GetStockDetailUseCase getStockDetailUseCase;
  final GetStockGraphUseCase getStockGraphUseCase;

  StockDetailController({
    required this.getStockDetailUseCase,
    required this.getStockGraphUseCase,
    required String symbol,
  }) : _symbol = symbol;

  final String _symbol;

  // ─── State ─────────────────────────────────────────────────────────────────
  final isDetailLoading = true.obs;
  final isGraphLoading = false.obs;
  final stockDetail = Rx<StockDetailEntity?>(null);
  final isMarketStatsExpanded = false.obs;

  final selectedCandle = Rxn<KLineEntity>();

  Timer? _refreshTimer;

  // ─── TopMoverChartInterface ────────────────────────────────────────────────

  @override
  final RxList<KLineEntity> chartData = <KLineEntity>[].obs;

  @override
  final RxBool isChartLoading = false.obs;

  @override
  final RxBool isChartFit = true.obs;

  @override
  final RxString selectedRange = '1 D'.obs;

  @override
  final Rx<ChartMode> chartMode = ChartMode.line.obs;

  @override
  final RxString errorMessage = ''.obs;

  @override
  List<String> get chartDateFormat => TimeFormat.yearMONTHDAY;

  @override
  void setRange(String range) {
    if (selectedRange.value == range) return;
    selectedRange.value = range;
    fetchGraph();
  }

  @override
  void setMode(ChartMode mode) {
    chartMode.value = mode;
  }

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _initData();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 20),
          (_) => fetchGraph(),
    );
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  // ─── Init ──────────────────────────────────────────────────────────────────

  void _initData() {
    fetchStockDetail();
    fetchGraph();
  }

  // ─── Fetch Stock Detail ────────────────────────────────────────────────────

  Future<void> fetchStockDetail() async {
    isDetailLoading.value = true;
    errorMessage.value = '';

    final result = await getStockDetailUseCase(
      StockDetailParams(symbol: _symbol),
    );

    result.fold(
          (failure) => errorMessage.value = failure.message,
          (detail) => stockDetail.value = detail,
    );

    isDetailLoading.value = false;
  }

  // ─── Fetch Graph ───────────────────────────────────────────────────────────

  Future<void> fetchGraph() async {
    isChartLoading.value = true;

    final result = await getStockGraphUseCase(
      StockGraphParams(symbol: _symbol, timeRange: selectedRange.value),
    );

    result.fold(
          (failure) {
        debugPrint('Graph error: ${failure.message}');
      },
          (graphList) {
        chartData.value = graphList
            .map(
              (e) => KLineEntity.fromCustom(
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            vol: e.volume,
            time: e.date.millisecondsSinceEpoch,
          ),
        )
            .toList();
      },
    );

    isChartLoading.value = false;
  }

  // ─── Other Actions ─────────────────────────────────────────────────────────

  void selectCandle(KLineEntity candle) {
    selectedCandle.value = candle;
  }
}