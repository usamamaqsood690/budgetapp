import 'package:get/get.dart';
import '../controller/recent_expense_controller.dart';

class RecentExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecentExpenseController>(() => RecentExpenseController());
  }
}
