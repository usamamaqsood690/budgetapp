import 'package:wealthnxai/data/models/stats/transactions/get_transaction_response_model/get_transaction_response_model.dart';

/// Remote data source contract for Transactions
abstract class TransactionRemoteDataSource {
  /// Fetch all transactions for current user
  Future<TransactionResponseModel> getAllTransactions();
}

