import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/stock/stock_detail_entity.dart';
import 'package:wealthnxai/domain/entities/stock/stock_graph_entity.dart';

abstract class StockDetailRepository {
  Future<Either<Failure, StockDetailEntity>> getStockDetail({
    required String symbol,
  });

  Future<Either<Failure, List<StockGraphEntity>>> getStockGraph({
    required String symbol,
    required String timeRange,
  });
}