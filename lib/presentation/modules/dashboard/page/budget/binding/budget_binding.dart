import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/budget/controller/budget_controller.dart';

/// Binding for Budget module
class BudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BudgetController>(() => BudgetController());
  }
}
