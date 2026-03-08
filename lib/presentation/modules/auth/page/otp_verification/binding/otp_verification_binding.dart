/// OTP Verification Binding - Dependency Injection
/// Creates and injects all dependencies for OTP verification module
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/auth/binding/auth_binding.dart';
import 'package:wealthnxai/domain/repositories/auth_repository/auth_repository.dart';
import 'package:wealthnxai/domain/usecases/auth/register_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:wealthnxai/presentation/modules/auth/page/otp_verification/controller/otp_verification_page_controller.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    AuthBindings.registerCommonDependencies();

    // Use Cases
    Get.put<VerifyOtpUseCase>(
      VerifyOtpUseCase(repository: Get.find<AuthRepository>()),
    );
    Get.put<RegisterUseCase>(
      RegisterUseCase(repository: Get.find<AuthRepository>()),
    );

    // Controller
    Get.put(
      OtpVerificationController(
        verifyOtpUseCase: Get.find<VerifyOtpUseCase>(),
        registerUseCase: Get.find<RegisterUseCase>(),
      ),
    );
  }
}
