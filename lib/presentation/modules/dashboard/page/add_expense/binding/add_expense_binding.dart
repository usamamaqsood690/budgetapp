import 'package:get/get.dart';

import '../controller/add_expense_controller.dart';

/// Binding for Wealth Genie module
class AddExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddExpenseController>(() => AddExpenseController());
  }
}
