import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/utils/chart_graph_helper.dart';
import 'package:wealthnxai/data/models/stats/main_stats_response_model.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/graph_data_model/graph_data_model.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_cashflow_summery_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/chart_graph_param.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_networth_summary_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/stats_main_usecase.dart';

class StatsController extends GetxController {
  StatsController({required this.getMainStatsUseCase,required this.netWorthSummaryUseCase,required this.getCashFlowSummaryUseCase});

  final GetMainStatsUseCase getMainStatsUseCase;
  final NetWorthSummaryUseCase netWorthSummaryUseCase;
  final GetCashFlowSummaryUseCase getCashFlowSummaryUseCase;


  /// NetWorth chart graph data & loading state
  final RxList<GraphData> netWorthChartData = <GraphData>[].obs;
  final RxBool isNetWorthChartLoading = false.obs;
  final RxString netWorthChartError = ''.obs;

  /// Cash Flow chart graph data & loading state
  final RxBool isCashFlowChartLoading = false.obs;
  final RxString cashFlowChartError = ''.obs;
  final RxList<Map<String, dynamic>> cashFlowChartData = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final statsModel = Rxn<StatsResponse>();

  final isVisible = true.obs;

  /// Currently selected chart range for netWorth
  final RxString netWorthGraphTimeRange = ChartGraphRange.oneMonth.value.obs;

  @override
  void onInit() {
    fetchStatsSummary();
    fetchNetWorthSummary();
    fetchCashFlowSummary();
    super.onInit();
  }

  void toggleVisibility() {
    isVisible.value = !isVisible.value;
  }

  Future<void> fetchStatsSummary() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await getMainStatsUseCase();

      result.fold(
            (failure) {
          errorMessage.value = failure.message;
        },
            (model) {
          statsModel.value = model;
        },
      );
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load expense summary chart data from API
  Future<void> fetchNetWorthSummary() async {
    isNetWorthChartLoading.value = true;
    netWorthChartError.value = '';

    try {
      final result = await netWorthSummaryUseCase(
        TimeRangeParams(timeRange: netWorthGraphTimeRange.value),
      );

      result.fold(
            (failure) {
              netWorthChartError.value = failure.message;
              netWorthChartData.clear();
        },
            (response) {
              netWorthChartData.value =
              response.body
                  .map((e) => GraphData(label: e.monthName, volume: e.volume,total: e.total))
                  .toList();
        },
      );
    } catch (e) {
      // Fallback error handling in case of unexpected exceptions
      netWorthChartError.value = e.toString();
      netWorthChartData.clear();
    } finally {
      isNetWorthChartLoading.value = false;
    }
  }

  /// Change networth chart range without refetching data
  void setNetWorthChartRange(String range) {
    if (netWorthGraphTimeRange.value == range) return;
    netWorthGraphTimeRange.value = range;
    fetchNetWorthSummary();
  }


  /// Load cash flow summary chart data from API
  Future<void> fetchCashFlowSummary() async {
    isCashFlowChartLoading.value = true;
    cashFlowChartError.value = '';

    try {
      final result = await getCashFlowSummaryUseCase(
        TimeRangeParams(timeRange: '1M'),
      );

      result.fold(
            (failure) {
          cashFlowChartError.value = failure.message;
          cashFlowChartData.clear();
        },
            (response) {
          cashFlowChartData.value = response.body
              .map((e) => {
            "monthName": e.monthName,
            "volume": e.volume,
          })
              .toList();
        },
      );
    } catch (e) {
      cashFlowChartError.value = e.toString();
      cashFlowChartData.clear();
    } finally {
      isCashFlowChartLoading.value = false;
    }
  }
}