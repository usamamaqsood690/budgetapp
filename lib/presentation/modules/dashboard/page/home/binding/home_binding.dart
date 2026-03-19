import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/controller/home_controller.dart';

/// Home Binding - creates HomeController
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
