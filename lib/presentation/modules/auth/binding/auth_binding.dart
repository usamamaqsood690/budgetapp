/// Core Bindings - Shared Dependency Injection
///
/// This file contains common dependencies that are used across multiple modules.
/// Instead of duplicating the same dependency setup in each binding, we centralize
/// them here for better maintainability and consistency.
import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/data/datasources/remote/auth_remote_datasource_impl/auth_remote_datasource_impl.dart';
import 'package:wealthnxai/data/network/network_info_impl.dart';
import 'package:wealthnxai/data/repositories/auth_repository_impl/auth_repository_impl.dart';
import 'package:wealthnxai/domain/datasources/remote/auth_remote_datasource/auth_remote_datasource.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/auth_repository/auth_repository.dart';
class AuthBindings {

  static void registerCommonDependencies() {
    // Network Info - Singleton instance
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl.instance, fenix: true);

    // Data Source - Depends on ApiClient (already registered in InitialBinding)
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiClient: ApiClient.instance),
    );

    // Repository - Depends on AuthRemoteDataSource and NetworkInfo
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
  }
}
