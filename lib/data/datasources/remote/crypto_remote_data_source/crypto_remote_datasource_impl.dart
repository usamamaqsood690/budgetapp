// lib/data/datasources/remote/crypto/crypto_remote_datasource_impl.dart

import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/crypto/crypto_list_response_model.dart';
import 'package:wealthnxai/data/models/crypto/crypto_profile_response_model.dart';
import 'package:wealthnxai/domain/datasources/remote/crypto/crypto_remote_datasource.dart';

class CryptoRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CryptoRemoteDataSource {
  final ApiClient apiClient;

  CryptoRemoteDataSourceImpl({required this.apiClient});

  // ─── Fetch List ─────────────────────────────────────────────────────────────

  @override
  Future<CryptoListResponseModel> fetchCryptoList({
    CryptoListType listType = CryptoListType.all,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.cryptoList,
        queryParameters: {
          'listType': listType.value,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = _validateMap(response, 'fetch crypto list');
        final result = CryptoListResponseModel.fromJson(data);
        if (!(result.status)) {
          throw ServerException(
            message: result.message.isNotEmpty
                ? result.message
                : 'Failed to fetch crypto list',
            statusCode: response.statusCode,
          );
        }
        return result;
      } else {
        throw ServerException(
          message: _errorMessage(response, 'Failed to fetch crypto list'),
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e,
          defaultServerMessage: 'An error occurred while fetching crypto list');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  // ─── Search ─────────────────────────────────────────────────────────────────

  @override
  Future<CryptoListResponseModel> searchCryptoList({
    required String search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.cryptoList,
        queryParameters: {
          'search': search,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = _validateMap(response, 'search crypto');
        final result = CryptoListResponseModel.fromJson(data);
        if (!(result.status)) {
          throw ServerException(
            message: result.message.isNotEmpty
                ? result.message
                : 'Failed to search crypto',
            statusCode: response.statusCode,
          );
        }
        return result;
      } else {
        throw ServerException(
          message: _errorMessage(response, 'Failed to search crypto'),
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e,
          defaultServerMessage: 'An error occurred while searching crypto');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  // ─── Fetch Profile ───────────────────────────────────────────────────────────

  @override
  Future<CryptoProfileResponseModel> fetchCryptoProfile({
    required String sym,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.cryptoProfile,
        queryParameters: {'sym': sym},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = _validateMap(response, 'fetch crypto profile');
        final result = CryptoProfileResponseModel.fromJson(data);
        if (!(result.status)) {
          throw ServerException(
            message: result.message.isNotEmpty
                ? result.message
                : 'Failed to fetch crypto profile',
            statusCode: response.statusCode,
          );
        }
        return result;
      } else {
        throw ServerException(
          message: _errorMessage(response, 'Failed to fetch crypto profile'),
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e,
          defaultServerMessage: 'An error occurred while fetching crypto profile');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  /// Validates that response.data is a Map — mirrors StockListRemoteDataSourceImpl
  Map<String, dynamic> _validateMap(Response response, String context) {
    if (response.data == null || response.data is! Map<String, dynamic>) {
      throw ServerException(
        message:
        'Invalid response format for $context: expected Map but got ${response.data.runtimeType}',
        statusCode: response.statusCode,
      );
    }
    return response.data as Map<String, dynamic>;
  }

  String _errorMessage(Response response, String fallback) {
    return response.data is Map
        ? (response.data['message']?.toString() ?? fallback)
        : fallback;
  }
}