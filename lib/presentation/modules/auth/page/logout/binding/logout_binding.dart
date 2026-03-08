import 'package:get/get.dart';
import 'package:wealthnxai/domain/repositories/auth_repository/auth_repository.dart';
import 'package:wealthnxai/domain/usecases/drawer/logout_usercase.dart';
import 'package:wealthnxai/presentation/modules/auth/binding/auth_binding.dart';
import 'package:wealthnxai/presentation/modules/auth/page/logout/controller/logout_controller.dart';

/// Logout Binding - sets up dependencies needed for logout flow
class LogoutBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure shared auth dependencies are registered
    AuthBindings.registerCommonDependencies();

    // Use case
    Get.lazyPut(() => LogoutUseCase(repository: Get.find<AuthRepository>()));

    // Controller
    Get.lazyPut(
      () => LogoutController(logoutUseCase: Get.find<LogoutUseCase>()),
    );
  }
}
