import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/domain/repositories/auth_repository/auth_repository.dart';
import 'package:wealthnxai/domain/usecases/auth/send_recover_account_otp_usecase.dart';
import 'package:wealthnxai/domain/usecases/drawer/delete_account_usecase.dart';
import 'package:wealthnxai/presentation/modules/auth/binding/auth_binding.dart';
import 'package:wealthnxai/presentation/modules/auth/page/recover_account/controller/recover_account_controller.dart';

/// Recover Account Binding - Dependency Injection
/// Creates and injects all dependencies for recover account module.
class RecoverAccountBinding extends Bindings {
  RecoverAccountBinding({required this.accountType});

  final AccountType accountType;

  @override
  void dependencies() {
    AuthBindings.registerCommonDependencies();

    // Use Cases
    Get.lazyPut(
      () => RecoverAccountOtpUseCase(repository: Get.find<AuthRepository>()),
    );
    
    Get.lazyPut(
      () => DeleteAccountOtpUseCase(repository: Get.find<AuthRepository>()),
    );

    // Controller
    Get.lazyPut(
      () => RecoverAccountController(
        recoverAccountOtpUseCase: Get.find<RecoverAccountOtpUseCase>(),
        accountType: accountType,
        deleteAccountOtpUseCase: Get.find<DeleteAccountOtpUseCase>(),
      ),
    );
  }
}

