import 'package:get/get.dart';
import '../controller/add_budget_controller.dart';

class AddBudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBudgetController>(() => AddBudgetController());
  }
}
