import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/profile/controller/profile_controller.dart';

/// Binding for Investments module
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
