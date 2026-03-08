import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/controller/home_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/investment/controller/investment_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/controller/stats_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/binding/stats_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wealth_genie/controller/wealth_genie_controller.dart';

class DashboardController extends GetxController {
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure initial tab (0 = Home) controller is ready
    _loadModuleForIndex(selectedIndex.value);
  }

  void onItemTapped(int index) {
    // Ensure the module/controller for the target tab is ready
    // BEFORE we switch the selected index so the UI can safely call Get.find.
    _loadModuleForIndex(index);
    selectedIndex.value = index;
  }

  void _loadModuleForIndex(int index) {
    switch (index) {
      case 0:
        if (!Get.isRegistered<HomeController>()) {
          Get.lazyPut<HomeController>(() => HomeController());
        }
        debugPrint(
          'Dashboard: at tab 0 (Home)${!Get.isRegistered<HomeController>()}',
        );
        break;
      case 1:
        if (!Get.isRegistered<WealthGenieController>()) {
          Get.lazyPut<WealthGenieController>(() => WealthGenieController());
        }
        debugPrint(
          'Dashboard: at tab 1 (Wealth Genie) ${!Get.isRegistered<WealthGenieController>()}',
        );
        break;
      case 2:
        if (!Get.isRegistered<StatsController>()) {
         StatsBinding().dependencies();
        }
        debugPrint(
          'Dashboard: at tab 2 (Stats)${!Get.isRegistered<StatsController>()}',
        );
        break;
      case 3:
        if (!Get.isRegistered<InvestmentController>()) {
          Get.lazyPut<InvestmentController>(() => InvestmentController());
        }
        debugPrint(
          'Dashboard: at tab 3 (Investments)${!Get.isRegistered<InvestmentController>()}',
        );
        break;
    }
  }

  void goToHome() => onItemTapped(0);
  void goToWealthGenie() => onItemTapped(1);
  void goToStats() => onItemTapped(2);
  void goToInvestments() => onItemTapped(3);
}
