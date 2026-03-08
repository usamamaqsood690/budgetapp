import 'package:wealthnxai/data/models/stats/main_stats_response_model.dart';
import 'package:wealthnxai/data/models/stats/networth/networth_detail_response_model/get_networth_detail_response_mode.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/stats_chart_graph_model.dart';

abstract class NetWorthRemoteDatasource {
  Future<ChartGraphResponse> getNetWorthSummary({
    required String range,
  });
  Future<ChartGraphResponse> getAssetsSummary({
    required String range,
  });
  Future<ChartGraphResponse> getLiabilitiesSummary({
    required String range,
  });
  Future<PokemonChartGraphModelResponse> getNetWorthPokemon();
  Future<NetWorthResponseModel> getNetWorthDetail();
}