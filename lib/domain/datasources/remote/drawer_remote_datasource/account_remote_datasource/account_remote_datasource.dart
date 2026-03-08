import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/data/models/plaid_connection_plaid_response_model/plaid_connection_response_model.dart';
import 'package:wealthnxai/data/models/user_model/user_model.dart';

abstract class PlaidAccountRemoteDataSource {
  Future<PlaidConnectionResponse> plaidConnectionCheck();
}