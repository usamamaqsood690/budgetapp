/// News Remote Data Source - Data Layer
/// Located in: lib/data/datasources/remote/news_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/models/news/crypto_news_model.dart';

abstract class NewsRemoteDataSource {
  /// Fetch news by symbol (e.g., AAPL, BTC)
  Future<List<CryptoNewsModel>> fetchNewsBySymbol({
    required String symbol,
    int page = 1,
    int limit = 20,
  });

  /// Fetch latest news by type (general, crypto, stock)
  Future<List<CryptoNewsModel>> fetchLatestNews({
    required String type,
    int page = 1,
    int limit = 10,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient _apiClient;

  NewsRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<List<CryptoNewsModel>> fetchNewsBySymbol({
    required String symbol,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final endpoint =
          '${ApiConstants.newsBySymbol}$symbol?page=$page&limit=$limit';
      final response = await _apiClient.get(endpoint);
      return _parseResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<CryptoNewsModel>> fetchLatestNews({
    required String type,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final endpoint =
          '${ApiConstants.newsLatest}?type=$type&page=$page&limit=$limit';
      final response = await _apiClient.get(endpoint);
      return _parseResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  /// Parse API response to list of models
  /// Handles the nested structure: { status, message, body: { data: [...] } }
  List<CryptoNewsModel> _parseResponse(Response response) {
    if (response.statusCode == 200 && response.data != null) {
      final responseData = response.data;

      // Handle Map response (wrapped structure)
      if (responseData is Map<String, dynamic>) {
        // Check if response indicates success
        final status = responseData['status'] as bool? ?? false;
        if (!status) {
          final message =
              responseData['message'] as String? ?? 'Request failed';
          throw ServerException(
            message: message,
            statusCode: response.statusCode,
          );
        }

        // Parse using the response model for cleaner handling
        final newsResponse = NewsResponseModel.fromJson(responseData);
        return newsResponse.news;
      }

      // Handle direct List response (fallback for different API versions)
      if (responseData is List) {
        return responseData
            .map((json) => CryptoNewsModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      // Empty response
      return [];
    }

    throw ServerException(
      message: 'Invalid response',
      statusCode: response.statusCode,
    );
  }

  /// Handle Dio exceptions and convert to custom exceptions
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Connection timeout');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');
      case DioExceptionType.badResponse:
        return ServerException(
          message: e.response?.data?['message'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request cancelled');
      default:
        return ServerException(message: e.message ?? 'Unknown error');
    }
  }
}