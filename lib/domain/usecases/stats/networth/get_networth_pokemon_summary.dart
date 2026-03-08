import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/cashflow_repository/cashflow_repository.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/networth_repository/networth_repository.dart';

class GetNetWorthPokemonSummaryUseCase {
  final NetWorthRepository repository;

  GetNetWorthPokemonSummaryUseCase({required this.repository});

  Future<Either<Failure, PokemonChartGraphModelResponse>> call() async {
    return await repository.getNetWorthPokemon();
  }
}

