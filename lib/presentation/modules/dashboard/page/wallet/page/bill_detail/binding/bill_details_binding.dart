import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/bill_detail/controller/bill_details_controller.dart';

/// Binding for Investments module
class BillDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BillDetailController>(() => BillDetailController());
  }
}
