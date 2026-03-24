import 'package:get/get.dart';

class StatsController extends GetxController {
  var stats = <String, dynamic>{}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  void loadStats() {
    isLoading.value = true;
    try {
      // Add your stats loading logic here
      stats.value = {};
    } finally {
      isLoading.value = false;
    }
  }
}
