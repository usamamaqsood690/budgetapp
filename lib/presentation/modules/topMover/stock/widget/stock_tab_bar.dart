import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/controller/stock_list_controller.dart';

class StockTabBar extends StatelessWidget {
  final StockListController controller;

  const StockTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: StockTab.values.map((tab) => _buildTab(tab)).toList(),
      ),
    );
  }

  Widget _buildTab(StockTab tab) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == tab;

      return GestureDetector(
        onTap: () => controller.selectTab(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(46, 173, 165, 1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isSelected
                  ? const Color.fromRGBO(46, 173, 165, 1)
                  : Colors.grey,
              width: 0.5,
            ),
          ),
          child: Text(
            controller.getTabTitle(tab),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }
}