import 'package:get/get.dart';
import 'package:wealthnxai/domain/usecases/drawer/change_password_usecase.dart';
import 'package:wealthnxai/presentation/modules/auth/binding/auth_binding.dart';
import 'package:wealthnxai/domain/repositories/auth_repository/auth_repository.dart';
import 'package:wealthnxai/domain/usecases/auth/set_new_password_usecase.dart';
import 'package:wealthnxai/presentation/modules/auth/page/change_password/controller/change_password_page_controller.dart';

/// Change Password Binding - Dependency Injection
class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure common auth dependencies are registered
    AuthBindings.registerCommonDependencies();

    // Use case
    Get.lazyPut(
      () => NewPasswordUseCase(repository: Get.find<AuthRepository>()),
    );
    Get.lazyPut(
      () => ChangePasswordUseCase(repository: Get.find<AuthRepository>()),
    );

    // Controller
    Get.lazyPut(
      () => ChangePasswordController(
        newPasswordUseCase: Get.find<NewPasswordUseCase>(),
        changePasswordUseCase: Get.find<ChangePasswordUseCase>(),
      ),
    );
  }
}
