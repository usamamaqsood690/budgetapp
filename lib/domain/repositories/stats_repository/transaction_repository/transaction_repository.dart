import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/transactions/get_transaction_response_model/get_transaction_response_model.dart';

/// Repository contract for Transactions
abstract class TransactionRepository {
  Future<Either<Failure, TransactionResponseModel>> getAllTransactions();
}

