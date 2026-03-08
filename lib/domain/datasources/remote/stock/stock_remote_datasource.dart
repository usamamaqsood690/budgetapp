import 'package:wealthnxai/data/models/stock/stock_list_model.dart';
import 'package:wealthnxai/domain/usecases/stock/stock_list_params.dart';

abstract class StockListRemoteDataSource {
  Future<List<StockItemModel>> getStockList(StockListParams params);

}