import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/datasources/remote/stock/stock_remote_datasource.dart';
import 'package:wealthnxai/domain/entities/stock/stock_entity.dart';
import 'package:wealthnxai/domain/repositories/stock_repository/stock_list_repository.dart';
import 'package:wealthnxai/domain/usecases/stock/stock_list_params.dart';

class StockListRepositoryImpl implements StockListRepository {
  final StockListRemoteDataSource remoteDataSource;

  StockListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<StockEntity>>> getStockList(
      StockListParams params,
      ) async {
    try {
      final result = await remoteDataSource.getStockList(params);
      final entities = result.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}