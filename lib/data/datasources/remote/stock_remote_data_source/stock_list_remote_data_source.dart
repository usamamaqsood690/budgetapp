import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/stock/stock_list_model.dart';
import 'package:wealthnxai/domain/datasources/remote/stock/stock_remote_datasource.dart';
import 'package:wealthnxai/domain/usecases/stock/stock_list_params.dart';

class StockListRemoteDataSourceImpl extends BaseRemoteDataSource
    implements StockListRemoteDataSource {
  final ApiClient apiClient;

  StockListRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<StockItemModel>> getStockList(StockListParams params) async {
    try {
      final response = await apiClient.get(
        ApiConstants.stockList,
        queryParameters: params.toQueryParams(),
        // includeUserId: true, // Toggle based on your backend requirements
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message: 'Invalid response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        final stockResponse = StockListResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        // Check if the API returned a 'false' status despite a 200 OK
        if (!(stockResponse.status ?? true)) {
          throw ServerException(
            message: stockResponse.message ?? 'Failed to fetch stock list',
            statusCode: response.statusCode,
          );
        }

        return stockResponse.data;
      } else {
        throw ServerException(
          message: response.data is Map
              ? (response.data['message']?.toString() ?? 'Failed to fetch stock list')
              : 'Failed to fetch stock list',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'An error occurred while fetching stocks',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }
}