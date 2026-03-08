import 'package:get/get.dart';

/// SupportPageController
class SupportPageController extends GetxController {
  /// Whether to show the "Recover Account" option.
  final RxBool isShowRecoverEmail = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['isShowRecoverEmail'] is bool) {
      isShowRecoverEmail.value = args['isShowRecoverEmail'] as bool;
    }
  }
}
