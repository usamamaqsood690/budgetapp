import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/bill_payment_receipt_page/controller/bill_payment_receipt_controller.dart';

class BillPaymentReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BillPaymentReceiptController());
  }
}
