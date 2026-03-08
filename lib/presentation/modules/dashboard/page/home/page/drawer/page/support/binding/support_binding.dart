import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/support/controller/support_controller.dart';

/// SupportBinding - DI for SupportPage
class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportPageController>(() => SupportPageController());
  }
}

