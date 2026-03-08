import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/data/datasources/remote/drawer_remote_datasource/account_remote_datasource_impl/account_remote_datasource_impl.dart';
import 'package:wealthnxai/data/repositories/drawer_repository_impl/account_repository_impl/account_repository_impl.dart';
import 'package:wealthnxai/domain/datasources/remote/drawer_remote_datasource/account_remote_datasource/account_remote_datasource.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/drawer_repository/account_repository/account_repository.dart';
import 'package:wealthnxai/presentation/modules/dashboard/controller/plaid_connection_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/binding/home_binding.dart';
import '../controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Dashboard controller

    Get.lazyPut<DashboardController>(() => DashboardController());

    // Repository - Depends on AuthRemoteDataSource and NetworkInfo
    Get.lazyPut<PlaidAccountRemoteDataSource>(
          () => PlaidRemoteDataSourceImpl(
          apiClient: Get.find<ApiClient>()
      ),
    );
    Get.lazyPut<PlaidAccountRepository>(
          () => PlaidAccountRepositoryImpl(
        remoteDataSource: Get.find<PlaidAccountRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );

    Get.lazyPut<PlaidConnectionController>(
          () => PlaidConnectionController(
        repository: Get.find<PlaidAccountRepository>(),
      ),
    );

    HomeBinding().dependencies();

  }
}