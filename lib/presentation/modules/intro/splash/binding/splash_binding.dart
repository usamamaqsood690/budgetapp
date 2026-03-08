/// Splash Binding - Dependency Injection
/// Creates and injects all dependencies for splash module
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/intro/splash/controller/splash_page_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
