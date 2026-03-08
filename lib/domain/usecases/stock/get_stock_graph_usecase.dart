import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/stock/stock_graph_entity.dart';
import 'package:wealthnxai/domain/repositories/stock_repository/stock_detail_repoistory.dart';
import 'package:wealthnxai/domain/usecases/stock/stock_graph_params.dart';

class GetStockGraphUseCase {
  final StockDetailRepository repository;

  GetStockGraphUseCase({required this.repository});

  Future<Either<Failure, List<StockGraphEntity>>> call(
      StockGraphParams params,
      ) async {
    return await repository.getStockGraph(
      symbol: params.symbol,
      timeRange: params.timeRange,
    );
  }
}