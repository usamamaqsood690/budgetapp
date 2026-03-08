import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/main_stats_response_model.dart';
import 'package:wealthnxai/data/models/stats/transactions/get_transaction_response_model/get_transaction_response_model.dart';

/// Repository contract for Stats
abstract class StatsRepository {
  Future<Either<Failure, StatsResponse>> getStatsSummary();
}

