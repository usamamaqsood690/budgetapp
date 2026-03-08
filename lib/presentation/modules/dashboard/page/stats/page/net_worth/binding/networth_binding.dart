import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/data/datasources/remote/stats_remote_datasource_impl/networth_remote_datasource_impl/networth_remote_datasource_impl.dart';
import 'package:wealthnxai/data/repositories/stats_repository_impl/networth_repository_impl/networth_repository_impl.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_asset_summary_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_liabilities_summary_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_networth_detail_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_networth_pokemon_summary.dart';
import 'package:wealthnxai/domain/usecases/stats/networth/get_networth_summary_usecase.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/net_worth/controller/networth_controller.dart';

class NetWorthBinding extends Bindings {
  @override
  void dependencies() {
    // Data source
    final netWorthRemoteDataSource = NetWorthRemoteDataSourceImpl(
      apiClient: ApiClient.instance,
    );

    // Repository
    final netWorthRepository = NetWorthRepositoryImpl(
      remoteDataSource: netWorthRemoteDataSource,
      networkInfo: Get.find<NetworkInfo>(),
    );

    // Use cases
    final netWorthSummaryUseCase = NetWorthSummaryUseCase(
      repository: netWorthRepository,
    );
    final assetsSummaryUseCase = GetAssetsSummaryUseCase(
      repository: netWorthRepository,
    );
    final liabilitiesSummaryUseCase = GetLiabilitiesSummaryUseCase(
      repository: netWorthRepository,
    );
    final netWorthPokemonSummaryUseCase = GetNetWorthPokemonSummaryUseCase(
      repository: netWorthRepository,
    );
    final netWorthDetailUseCase = GetNetWorthDetailUseCase(
      repository: netWorthRepository,
    );

    // Controller
    Get.lazyPut<NetWorthController>(
      () => NetWorthController(
        netWorthSummaryUseCase: netWorthSummaryUseCase,
        getAssetsSummaryUseCase: assetsSummaryUseCase,
        getLiabilitiesSummaryUseCase: liabilitiesSummaryUseCase,
        getNetWorthPokemonSummaryUseCase: netWorthPokemonSummaryUseCase,
        getNetWorthDetailUseCase: netWorthDetailUseCase,
      ),
    );
  }
}