import 'package:get/get.dart';
import '../controller/category_budget_controller.dart';

class CategoryBudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryBudgetController>(() => CategoryBudgetController());
  }
}
