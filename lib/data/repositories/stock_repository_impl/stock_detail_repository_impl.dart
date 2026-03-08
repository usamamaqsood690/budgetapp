import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/datasources/remote/stock_remote_data_source/stock_detail_remote_datasource.dart';
import 'package:wealthnxai/domain/entities/stock/stock_detail_entity.dart';
import 'package:wealthnxai/domain/entities/stock/stock_graph_entity.dart';
import 'package:wealthnxai/domain/repositories/stock_repository/stock_detail_repoistory.dart';

class StockDetailRepositoryImpl implements StockDetailRepository {
  final StockDetailRemoteDataSource remoteDataSource;

  StockDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StockDetailEntity>> getStockDetail({
    required String symbol,
  }) async {
    try {
      final result = await remoteDataSource.getStockDetail(symbol: symbol);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StockGraphEntity>>> getStockGraph({
    required String symbol,
    required String timeRange,
  }) async {
    try {
      final result = await remoteDataSource.getStockGraph(
        symbol: symbol,
        timeRange: timeRange,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
