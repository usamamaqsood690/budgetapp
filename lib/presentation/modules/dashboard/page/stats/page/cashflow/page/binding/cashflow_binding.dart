import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/data/datasources/remote/stats_remote_datasource_impl/cashflow_remote_datasource_impl/cashflow_remote_datasource_impl.dart';
import 'package:wealthnxai/data/repositories/stats_repository_impl/cashflow_repository_impl/cashflow_repository_impl.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_cashflow_detail_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_cashflow_pokemon_summery_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_cashflow_summery_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_expense_summary_usecase.dart';
import 'package:wealthnxai/domain/usecases/stats/cashflow/get_income_summary_usecase.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/cashflow/page/controller/cashflow_controller.dart';

class CashFlowBinding extends Bindings {
  @override
  void dependencies() {
    // Data source
    final cashFlowRemoteDataSource = CashFlowRemoteDataSourceImpl(
      apiClient: ApiClient.instance,
    );

    // Repository
    final cashFlowRepository = CashFlowRepositoryImpl(
      remoteDataSource: cashFlowRemoteDataSource, networkInfo: Get.find<NetworkInfo>(),
    );

    // Use case
    final getIncomeSummaryUseCase = GetIncomeSummaryUseCase(
      repository: cashFlowRepository,
    );
    final getExpenseSummaryUseCase = GetExpenseSummaryUseCase(
      repository: cashFlowRepository,
    );
    final getCashFlowSummaryUseCase = GetCashFlowSummaryUseCase(
      repository: cashFlowRepository,
    );
    final getCashFlowPokemonSummaryUseCase = GetCashFlowPokemonSummaryUseCase(
      repository: cashFlowRepository,
    );
    final getCashFlowDetailUseCase = GetCashFlowDetailUseCase(
      repository: cashFlowRepository,
    );

    //Controller
    Get.lazyPut(
          () => CashFlowController(
            getIncomeSummaryUseCase: getIncomeSummaryUseCase, getExpenseSummaryUseCase: getExpenseSummaryUseCase, getCashFLowSummaryUseCase: getCashFlowSummaryUseCase, getCashFlowPokemonSummaryUseCase: getCashFlowPokemonSummaryUseCase, getCashFlowDetailUseCase: getCashFlowDetailUseCase,
      ),
    );
  }
}