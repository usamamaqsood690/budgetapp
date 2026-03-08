import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/presentation/modules/topMover/widget/topmover_chart_interface.dart';

class StockChartTabs extends StatelessWidget {
  const StockChartTabs({super.key, required this.controller});

  final TopMoverChartInterface controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TimeTab(title: '1 D', controller: controller),
        _TimeTab(title: '7 D', controller: controller),
        _TimeTab(title: '1 M', controller: controller),
        _TimeTab(title: '6 M', controller: controller),
        _TimeTab(title: '1 Y', controller: controller),
        _TimeTab(title: 'YTD', controller: controller),
        _ModeTab(mode: ChartMode.line, controller: controller),
        _ModeTab(mode: ChartMode.candle, controller: controller),
      ],
    );
  }
}

// ─── Time Tab ──────────────────────────────────────────────────────────────

class _TimeTab extends StatelessWidget {
  const _TimeTab({required this.title, required this.controller});

  final String title;
  final TopMoverChartInterface controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedRange.value == title;
      return GestureDetector(
        onTap: () => controller.setRange(title),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF313131) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w400 : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }
}

// ─── Mode Tab ──────────────────────────────────────────────────────────────

class _ModeTab extends StatelessWidget {
  const _ModeTab({required this.mode, required this.controller});

  final ChartMode mode;
  final TopMoverChartInterface controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.chartMode.value == mode;
      return GestureDetector(
        onTap: () => controller.setMode(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF313131) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: mode == ChartMode.line
              ? Image.asset(
            ImagePaths.line_graph,
            width: 18,
            height: 18,
            color: isSelected ? Colors.white : Colors.grey,
          )
              : Icon(
            Icons.candlestick_chart,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      );
    });
  }
}