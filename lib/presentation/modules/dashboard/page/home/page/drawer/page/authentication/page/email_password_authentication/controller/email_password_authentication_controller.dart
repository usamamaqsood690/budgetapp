import 'package:get/get.dart';

class EmailPasswordAuthenticationController extends GetxController {
  /// When true, both email and password authentication are enabled.
  final RxBool bothEnabled = false.obs;

  /// Email-based authentication toggle.
  final RxBool emailEnabled = true.obs;

  /// Password-based authentication toggle.
  final RxBool passwordEnabled = true.obs;

  /// Toggle "Both Email & Password Authentication".
  void toggleBoth(bool value) {
    bothEnabled.value = value;

    if (value) {
      // If both are enabled, force email & password to ON.
      emailEnabled.value = true;
      passwordEnabled.value = true;
    }
  }

  /// Toggle "Email Authentication".
  void toggleEmail(bool value) {
    emailEnabled.value = value;
    _syncBothSwitch();
  }

  /// Toggle "Password Authentication".
  void togglePassword(bool value) {
    passwordEnabled.value = value;
    _syncBothSwitch();
  }

  /// Keep the "bothEnabled" switch in sync with the two individual switches.
  void _syncBothSwitch() {
    bothEnabled.value = emailEnabled.value && passwordEnabled.value;
  }
}

