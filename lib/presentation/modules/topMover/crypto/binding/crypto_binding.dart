// lib/presentation/modules/crypto/binding/crypto_binding.dart

import 'package:get/get.dart';
import 'package:wealthnxai/data/datasources/remote/crypto_remote_data_source/crypto_chart_remote_datasource_impl.dart';
import 'package:wealthnxai/data/datasources/remote/crypto_remote_data_source/crypto_remote_datasource_impl.dart';
import 'package:wealthnxai/data/repositories/crypto_repository_impl/crypto_chart_repository_impl.dart';
import 'package:wealthnxai/data/repositories/crypto_repository_impl/crypto_repository_impl.dart';
import 'package:wealthnxai/domain/datasources/remote/crypto/crypto_chart_remote_datasource.dart';
import 'package:wealthnxai/domain/datasources/remote/crypto/crypto_remote_datasource.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/crypto_repository/crypto_chart_repository.dart';
import 'package:wealthnxai/domain/repositories/crypto_repository/crypto_repository.dart';
import 'package:wealthnxai/domain/usecases/crypto/fetch_crypto_chart_usecase.dart';
import 'package:wealthnxai/domain/usecases/crypto/fetch_crypto_list_usecase.dart';
import 'package:wealthnxai/domain/usecases/crypto/fetch_crypto_profile_usecase.dart';
import 'package:wealthnxai/domain/usecases/crypto/search_crypto_usecase.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/controller/crypto_detail_controller.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/controller/crypto_list_controller.dart';

class CryptoBinding extends Bindings {
  @override
  void dependencies() {
    // ── Crypto List ────────────────────────────────────────────────────────
    Get.lazyPut<CryptoRemoteDataSource>(
          () => CryptoRemoteDataSourceImpl(apiClient: Get.find()),
    );
    Get.lazyPut<CryptoRepository>(
          () => CryptoRepositoryImpl(
        remoteDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
    );
    Get.lazyPut(() => FetchCryptoListUseCase(Get.find()));
    Get.lazyPut(() => SearchCryptoUseCase(Get.find()));
    Get.lazyPut(() => CryptoListController(), fenix: true);

    // ── Crypto Detail + Chart ──────────────────────────────────────────────
    Get.lazyPut<CryptoChartRemoteDataSource>(
          () => CryptoChartRemoteDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<CryptoChartRepository>(
          () => CryptoChartRepositoryImpl(
        remoteDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(
          () => FetchCryptoChartUseCase(Get.find()),
      fenix: true,
    );
    Get.lazyPut(
          () => FetchCryptoProfileUseCase(Get.find()),
      fenix: true,
    );
    Get.lazyPut(
          () => CryptoDetailController(),
      fenix: true,
    );
  }
}