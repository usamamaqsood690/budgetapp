import 'package:get/get.dart';

import '../controller/wallet_controller.dart';

/// Binding for Investments module
class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(() => WalletController());
  }
}
