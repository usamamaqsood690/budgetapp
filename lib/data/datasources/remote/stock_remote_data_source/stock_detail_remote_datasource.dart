import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/stock/stock_detail_model.dart';
import 'package:wealthnxai/data/models/stock/stock_graph_model.dart';

abstract class StockDetailRemoteDataSource {
  Future<StockDetailModel> getStockDetail({required String symbol});
  Future<List<StockGraphModel>> getStockGraph({
    required String symbol,
    required String timeRange,
  });
}

class StockDetailRemoteDataSourceImpl extends BaseRemoteDataSource
    implements StockDetailRemoteDataSource {
  final ApiClient apiClient;

  // Separate Dio instance for FMP (external API — different base URL & no auth headers)
  final Dio _fmpDio;

  StockDetailRemoteDataSourceImpl({
    required this.apiClient,
    Dio? fmpDio,
  }) : _fmpDio = fmpDio ?? Dio(BaseOptions(baseUrl: ApiConstants.fmpBaseUrl));

  // ─── Stock Detail ──────────────────────────────────────────────────────────

  @override
  Future<StockDetailModel> getStockDetail({required String symbol}) async {
    try {
      final response = await apiClient.get(
        ApiConstants.stockProfile,
        queryParameters: {'sym': symbol},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
            'Invalid response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        // Response shape: { "status": true, "message": "...", "body": { ... } }
        return StockDetailModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ?? 'Failed to fetch stock detail')
              : 'Failed to fetch stock detail',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching stock detail',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  // ─── Stock Graph ───────────────────────────────────────────────────────────

  @override
  Future<List<StockGraphModel>> getStockGraph({
    required String symbol,
    required String timeRange,
  }) async {
    final today = DateTime.now();

    if (timeRange == '1 D') {
      return _fetchIntradayGraph(symbol: symbol, today: today);
    } else {
      return _fetchHistoricalGraph(
        symbol: symbol,
        today: today,
        timeRange: timeRange,
      );
    }
  }

  // ─── Intraday (1min) — used for 1D ─────────────────────────────────────────

  Future<List<StockGraphModel>> _fetchIntradayGraph({
    required String symbol,
    required DateTime today,
  }) async {
    try {
      final response = await _fmpDio.get(
        '/api/v3/historical-chart/1min/$symbol',
        queryParameters: {'apikey': ApiConstants.fmpApiKey},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! List) {
          throw ServerException(
            message: 'Invalid intraday graph response format',
            statusCode: response.statusCode,
          );
        }

        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((item) =>
            StockGraphModel.fromIntradayJson(item as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      } else {
        throw ServerException(
          message: 'Intraday graph error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching intraday graph',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  // ─── Historical (daily) — used for 7D / 1M / 6M / 1Y / YTD ───────────────

  Future<List<StockGraphModel>> _fetchHistoricalGraph({
    required String symbol,
    required DateTime today,
    required String timeRange,
  }) async {
    final fromDate = _resolveFromDate(today: today, timeRange: timeRange);
    final formattedFrom = DateFormat('yyyy-MM-dd').format(fromDate);
    final formattedTo = DateFormat('yyyy-MM-dd').format(today);

    try {
      final response = await _fmpDio.get(
        '/api/v3/historical-price-full/$symbol',
        queryParameters: {
          'from': formattedFrom,
          'to': formattedTo,
          'apikey': ApiConstants.fmpApiKey,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message: 'Invalid historical graph response format',
            statusCode: response.statusCode,
          );
        }

        final Map<String, dynamic> data =
        response.data as Map<String, dynamic>;
        final List<dynamic> historical =
            data['historical'] as List<dynamic>? ?? [];

        return historical
            .map((item) =>
            StockGraphModel.fromHistoricalJson(item as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      } else {
        throw ServerException(
          message: 'Historical graph error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage:
        'An error occurred while fetching historical graph',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  // ─── Helper: Resolve from-date based on time range ─────────────────────────

  DateTime _resolveFromDate({
    required DateTime today,
    required String timeRange,
  }) {
    switch (timeRange) {
      case '7 D':
        return today.subtract(const Duration(days: 7));
      case '1 M':
        return today.subtract(const Duration(days: 30));
      case '6 M':
        return today.subtract(const Duration(days: 180));
      case '1 Y':
        return today.subtract(const Duration(days: 365));
      case 'YTD':
        return DateTime(today.year, 1, 1);
      default:
        return today.subtract(const Duration(days: 30));
    }
  }
}