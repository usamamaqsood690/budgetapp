// lib/data/datasources/remote/crypto_remote_data_source/crypto_chart_remote_datasource_impl.dart

import 'package:dio/dio.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/crypto/crypto_chart_model.dart';
import 'package:wealthnxai/domain/datasources/remote/crypto/crypto_chart_remote_datasource.dart';

class CryptoChartRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CryptoChartRemoteDataSource {

  // Dedicated Dio for CoinGecko — different baseUrl + API key vs ApiClient
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.coinGeckoBaseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'x-cg-pro-api-key': ApiConstants.coinGeckoApiKey,
        'Accept': 'application/json',
      },
    ),
  );

  @override
  Future<List<CryptoChartModel>> fetchOhlcChart({
    required String coinId,
    required String days,
  }) async {
    try {
      final response = await _dio.get(
        '/coins/$coinId/ohlc',
        queryParameters: {'vs_currency': 'usd', 'days': days},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> raw = response.data as List<dynamic>;
        return raw
            .map((e) => CryptoChartModel.fromJson(e as List<dynamic>))
            .toList()
          // ..sort((a, b) => a.time.compareTo(b.time))
        ;
      } else {
        throw ServerException(
          message: 'Failed to fetch chart data',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'Failed to fetch chart data',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }
}