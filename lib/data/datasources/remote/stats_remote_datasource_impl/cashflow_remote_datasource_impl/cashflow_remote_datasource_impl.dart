import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/stats_chart_graph_model.dart';
import 'package:wealthnxai/domain/datasources/remote/stats_remote_datasource/cashflow_remote_datasource/cashflow_remote_datasource.dart';

class CashFlowRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CashflowRemoteDataSource {
  final ApiClient apiClient;

  CashFlowRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ChartGraphResponse> getIncomeSummary({
    required String range,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.incomeSummary,
        includeUserId: true,
        queryParameters: {
          'range': range,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid income summary response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        return ChartGraphResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ??
              'Failed to fetch income summary')
              : 'Failed to fetch income summary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching income summary',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<ChartGraphResponse> getExpenseSummary({required String range})async {
    try {
      final response = await apiClient.get(
        ApiConstants.expenseSummary,
        includeUserId: true,
        queryParameters: {
          'range': range,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid expense summary response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        return ChartGraphResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ??
              'Failed to fetch expense summary')
              : 'Failed to fetch expense summary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching expense summary',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<ChartGraphResponse> getCashFlowSummary({required String range})async {
    try {
      final response = await apiClient.get(
        ApiConstants.cashFlowSummery,
        includeUserId: true,
        queryParameters: {
          'range': range,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid cash flow summary response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        return ChartGraphResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ??
              'Failed to fetch cash flow summary')
              : 'Failed to fetch cash flow summary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching cash flow summary',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<PokemonChartGraphModelResponse> getCashFlowPokemon()async {
    try {
      final response = await apiClient.get(
        ApiConstants.cashFlowPokemonSummary,
        includeUserId: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid cash flow pokemon summary response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }
        return PokemonChartGraphModelResponse.fromJson(
          response.data as Map<String, dynamic>, PokemonApiSource.cashFlow,
        );
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ??
              'Failed to fetch cash flow pokemon summary')
              : 'Failed to fetch cash flow pokemon summary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching cash flow pokemon summary',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<CashFlowDetailResponse> getCashFlowDetail()async {
    try {
      final response = await apiClient.get(
        ApiConstants.getAllCashFlow,
        includeUserId: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid cash flow detail response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }
        return CashFlowDetailResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ??
              'Failed to fetch cash flow detail')
              : 'Failed to fetch cash flow detail',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching cash flow detail',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }
}

