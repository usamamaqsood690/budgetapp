import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/page/email_password_authentication/controller/email_password_authentication_controller.dart';

class EmailPasswordAuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailPasswordAuthenticationController>(
      () => EmailPasswordAuthenticationController(),
    );
  }
}

