import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/stock/stock_detail_entity.dart';
import 'package:wealthnxai/domain/repositories/stock_repository/stock_detail_repoistory.dart';
import 'package:wealthnxai/domain/usecases/stock/stock_detail_params.dart';

class GetStockDetailUseCase {
  final StockDetailRepository repository;

  GetStockDetailUseCase({required this.repository});

  Future<Either<Failure, StockDetailEntity>> call(
      StockDetailParams params,
      ) async {
    return await repository.getStockDetail(symbol: params.symbol);
  }
}