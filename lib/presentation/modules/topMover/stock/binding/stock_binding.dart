import 'package:get/get.dart';
import 'package:wealthnxai/data/datasources/remote/stock_remote_data_source/stock_list_remote_data_source.dart';
import 'package:wealthnxai/data/datasources/remote/stock_remote_data_source/stock_detail_remote_datasource.dart';
import 'package:wealthnxai/data/repositories/stock_repository_impl/stock_list_repository_impl.dart';
import 'package:wealthnxai/data/repositories/stock_repository_impl/stock_detail_repository_impl.dart';
import 'package:wealthnxai/domain/datasources/remote/stock/stock_remote_datasource.dart';
import 'package:wealthnxai/domain/repositories/stock_repository/stock_list_repository.dart';
import 'package:wealthnxai/domain/repositories/stock_repository/stock_detail_repoistory.dart';
import 'package:wealthnxai/domain/usecases/stock/get_stock_list_usecase.dart';
import 'package:wealthnxai/domain/usecases/stock/get_stock_detail_usecase.dart';
import 'package:wealthnxai/domain/usecases/stock/get_stock_graph_usecase.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/controller/stock_detail_controller.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/controller/stock_list_controller.dart';

class StockBinding extends Bindings {
  @override
  void dependencies() {
    // ── Stock List ─────────────────────────────────────────────────────────

    Get.lazyPut<StockListRemoteDataSource>(
          () => StockListRemoteDataSourceImpl(apiClient: Get.find()),
    );

    Get.lazyPut<StockListRepository>(
          () => StockListRepositoryImpl(remoteDataSource: Get.find()),
    );

    Get.lazyPut(
          () => GetStockListUseCase(repository: Get.find()),
    );

    Get.lazyPut(
          () => StockListController(getStockListUseCase: Get.find()),
    );

    // ── Stock Detail ───────────────────────────────────────────────────────
    // Note: StockDetailController is NOT registered here because it requires
    // a runtime `symbol` parameter. It is registered in the screen's initState.

    Get.lazyPut<StockDetailRemoteDataSource>(
          () => StockDetailRemoteDataSourceImpl(apiClient: Get.find()),
      fenix: true, // ✅ fenix keeps it alive for reuse across multiple stock detail screens
    );

    Get.lazyPut<StockDetailRepository>(
          () => StockDetailRepositoryImpl(
        remoteDataSource: Get.find<StockDetailRemoteDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
          () => GetStockDetailUseCase(
        repository: Get.find<StockDetailRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
          () => GetStockGraphUseCase(
        repository: Get.find<StockDetailRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut(() {
      final args = Get.arguments as Map<String, dynamic>? ?? {};
      final String symbol = args['symbol'] ?? '';
      return StockDetailController(
        getStockDetailUseCase: Get.find(),
        getStockGraphUseCase: Get.find(),
        symbol: symbol,
      );
    }, fenix: true);
  }
}