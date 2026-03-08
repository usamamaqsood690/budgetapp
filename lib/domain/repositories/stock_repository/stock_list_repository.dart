import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/stock/stock_entity.dart';
import 'package:wealthnxai/domain/usecases/stock/stock_list_params.dart';

abstract class StockListRepository {
  Future<Either<Failure, List<StockEntity>>> getStockList(StockListParams params);
}