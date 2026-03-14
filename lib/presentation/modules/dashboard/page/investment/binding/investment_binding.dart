import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/investment/controller/investment_controller.dart';

/// Binding for Investments module
class InvestmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestmentController>(() => InvestmentController());
  }
}
