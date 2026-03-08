import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/auth/page/social_password_setup/controller/social_password_setup_controller.dart';

/// Binding for the social password setup screen.
///
/// Reads `email` and `name` from `Get.arguments` (a `Map`) that is passed
/// from the `LoginController.signInWithGoogle()` navigation call and
/// injects a single `SocialPasswordSetupController` instance.
class SocialPasswordSetupBinding extends Bindings {
 @override
  void dependencies() {
    // TODO: implement dependencies
   Get.lazyPut<SocialPasswordSetupController>(() => SocialPasswordSetupController());
  }
  }
