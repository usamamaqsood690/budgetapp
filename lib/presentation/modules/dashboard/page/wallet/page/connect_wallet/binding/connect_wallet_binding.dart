import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/connect_wallet/controller/connect_wallet_controller.dart';

/// Binding for Investments module
class ConnectWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConnectWalletController>(() => ConnectWalletController());
  }
}
