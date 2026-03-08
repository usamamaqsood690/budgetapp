import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';
import 'package:wealthnxai/data/models/stats/networth/networth_detail_response_model/get_networth_detail_response_mode.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/stats_chart_graph_model.dart';
import 'package:wealthnxai/domain/datasources/remote/stats_remote_datasource/cashflow_remote_datasource/cashflow_remote_datasource.dart';
import 'package:wealthnxai/domain/datasources/remote/stats_remote_datasource/networth_remote_datasource/networth_remote_datasource.dart';

class NetWorthRemoteDataSourceImpl extends BaseRemoteDataSource
    implements NetWorthRemoteDatasource {
  final ApiClient apiClient;

  NetWorthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ChartGraphResponse> getNetWorthSummary({
    required String range,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.netWorthSummery,
        includeUserId: true,
        queryParameters: {
          'range': range,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid networth summary response format: expected Map but got ${response.data.runtimeType}',
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
              'Failed to fetch networth summary')
              : 'Failed to fetch networth summary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching networth summary',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<ChartGraphResponse> getAssetsSummary({required String range}) async{
    try {
      final response = await apiClient.get(
        ApiConstants.assetsSummery,
        includeUserId: true,
        queryParameters: {
          'range': range,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid assets summary response format: expected Map but got ${response.data.runtimeType}',
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
              'Failed to fetch assets summary')
              : 'Failed to fetch assets summary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching assets summary',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<ChartGraphResponse> getLiabilitiesSummary({required String range})async {
    try {
      final response = await apiClient.get(
        ApiConstants.liabilitiesSummery,
        includeUserId: true,
        queryParameters: {
          'range': range,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid Liabilities summary response format: expected Map but got ${response.data.runtimeType}',
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
              'Failed to fetch Liabilities summary')
              : 'Failed to fetch Liabilities summary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching Liabilities summary',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<NetWorthResponseModel> getNetWorthDetail() async{
    try {
      final response = await apiClient.get(
        ApiConstants.getAllNetWorth,
        includeUserId: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid net worth detail response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }
        return NetWorthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ??
              'Failed to fetch net worth detail')
              : 'Failed to fetch net worth detail',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching net worth detail',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<PokemonChartGraphModelResponse> getNetWorthPokemon()async {
    try {
      final response = await apiClient.get(
        ApiConstants.netWorthPokemonSummary,
        includeUserId: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid net worth pokemon summary response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }
        return PokemonChartGraphModelResponse.fromJson(
          response.data as Map<String, dynamic>, PokemonApiSource.netWorth,
        );
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ??
              'Failed to fetch net worth pokemon summary')
              : 'Failed to fetch net worth pokemon summary',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching net worth pokemon summary',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

}

