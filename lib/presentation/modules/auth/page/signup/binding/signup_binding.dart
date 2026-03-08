/// Signup Binding - Dependency Injection
/// Creates and injects all dependencies for signup module
import 'package:get/get.dart';
import 'package:wealthnxai/domain/usecases/auth/complete_google_auth_usecase.dart';
import 'package:wealthnxai/presentation/modules/auth/binding/auth_binding.dart';
import 'package:wealthnxai/domain/repositories/auth_repository/auth_repository.dart';
import 'package:wealthnxai/domain/usecases/auth/apple_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/google_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/signup_sendotp_usecase.dart';
import 'package:wealthnxai/presentation/modules/auth/page/signup/controller/signup_page_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    AuthBindings.registerCommonDependencies();

    Get.lazyPut(() => SignupSendOtpUseCase(repository: Get.find<AuthRepository>()));
    Get.lazyPut(() => GoogleUseCase(repository: Get.find<AuthRepository>()),);
    Get.lazyPut(()=> AppleUseCase(repository: Get.find<AuthRepository>()));
    Get.lazyPut(()=> CompleteGoogleAuthUseCase(repository: Get.find<AuthRepository>()));

    Get.lazyPut(() =>  SignupController(signupSendOtpUseCase: Get.find<SignupSendOtpUseCase>(),
        googleSignUpUseCase:Get.find<GoogleUseCase>(),
        appleSignUpUseCase: Get.find<AppleUseCase>(), completeGoogleAuthUseCase: Get.find<CompleteGoogleAuthUseCase>(),),);
  }
}
