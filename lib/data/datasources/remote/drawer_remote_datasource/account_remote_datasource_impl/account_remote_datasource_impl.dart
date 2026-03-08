import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/plaid_connection_plaid_response_model/plaid_connection_response_model.dart';
import 'package:wealthnxai/domain/datasources/remote/drawer_remote_datasource/account_remote_datasource/account_remote_datasource.dart';

class PlaidRemoteDataSourceImpl extends BaseRemoteDataSource
    implements PlaidAccountRemoteDataSource {
  final ApiClient apiClient;

  PlaidRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PlaidConnectionResponse> plaidConnectionCheck() async {
    try {
      final apiResponse = await apiClient.get(
        ApiConstants.plaidConnectionCheck,
        includeUserId: true,
      );

      if (apiResponse.statusCode == 200 ||
          apiResponse.statusCode == 201) {

        final plaidResponse =
        PlaidConnectionResponse.fromJson(apiResponse.data);

        if (!plaidResponse.status) {
          throw ServerException(
            message: plaidResponse.message,
            statusCode: apiResponse.statusCode,
          );
        }

        return plaidResponse;
      } else {
        throw ServerException(
          message: apiResponse.data['message'] ??
              'Failed to check Plaid connection',
          statusCode: apiResponse.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'Failed to check Plaid connection',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }
}