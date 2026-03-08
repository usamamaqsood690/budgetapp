
import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/data/datasources/remote/stats_remote_datasource_impl/budget_remote_datasource_impl/budget_remote_datasource_impl.dart';
import 'package:wealthnxai/data/repositories/stats_repository_impl/budget_repository_impl/budget_repository_impl.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/usecases/stats/budget/get_budget_usecase.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/budgets/controller/budget_controller.dart';

class BudgetBinding extends Bindings {
  @override
  void dependencies() {
    final budgetRemoteDataSource = BudgetRemoteDataSourceImpl(
      apiClient: ApiClient.instance,
    );

    final budgetRepository = BudgetRepositoryImpl(
      remoteDataSource: budgetRemoteDataSource,
      networkInfo: Get.find<NetworkInfo>(),
    );

    final getBudgetUseCase = GetBudgetUseCase(repository: budgetRepository);

    Get.lazyPut<BudgetController>(
      () => BudgetController(getBudgetUseCase: getBudgetUseCase),
    );
  }
}