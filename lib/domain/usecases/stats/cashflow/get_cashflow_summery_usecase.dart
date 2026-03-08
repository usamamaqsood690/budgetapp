import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/stats_chart_graph_model.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/cashflow_repository/cashflow_repository.dart';
import 'package:wealthnxai/domain/usecases/stats/chart_graph_param.dart';

class GetCashFlowSummaryUseCase {
  final CashFlowRepository repository;

  GetCashFlowSummaryUseCase({required this.repository});

  Future<Either<Failure, ChartGraphResponse>> call(TimeRangeParams param) async {
    return await repository.getCashFlowSummary(range:param.timeRange);
  }
}

