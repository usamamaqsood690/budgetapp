import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/stats/budget/get_all_budget_response_model/get_all_budget_response_model.dart';
import 'package:wealthnxai/domain/datasources/remote/stats_remote_datasource/budget_remote_datasource/budget_remote_datasource.dart';

class BudgetRemoteDataSourceImpl extends BaseRemoteDataSource
    implements BudgetRemoteDataSource {
  final ApiClient apiClient;

  BudgetRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BudgetResponse> getBudgets() async {
    try {
      final response = await apiClient.get(
        ApiConstants.getBudget,
        includeUserId: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
                'Invalid budget response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        return BudgetResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ??
                  'Failed to fetch budgets')
              : 'Failed to fetch budgets',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching budgets',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }
}
