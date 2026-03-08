import 'package:get/get.dart';

import '../controller/wealth_genie_controller.dart';

/// Binding for Wealth Genie module
class WealthGenieBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WealthGenieController>(() => WealthGenieController());
  }
}

