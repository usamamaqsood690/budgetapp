import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/stats_chart_graph_model.dart';

abstract class CashflowRemoteDataSource {
  Future<ChartGraphResponse> getIncomeSummary({
    required String range,
  });
  Future<ChartGraphResponse> getExpenseSummary({
    required String range,
  });
  Future<ChartGraphResponse> getCashFlowSummary({
    required String range,
  });
  Future<PokemonChartGraphModelResponse> getCashFlowPokemon();
  Future<CashFlowDetailResponse> getCashFlowDetail();
}
