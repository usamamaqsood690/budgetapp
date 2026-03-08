import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/stats_chart_graph_model.dart';

abstract class CashFlowRepository {
  Future<Either<Failure, ChartGraphResponse>> getIncomeSummary({
    required String range,
  });
  Future<Either<Failure, ChartGraphResponse>> getExpenseSummary({
    required String range,
  });
  Future<Either<Failure, ChartGraphResponse>> getCashFlowSummary({
    required String range,
  });
  Future<Either<Failure, PokemonChartGraphModelResponse>> getCashFlowPokemon();
  Future<Either<Failure, CashFlowDetailResponse>> getCashFlowDetail();
}

