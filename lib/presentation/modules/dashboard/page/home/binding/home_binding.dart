/// Home Binding - Dependency Injection
/// Creates and injects all dependencies for home module
import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/data/datasources/remote/drawer_remote_datasource/account_remote_datasource_impl/account_remote_datasource_impl.dart';
import 'package:wealthnxai/data/repositories/drawer_repository_impl/account_repository_impl/account_repository_impl.dart';
import 'package:wealthnxai/domain/datasources/remote/drawer_remote_datasource/account_remote_datasource/account_remote_datasource.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/drawer_repository/account_repository/account_repository.dart';
import 'package:wealthnxai/presentation/modules/dashboard/controller/plaid_connection_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/controller/home_controller.dart';
import 'package:wealthnxai/presentation/modules/news/binding/news_binding.dart';
import 'package:wealthnxai/presentation/modules/schedule/binding/schedule_binding.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/binding/crypto_binding.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/binding/stock_binding.dart';

/// Home Binding - creates HomeController
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    NewsBinding().dependencies();
    CryptoBinding().dependencies();
    StockBinding().dependencies();
    ScheduleBinding().dependencies();
  }
}