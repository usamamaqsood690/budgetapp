import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/data/models/plaid_connection_plaid_response_model/plaid_connection_response_model.dart';

abstract class PlaidAccountRepository {
  /// Plaid Connection check
  Future<Either<Failure, PlaidConnectionResponse>> plaidConnectionCheck();
}
