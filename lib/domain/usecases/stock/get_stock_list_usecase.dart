import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/stock/stock_entity.dart';
import 'package:wealthnxai/domain/repositories/stock_repository/stock_list_repository.dart';
import 'package:wealthnxai/domain/usecases/stock/stock_list_params.dart';

/// Get Stock List Use Case
/// Business logic for fetching stock list
class GetStockListUseCase {
  final StockListRepository repository;

  GetStockListUseCase({required this.repository});

  Future<Either<Failure, List<StockEntity>>> call(StockListParams params) async {
    return await repository.getStockList(params);
  }
}