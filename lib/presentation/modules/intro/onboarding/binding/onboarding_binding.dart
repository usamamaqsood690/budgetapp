/// Onboarding Binding - Dependency Injection
/// Creates and injects all dependencies for onboarding module
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/intro/onboarding/controller/onboarding_page_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<onBoardingController>(() => onBoardingController());
  }
}
