/// Forgot Password Binding - Dependency Injection
/// Creates and injects all dependencies for forgot password module
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/auth/binding/auth_binding.dart';
import 'package:wealthnxai/domain/repositories/auth_repository/auth_repository.dart';
import 'package:wealthnxai/domain/usecases/auth/forget_password_sendotp_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/signup_sendotp_usecase.dart';
import 'package:wealthnxai/presentation/modules/auth/page/forgot_password/controller/forgot_password_page_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    AuthBindings.registerCommonDependencies();
    // Use Case
    Get.lazyPut(
      () => SignupSendOtpUseCase(repository: Get.find<AuthRepository>()),
    );
    Get.lazyPut(()=> ForgetPasswordSendOtpUseCase(repository: Get.find<AuthRepository>()));

    // Controller
    Get.lazyPut(
      () => ForgotPasswordController(
        forgotPasswordSendOtpUseCase: Get.find<ForgetPasswordSendOtpUseCase>(),
      ),
    );
  }
}
