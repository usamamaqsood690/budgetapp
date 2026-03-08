/// Login Binding - Dependency Injection
/// Creates and injects all dependencies for login module
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/auth/binding/auth_binding.dart';
import 'package:wealthnxai/domain/repositories/auth_repository/auth_repository.dart';
import 'package:wealthnxai/domain/usecases/auth/apple_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/complete_google_auth_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/google_usecase.dart';
import 'package:wealthnxai/domain/usecases/auth/login_usecase.dart';
import 'package:wealthnxai/presentation/modules/auth/page/login/controller/login_page_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    AuthBindings.registerCommonDependencies();

    Get.lazyPut(() => LoginUseCase(repository: Get.find<AuthRepository>()));
    Get.lazyPut(() => GoogleUseCase(repository: Get.find<AuthRepository>()));
    Get.lazyPut(
      () => CompleteGoogleAuthUseCase(repository: Get.find<AuthRepository>()),
    );
    Get.lazyPut(() => AppleUseCase(repository: Get.find<AuthRepository>()));

    Get.lazyPut(
      () => LoginController(
        loginUseCase: Get.find<LoginUseCase>(),
        googleSignInUseCase: Get.find<GoogleUseCase>(),
        completeGoogleAuthUseCase: Get.find<CompleteGoogleAuthUseCase>(),
        appleSignInUseCase: Get.find<AppleUseCase>(),
      ),
    );
  }
}
