import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/data/datasources/remote/stats_remote_datasource_impl/transaction_remote_datasource_impl/transaction_remote_datasource_impl.dart';
import 'package:wealthnxai/data/repositories/stats_repository_impl/transaction_repository_impl/transaction_repository_impl.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/usecases/stats/transaction/get_all_transaction_usecase.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/controller/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    // ApiClient is already provided in InitialBinding
    final apiClient = Get.find<ApiClient>();
    final networkInfo = Get.find<NetworkInfo>();

    final remoteDataSource = TransactionRemoteDataSourceImpl(apiClient: apiClient);
    final repository = TransactionRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final useCase = GetAllTransactionUseCase(repository: repository);

    Get.lazyPut<TransactionsController>(
      () => TransactionsController(getAllTransactionUseCase: useCase),
    );
  }
}

