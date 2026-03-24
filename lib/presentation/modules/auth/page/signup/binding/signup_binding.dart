import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/auth/page/signup/controller/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}
