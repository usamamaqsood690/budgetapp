/// News Binding - Dependency Injection
/// Located in: lib/presentation/modules/news/binding/news_binding.dart

import 'package:get/get.dart';
import 'package:wealthnxai/data/datasources/remote/news_remote_data_source.dart';
import 'package:wealthnxai/data/network/network_info_impl.dart';
import 'package:wealthnxai/data/repositories/news_repository_impl/news_repository_impl.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/news_repository/news_repository.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl.instance, fenix: true);
    // Data Source
    Get.lazyPut<NewsRemoteDataSource>(
          () => NewsRemoteDataSourceImpl(),
      fenix: true,
    );

    // Repository (with NetworkInfo)
    Get.lazyPut<NewsRepository>(
          () => NewsRepositoryImpl(
        remoteDataSource: Get.find<NewsRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Controller
    Get.put<NewsController>(NewsController(), permanent: true);
  }
}
