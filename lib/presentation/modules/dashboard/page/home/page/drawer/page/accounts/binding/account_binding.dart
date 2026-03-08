import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/binding/home_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/accounts/controller/account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    // Dashboard controller
    Get.lazyPut<AccountController>(() => AccountController());
    HomeBinding().dependencies();
  }
}