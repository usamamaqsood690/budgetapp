import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/bill_payment/controller/bill_payment_controller.dart';

/// Binding for Investments module
class BillPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BillPaymentController>(() => BillPaymentController());
  }
}
