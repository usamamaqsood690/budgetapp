import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/utils/chart_graph_helper.dart';
import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/graph_data_model/graph_data_model.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_cashflow_detail_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_cashflow_pokemon_summery_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_cashflow_summery_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_expense_summary_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_income_summary_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/chart_graph_param.dart';

class CashFlowController extends GetxController {
  CashFlowController({
    required this.getIncomeSummaryUseCase,
    required this.getExpenseSummaryUseCase,
    required this.getCashFLowSummaryUseCase,
    required this.getCashFlowPokemonSummaryUseCase,
    required this.getCashFlowDetailUseCase,
  });

  final GetIncomeSummaryUseCase getIncomeSummaryUseCase;
  final GetExpenseSummaryUseCase getExpenseSummaryUseCase;
  final GetCashFlowSummaryUseCase getCashFLowSummaryUseCase;
  final GetCashFlowPokemonSummaryUseCase getCashFlowPokemonSummaryUseCase;
  final GetCashFlowDetailUseCase getCashFlowDetailUseCase;

  /// Expense filter for categories (all / recurring / non-recurring)
  final RxString selectedExpenseFilter = 'all'.obs;

  /// Currently selected tab
  final Rx<CashFlowTab> selectedTab = CashFlowTab.overview.obs;

  /// Currently selected chart range for income & expense
  final RxString incomeGraphTimeRange = ChartGraphRange.oneMonth.value.obs;
  final RxString expenseGraphTimeRange = ChartGraphRange.oneMonth.value.obs;
  final RxString cashFlowGraphTimeRange = ChartGraphRange.oneMonth.value.obs;

  /// Income chart graph data & loading state
  final RxList<GraphData> incomeChartData = <GraphData>[].obs;
  final RxBool isIncomeChartLoading = false.obs;
  final RxString incomeChartError = ''.obs;

  /// Expense chart graph data & loading state
  final RxList<GraphData> expenseChartData = <GraphData>[].obs;
  final RxBool isExpenseChartLoading = false.obs;
  final RxString expenseChartError = ''.obs;

  /// Cash Flow chart graph data & loading state
  final RxList<GraphData> cashFlowChartData = <GraphData>[].obs;
  final RxBool isCashFlowChartLoading = false.obs;
  final RxString cashFlowChartError = ''.obs;

  /// Pokemon chart graph data & loading state
  final RxList<PokemonChartGraphModel> pokemonChartData =
      <PokemonChartGraphModel>[].obs;
  final RxBool isPokemonChartLoading = false.obs;
  final RxString pokemonChartError = ''.obs;
  final Rx<PokemonChartGraphModel?> selectedPokemonMonth =
      Rx<PokemonChartGraphModel?>(null);

  /// Cash Flow detail data & loading state
  final Rx<CashFlowDetailBody?> cashFlowDetail = Rx<CashFlowDetailBody?>(null);
  final RxBool isCashFlowDetailLoading = false.obs;
  final RxString cashFlowDetailError = ''.obs;

  /// Income categories grouped by category name (reactive)
  List<TransactionCategory> get incomeCategories {
    final incomeBreakdown = cashFlowDetail.value?.incomeBreakdown ?? [];
    if (incomeBreakdown.isEmpty) return [];
    return TransactionCategory.groupByCategory(incomeBreakdown);
  }

  /// Expense categories grouped by category name (reactive)
  List<TransactionCategory> get expenseCategories {
    final detail = cashFlowDetail.value;
    if (detail == null) return [];

    // All expenses
    final allExpenses = detail.expenseBreakdown;
    if (allExpenses.isEmpty) return [];

    // Recurring expenses list from API
    final recurringExpenses = detail.recurringExpenses;

    // If filter is "recurring", only include recurring expenses
    if (selectedExpenseFilter.value == 'recurring') {
      if (recurringExpenses.isEmpty) return [];
      return TransactionCategory.groupByCategory(recurringExpenses);
    }

    // If filter is "non_recurring", exclude recurring expenses from all expenses
    if (selectedExpenseFilter.value == 'non_recurring') {
      if (recurringExpenses.isEmpty) {
        return TransactionCategory.groupByCategory(allExpenses);
      }

      final recurringSet = recurringExpenses.toSet();
      final nonRecurring = allExpenses.where((txn) => !recurringSet.contains(txn)).toList();
      if (nonRecurring.isEmpty) return [];
      return TransactionCategory.groupByCategory(nonRecurring);
    }

    // Default: all expenses
    return TransactionCategory.groupByCategory(allExpenses);
  }

  /// Total income amount for pie chart (reactive)
  double get incomeTotal {
    final incomeBreakdown = cashFlowDetail.value?.incomeBreakdown ?? [];
    if (incomeBreakdown.isEmpty) return 0.0;
    return incomeCategories
        .map((c) => c.totalAmount)
        .fold(0.0, (sum, amount) => sum + amount);
  }

  /// Total expense amount for pie chart (reactive)
  double get expenseTotal {
    final categories = expenseCategories;
    if (categories.isEmpty) return 0.0;
    return categories
        .map((c) => c.totalAmount)
        .fold(0.0, (sum, amount) => sum + amount);
  }

  /// Change expense filter (all / recurring / non_recurring)
  void setExpenseFilter(String filter) {
    if (selectedExpenseFilter.value == filter) return;
    selectedExpenseFilter.value = filter;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCashFlowDetail();
    fetchCashFlowSummary();
    fetchCashFlowPokemon();
    fetchIncomeSummary();
    fetchExpenseSummary();

  }

  /// Change selected tab
  void selectTab(CashFlowTab tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
  }

  /// Human‑readable tab title
  String getTabTitle(CashFlowTab tab) {
    switch (tab) {
      case CashFlowTab.overview:
        return 'Overview';
      case CashFlowTab.income:
        return 'Income';
      case CashFlowTab.expense:
        return 'Expense';
    }
  }

  /// Change income chart range without refetching data
  void setIncomeChartRange(String range) {
    if (incomeGraphTimeRange.value == range) return;
    incomeGraphTimeRange.value = range;
    fetchIncomeSummary();
  }

  /// Change expense chart range without refetching data
  void setExpenseChartRange(String range) {
    if (expenseGraphTimeRange.value == range) return;
    expenseGraphTimeRange.value = range;
    fetchExpenseSummary();
  }

  /// Change cash flow chart range without refetching data
  void setCashFLowChartRange(String range) {
    if (cashFlowGraphTimeRange.value == range) return;
    cashFlowGraphTimeRange.value = range;
    fetchCashFlowSummary();
  }

  /// Load income summary chart data from API
  Future<void> fetchIncomeSummary() async {
    isIncomeChartLoading.value = true;
    incomeChartError.value = '';

    try {
      final result = await getIncomeSummaryUseCase(
        TimeRangeParams(timeRange: incomeGraphTimeRange.value),
      );

      result.fold(
        (failure) {
          incomeChartError.value = failure.message;
          incomeChartData.clear();
        },
        (response) {
          incomeChartData.value =
              response.body
                  .map((e) => GraphData(label: e.monthName, volume: e.volume,total: e.total))
                  .toList();
        },
      );
    } catch (e) {
      // Fallback error handling in case of unexpected exceptions
      incomeChartError.value = e.toString();
      incomeChartData.clear();
    } finally {
      isIncomeChartLoading.value = false;
    }
  }

  /// Load expense summary chart data from API
  Future<void> fetchExpenseSummary() async {
    isExpenseChartLoading.value = true;
    expenseChartError.value = '';

    try {
      final result = await getExpenseSummaryUseCase(
        TimeRangeParams(timeRange: expenseGraphTimeRange.value),
      );

      result.fold(
        (failure) {
          expenseChartError.value = failure.message;
          expenseChartData.clear();
        },
        (response) {
          expenseChartData.value =
              response.body
                  .map((e) => GraphData(label: e.monthName, volume: e.volume,total: e.total))
                  .toList();
        },
      );
    } catch (e) {
      // Fallback error handling in case of unexpected exceptions
      expenseChartError.value = e.toString();
      expenseChartData.clear();
    } finally {
      isExpenseChartLoading.value = false;
    }
  }

  /// Load cash flow summary chart data from API
  Future<void> fetchCashFlowSummary() async {
    isCashFlowChartLoading.value = true;
    cashFlowChartError.value = '';

    try {
      final result = await getCashFLowSummaryUseCase(
        TimeRangeParams(timeRange: cashFlowGraphTimeRange.value),
      );

      result.fold(
        (failure) {
          cashFlowChartError.value = failure.message;
          cashFlowChartData.clear();
        },
        (response) {
          cashFlowChartData.value =
              response.body
                  .map((e) => GraphData(label: e.monthName, volume: e.volume,total: e.total))
                  .toList();
        },
      );
    } catch (e) {
      // Fallback error handling in case of unexpected exceptions
      cashFlowChartError.value = e.toString();
      cashFlowChartData.clear();
    } finally {
      isCashFlowChartLoading.value = false;
    }
  }

  /// Load cash flow pokemon chart data from API
  Future<void> fetchCashFlowPokemon() async {
    isPokemonChartLoading.value = true;
    pokemonChartError.value = '';

    try {
      final result = await getCashFlowPokemonSummaryUseCase();

      result.fold(
        (failure) {
          pokemonChartError.value = failure.message;
          pokemonChartData.clear();
          selectedPokemonMonth.value = null;
        },
        (response) {
          pokemonChartData.value = response.body;
          // Auto-select last month if data is available
          if (response.body.isNotEmpty) {
            selectedPokemonMonth.value = response.body.last;
          } else {
            selectedPokemonMonth.value = null;
          }
        },
      );
    } catch (e) {
      // Fallback error handling in case of unexpected exceptions
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

  /// Load cash flow detail data from API
  Future<void> fetchCashFlowDetail() async {
    isCashFlowDetailLoading.value = true;
    cashFlowDetailError.value = '';

    try {
      final result = await getCashFlowDetailUseCase();

      result.fold(
        (failure) {
          cashFlowDetailError.value = failure.message;
          cashFlowDetail.value = null;
        },
        (response) {
          cashFlowDetail.value = response.body;
        },
      );
    } catch (e) {
      // Fallback error handling in case of unexpected exceptions
      cashFlowDetailError.value = e.toString();
      cashFlowDetail.value = null;
    } finally {
      isCashFlowDetailLoading.value = false;
    }
  }

  /// Refresh income tab data (chart and detail)
  Future<void> refreshIncomeTab() async {
    await Future.wait([fetchIncomeSummary(), fetchCashFlowDetail()]);
  }

  /// Refresh expense tab data (chart and detail)
  Future<void> refreshExpenseTab() async {
    await Future.wait([fetchExpenseSummary(), fetchCashFlowDetail()]);
  }

  /// Refresh overview tab data (cash flow chart, pokemon chart, and detail)
  Future<void> refreshOverviewTab() async {
    await Future.wait([
      fetchCashFlowSummary(),
      fetchCashFlowPokemon(),
      fetchCashFlowDetail(),
    ]);
  }
}
