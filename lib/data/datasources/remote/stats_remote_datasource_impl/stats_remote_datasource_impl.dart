import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/stats/main_stats_response_model.dart';
import 'package:wealthnxai/data/models/stats/transactions/get_transaction_response_model/get_transaction_response_model.dart';
import 'package:wealthnxai/domain/datasources/remote/stats_remote_datasource/stats_remote_datasource.dart';
import 'package:wealthnxai/domain/datasources/remote/stats_remote_datasource/transaction_remote_datasource/transaction_remote_datasource.dart';

class StatsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements StatsRemoteDataSource {
  final ApiClient apiClient;

  StatsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<StatsResponse> getStatsSummary() async {
    try {
      final response = await apiClient.get(
        ApiConstants.getStats,
        includeUserId: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid stats response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        return StatsResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ??
              'Failed to fetch stats')
              : 'Failed to fetch stats',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage:
        'An error occurred while fetching stats',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }
}

