// lib/presentation/modules/investment/controller/investment_controller.dart

import 'package:get/get.dart';

class InvestmentController extends GetxController {
  final RxString selectedTab = 'Overview'.obs;

  final List<String> tabs = ['Overview', 'Crypto', 'Stocks'];

  void selectTab(String tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
  }
}