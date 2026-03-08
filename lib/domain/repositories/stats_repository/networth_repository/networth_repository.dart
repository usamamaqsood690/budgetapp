import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/main_stats_response_model.dart';
import 'package:wealthnxai/data/models/stats/networth/networth_detail_response_model/get_networth_detail_response_mode.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/stats_chart_graph_model.dart';
import 'package:wealthnxai/data/models/stats/transactions/get_transaction_response_model/get_transaction_response_model.dart';

/// Repository contract for Stats
abstract class NetWorthRepository {
  Future<Either<Failure, ChartGraphResponse>> getNetWorthSummary({ required String range,});
  Future<Either<Failure, ChartGraphResponse>> getAssetsSummary({
    required String range,
  });
  Future<Either<Failure, ChartGraphResponse>> getLiabilitiesSummary({
    required String range,
  });
  Future<Either<Failure, PokemonChartGraphModelResponse>> getNetWorthPokemon();
  Future<Either<Failure, NetWorthResponseModel>> getNetWorthDetail();
}

