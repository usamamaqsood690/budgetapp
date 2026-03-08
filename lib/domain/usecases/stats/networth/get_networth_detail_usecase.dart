import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';
import 'package:wealthnxai/data/models/stats/networth/networth_detail_response_model/get_networth_detail_response_mode.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/cashflow_repository/cashflow_repository.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/networth_repository/networth_repository.dart';

class GetNetWorthDetailUseCase {
  final NetWorthRepository repository;

  GetNetWorthDetailUseCase({required this.repository});

  Future<Either<Failure, NetWorthResponseModel>> call() async {
    return await repository.getNetWorthDetail();
  }
}

