// lib/presentation/widgets/toggle_button/toggle_btn_controller.dart

import 'package:get/get.dart';

class ToggleBtnController extends GetxController {
  final RxBool isDemo = true.obs;

  void toggle(bool value) {
    isDemo.value = value;
  }
}