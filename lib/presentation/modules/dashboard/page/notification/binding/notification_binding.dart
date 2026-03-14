import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/notification/controller/notification_controller.dart';

/// Binding for Investments module
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}
