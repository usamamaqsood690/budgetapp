import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/controller/authentication_controller.dart';

class AuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticationPageController>(() => AuthenticationPageController());
  }
}