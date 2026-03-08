import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/transactions/get_transaction_response_model/get_transaction_response_model.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/transaction_repository/transaction_repository.dart';

class GetAllTransactionUseCase {
  final TransactionRepository repository;

  GetAllTransactionUseCase({required this.repository});

  Future<Either<Failure, TransactionResponseModel>> call() async {
    return await repository.getAllTransactions();
  }
}

