import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/presentation/widgets/buttons/category_button.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/controller/crypto_list_controller.dart';

class CryptoTabBar extends StatelessWidget {
  final CryptoListController controller;

  const CryptoTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: CryptoTab.values.map((tab) => _buildTab(tab)).toList(),
      ),
    );
  }
  Widget _buildTab(CryptoTab tab) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == tab;
      return CategoryButton(
        text: controller.getTabTitle(tab),
        isActive: isSelected,

        onPressed: () => controller.selectTab(tab),
      );
    });
  }
}
