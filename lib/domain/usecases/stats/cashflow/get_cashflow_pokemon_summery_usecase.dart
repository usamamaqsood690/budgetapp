import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/cashflow_repository/cashflow_repository.dart';

class GetCashFlowPokemonSummaryUseCase {
  final CashFlowRepository repository;

  GetCashFlowPokemonSummaryUseCase({required this.repository});

  Future<Either<Failure, PokemonChartGraphModelResponse>> call() async {
    return await repository.getCashFlowPokemon();
  }
}

