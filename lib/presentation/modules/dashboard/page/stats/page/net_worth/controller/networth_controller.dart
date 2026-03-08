import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/utils/chart_graph_helper.dart';
import 'package:wealthnxai/data/models/stats/networth/networth_detail_response_model/get_networth_detail_response_mode.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/graph_data_model/graph_data_model.dart';
import 'package:wealthnxai/domain/usecases/stats/chart_graph_param.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_asset_summary_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_liabilities_summary_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_networth_detail_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_networth_pokemon_summary.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_networth_summary_usecase.dart';

class NetWorthController extends GetxController {
  NetWorthController({
    required this.netWorthSummaryUseCase,
    required this.getAssetsSummaryUseCase,
    required this.getLiabilitiesSummaryUseCase,
    required this.getNetWorthPokemonSummaryUseCase,
    required this.getNetWorthDetailUseCase,
  });

  final NetWorthSummaryUseCase netWorthSummaryUseCase;
  final GetAssetsSummaryUseCase getAssetsSummaryUseCase;
  final GetLiabilitiesSummaryUseCase getLiabilitiesSummaryUseCase;
  final GetNetWorthPokemonSummaryUseCase getNetWorthPokemonSummaryUseCase;
  final GetNetWorthDetailUseCase getNetWorthDetailUseCase;

  /// Currently selected tab
  final Rx<NetWorthTab> selectedTab = NetWorthTab.overview.obs;

  /// Currently selected chart ranges
  final RxString netWorthGraphTimeRange = ChartGraphRange.oneMonth.value.obs;
  final RxString assetsGraphTimeRange = ChartGraphRange.oneMonth.value.obs;
  final RxString liabilitiesGraphTimeRange = ChartGraphRange.oneMonth.value.obs;

  /// Net worth chart graph data & loading state
  final RxList<GraphData> netWorthChartData = <GraphData>[].obs;
  final RxBool isNetWorthChartLoading = false.obs;
  final RxString netWorthChartError = ''.obs;

  /// Assets chart graph data & loading state
  final RxList<GraphData> assetsChartData = <GraphData>[].obs;
  final RxBool isAssetsChartLoading = false.obs;
  final RxString assetsChartError = ''.obs;

  /// Liabilities chart graph data & loading state
  final RxList<GraphData> liabilitiesChartData = <GraphData>[].obs;
  final RxBool isLiabilitiesChartLoading = false.obs;
  final RxString liabilitiesChartError = ''.obs;

  /// Pokemon chart graph data & loading state
  final RxList<PokemonChartGraphModel> pokemonChartData = <PokemonChartGraphModel>[].obs;
  final RxBool isPokemonChartLoading = false.obs;
  final RxString pokemonChartError = ''.obs;
  final Rx<PokemonChartGraphModel?> selectedPokemonMonth = Rx<PokemonChartGraphModel?>(null);

  /// Net worth detail data & loading state
  final Rx<NetWorthBody?> netWorthDetail = Rx<NetWorthBody?>(null);
  final RxBool isNetWorthDetailLoading = false.obs;
  final RxString netWorthDetailError = ''.obs;

  /// Computed helpers
  double get totalNetWorth => netWorthDetail.value?.totalNetWorth ?? 0.0;

  double get totalAssets => netWorthDetail.value?.totalAssets ?? 0.0;

  double get totalLiabilities => netWorthDetail.value?.totalLiabilities ?? 0.0;

  List<AssetModel> get assets => netWorthDetail.value?.assets ?? [];

  List<LiabilityModel> get liabilities => netWorthDetail.value?.liabilities ?? [];

  @override
  void onInit() {
    super.onInit();
    fetchNetWorthDetail();
    fetchNetWorthSummary();
    fetchNetWorthPokemon();
    fetchAssetsSummary();
    fetchLiabilitiesSummary();
  }

  /// Change selected tab
  void selectTab(NetWorthTab tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
  }

  /// Human‑readable tab title
  String getTabTitle(NetWorthTab tab) {
    switch (tab) {
      case NetWorthTab.overview:
        return 'Overview';
      case NetWorthTab.assets:
        return 'Assets';
      case NetWorthTab.liabilities:
        return 'Liabilities';
    }
  }

  /// Change net worth chart range
  void setNetWorthChartRange(String range) {
    if (netWorthGraphTimeRange.value == range) return;
    netWorthGraphTimeRange.value = range;
    fetchNetWorthSummary();
  }

  /// Change assets chart range
  void setAssetsChartRange(String range) {
    if (assetsGraphTimeRange.value == range) return;
    assetsGraphTimeRange.value = range;
    fetchAssetsSummary();
  }

  /// Change liabilities chart range
  void setLiabilitiesChartRange(String range) {
    if (liabilitiesGraphTimeRange.value == range) return;
    liabilitiesGraphTimeRange.value = range;
    fetchLiabilitiesSummary();
  }

  /// Load net worth summary chart data from API
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
          netWorthChartData.value = response.body
              .map((e) => GraphData(label: e.monthName, volume: e.volume,total: e.total))
              .toList();
        },
      );
    } catch (e) {
      netWorthChartError.value = e.toString();
      netWorthChartData.clear();
    } finally {
      isNetWorthChartLoading.value = false;
    }
  }

  /// Load assets summary chart data from API
  Future<void> fetchAssetsSummary() async {
    isAssetsChartLoading.value = true;
    assetsChartError.value = '';

    try {
      final result = await getAssetsSummaryUseCase(
        TimeRangeParams(timeRange: assetsGraphTimeRange.value),
      );

      result.fold(
        (failure) {
          assetsChartError.value = failure.message;
          assetsChartData.clear();
        },
        (response) {
          assetsChartData.value = response.body
              .map((e) => GraphData(label: e.monthName, volume: e.volume,total: e.total))
              .toList();
        },
      );
    } catch (e) {
      assetsChartError.value = e.toString();
      assetsChartData.clear();
    } finally {
      isAssetsChartLoading.value = false;
    }
  }

  /// Load liabilities summary chart data from API
  Future<void> fetchLiabilitiesSummary() async {
    isLiabilitiesChartLoading.value = true;
    liabilitiesChartError.value = '';

    try {
      final result = await getLiabilitiesSummaryUseCase(
        TimeRangeParams(timeRange: liabilitiesGraphTimeRange.value),
      );

      result.fold(
        (failure) {
          liabilitiesChartError.value = failure.message;
          liabilitiesChartData.clear();
        },
        (response) {
          liabilitiesChartData.value = response.body
              .map((e) => GraphData(label: e.monthName, volume: e.volume,total: e.total))
              .toList();
        },
      );
    } catch (e) {
      liabilitiesChartError.value = e.toString();
      liabilitiesChartData.clear();
    } finally {
      isLiabilitiesChartLoading.value = false;
    }
  }

  /// Load net worth pokemon chart data from API
  Future<void> fetchNetWorthPokemon() async {
    isPokemonChartLoading.value = true;
    pokemonChartError.value = '';

    try {
      final result = await getNetWorthPokemonSummaryUseCase();

      result.fold(
        (failure) {
          pokemonChartError.value = failure.message;
          pokemonChartData.clear();
          selectedPokemonMonth.value = null;
        },
        (response) {
          pokemonChartData.value = response.body;
          if (response.body.isNotEmpty) {
            selectedPokemonMonth.value = response.body.last;
          } else {
            selectedPokemonMonth.value = null;
          }
        },
      );
    } catch (e) {
      pokemonChartError.value = e.toString();
      pokemonChartData.clear();
      selectedPokemonMonth.value = null;
    } finally {
      isPokemonChartLoading.value = false;
    }
  }

  /// Handle pokemon month selection
  void selectPokemonMonth(PokemonChartGraphModel monthData) {
    selectedPokemonMonth.value = monthData;
  }

  /// Load net worth detail data from API
  Future<void> fetchNetWorthDetail() async {
    isNetWorthDetailLoading.value = true;
    netWorthDetailError.value = '';

    try {
      final result = await getNetWorthDetailUseCase();

      result.fold(
        (failure) {
          netWorthDetailError.value = failure.message;
          netWorthDetail.value = null;
        },
        (response) {
          netWorthDetail.value = response.body;
        },
      );
    } catch (e) {
      netWorthDetailError.value = e.toString();
      netWorthDetail.value = null;
    } finally {
      isNetWorthDetailLoading.value = false;
    }
  }

  /// Refresh liabilities tab data (chart and detail)
  Future<void> refreshLiabilitiesTab() async {
    await Future.wait([
      fetchLiabilitiesSummary(),
      fetchNetWorthDetail(),
    ]);
  }

  /// Refresh assets tab data (chart and detail)
  Future<void> refreshAssetsTab() async {
    await Future.wait([
      fetchAssetsSummary(),
      fetchNetWorthDetail(),
    ]);
  }

  /// Refresh overview tab data (net worth chart, pokemon chart, and detail)
  Future<void> refreshOverviewTab() async {
    await Future.wait([
      fetchNetWorthSummary(),
      fetchNetWorthPokemon(),
      fetchNetWorthDetail(),
    ]);
  }
}