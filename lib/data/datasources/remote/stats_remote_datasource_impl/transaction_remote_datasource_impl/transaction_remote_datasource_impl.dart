import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/stats/transactions/get_transaction_response_model/get_transaction_response_model.dart';
import 'package:wealthnxai/domain/datasources/remote/stats_remote_datasource/transaction_remote_datasource/transaction_remote_datasource.dart';

class TransactionRemoteDataSourceImpl extends BaseRemoteDataSource
    implements TransactionRemoteDataSource {
  final ApiClient apiClient;

  TransactionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<TransactionResponseModel> getAllTransactions() async {
    try {
      final response = await apiClient.post(
        ApiConstants.getTransaction,
        includeUserId: true,
        data: const {},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
                'Invalid transactions response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        return TransactionResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ??
                  'Failed to fetch transactions')
              : 'Failed to fetch transactions',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage:
            'An error occurred while fetching transactions',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }
}

