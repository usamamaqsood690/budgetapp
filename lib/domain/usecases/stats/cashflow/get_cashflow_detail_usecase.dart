import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/cashflow_repository/cashflow_repository.dart';

class GetCashFlowDetailUseCase {
  final CashFlowRepository repository;

  GetCashFlowDetailUseCase({required this.repository});

  Future<Either<Failure, CashFlowDetailResponse>> call() async {
    return await repository.getCashFlowDetail();
  }
}

