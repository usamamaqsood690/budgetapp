import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/detail_transaction_page/controller/detail_transaction_controller.dart';

class DetailTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailTransactionController());
  }
}
