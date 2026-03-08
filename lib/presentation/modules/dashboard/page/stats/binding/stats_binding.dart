import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/data/datasources/remote/stats_remote_datasource_impl/cashflow_remote_datasource_impl/cashflow_remote_datasource_impl.dart';
import 'package:wealthnxai/data/datasources/remote/stats_remote_datasource_impl/networth_remote_datasource_impl/networth_remote_datasource_impl.dart';
import 'package:wealthnxai/data/datasources/remote/stats_remote_datasource_impl/stats_remote_datasource_impl.dart';
import 'package:wealthnxai/data/repositories/stats_repository_impl/cashflow_repository_impl/cashflow_repository_impl.dart';
import 'package:wealthnxai/data/repositories/stats_repository_impl/networth_repository_impl/networth_repository_impl.dart';
import 'package:wealthnxai/data/repositories/stats_repository_impl/stats_repository_impl.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/stats_repository.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_cashflow_summery_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_networth_summary_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/stats_main_usecase.dart';

import '../controller/stats_controller.dart';

/// Binding for Stats module
class StatsBinding extends Bindings {
  @override
  void dependencies() {
    // ApiClient is already provided in InitialBinding
    final apiClient = Get.find<ApiClient>();

    final remoteDataSource = StatsRemoteDataSourceImpl(apiClient: apiClient);

    final netWorthRemoteData = NetWorthRemoteDataSourceImpl(apiClient: apiClient);

    final cashFlowRemoteData = CashFlowRemoteDataSourceImpl(apiClient: apiClient);

    final repository = StatsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: Get.find<NetworkInfo>(),
    );
    final netWorthRepo = NetWorthRepositoryImpl(
      remoteDataSource: netWorthRemoteData,
      networkInfo: Get.find<NetworkInfo>(),
    );
    final cashFlowRepo = CashFlowRepositoryImpl(
      remoteDataSource: cashFlowRemoteData,
      networkInfo: Get.find<NetworkInfo>(),
    );

    final useCase = GetMainStatsUseCase(repository: repository);
    final netWorthUseCase = NetWorthSummaryUseCase(repository: netWorthRepo);
    final cashFlowUseCase = GetCashFlowSummaryUseCase(repository: cashFlowRepo);


    Get.lazyPut<StatsController>(() => StatsController(getMainStatsUseCase: useCase, netWorthSummaryUseCase: netWorthUseCase,getCashFlowSummaryUseCase: cashFlowUseCase));
  }
}

