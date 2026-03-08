// lib/presentation/modules/crypto/widget/crypto_chart_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:k_chart_plus_deeping/chart_style.dart';
import 'package:k_chart_plus_deeping/k_chart_widget.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/controller/crypto_detail_controller.dart';

import 'line_chart_info_dialogue.dart';

// ─── Main Chart Widget ────────────────────────────────────────────────────────

class CryptoCandleChartView extends StatelessWidget {
  const CryptoCandleChartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CryptoDetailController>();

    return Obx(() {
      if (controller.isChartLoading.value && controller.chartData.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF2EADA5)),
        );
      }
      if (controller.chartData.isEmpty) {
        return const Center(
          child: Text('No chart data', style: TextStyle(color: Colors.grey)),
        );
      }

      return Stack(
        children: [
          controller.isChartFit.value
              ? _FitChart(controller: controller)
              : _ZoomChart(controller: controller),

          // ── Side buttons: fullscreen + zoom toggle ──────────────────────
          Positioned(
            top: 10,
            left: 2,
            child: Column(
              children: [
                _ChartIconButton(
                  assetPath: ImagePaths.landscape_view,
                  onTap: () => Get.to(() => const CryptoFullScreenChartPage()),
                ),
                AppSpacing.addHeight(8),
                Obx(() => _ChartIconButton(
                  assetPath: controller.isChartFit.value
                      ? ImagePaths.zoom_in
                      : ImagePaths.zoom_out,
                  onTap: () => controller.isChartFit.toggle(),
                )),
              ],
            ),
          ),
        ],
      );
    });
  }
}

// ─── Fit Chart ────────────────────────────────────────────────────────────────

class _FitChart extends StatelessWidget {
  const _FitChart({required this.controller});
  final CryptoDetailController controller;

  static const Map<String, List<double>> _widthRanges = {
    '1 D': [0.5, 8.0],
    '7 D': [6.0, 8.0],
    '1 M': [1.7, 8.0],
    '6 M': [5.0, 8.0],
    '1 Y': [3.0, 8.0],
    'YTD': [0.2, 8.0],
  };

  static const Map<String, double> _scaleFactors = {
    '1 D': 0.8,
    '7 D': 0.8,
    '1 M': 0.6,
    '6 M': 0.7,
    '1 Y': 0.5,
    'YTD': 0.5,
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final int dataLength = controller.chartData.length;
      final double available = constraints.maxWidth - 20;
      final double scale = _scaleFactors[controller.selectedRange.value] ?? 0.5;
      double calcWidth = (available / dataLength).clamp(0.5, 10.0) * scale;

      final clamp = _widthRanges[controller.selectedRange.value] ?? [3.0, 8.0];
      final double pointWidth = calcWidth.clamp(clamp[0], clamp[1]);

      final style = ChartStyle()
        ..pointWidth = pointWidth
        ..candleWidth = pointWidth
        ..dateTimeFormat = controller.chartDateFormat;

      return Obx(() {
        if (controller.chartMode.value == ChartMode.line) {
          return Stack(children: [
            GestureDetector(
              onTapUp: (details) {
                final box = context.findRenderObject() as RenderBox?;
                if (box == null) return;
                final local = box.globalToLocal(details.globalPosition);
                final index = (local.dx / pointWidth)
                    .round()
                    .clamp(0, dataLength - 1);
                if (index < controller.chartData.length) {
                  controller.selectCandle(controller.chartData[index]);
                }
              },
              child: KChartWidget(
                controller.chartData, style, _chartColors(),
                isLine: true, isTrendLine: false, volHidden: true,
                isTapShowInfoDialog: false, hideGrid: false,
                timeFormat: TimeFormat.yearMONTHDAY,
              ),
            ),
            Obx(() {
              final candle = controller.selectedCandle.value;
              if (candle == null) return const SizedBox.shrink();
              return Positioned(
                top: 25, left: 10,
                child: LineChartInfoDialog(
                  entity: candle,
                  width: MediaQuery.of(context).size.width / 3,
                ),
              );
            }),
          ]);
        }

        return KChartWidget(
          controller.chartData, style, _chartColors(),
          isLine: false, isTrendLine: false, volHidden: true,
          isTapShowInfoDialog: true, hideGrid: false,
          timeFormat: TimeFormat.yearMONTHDAY,
        );
      });
    });
  }
}

// ─── Zoom Chart ───────────────────────────────────────────────────────────────

class _ZoomChart extends StatelessWidget {
  const _ZoomChart({required this.controller});
  final CryptoDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final style = ChartStyle()
        ..dateTimeFormat = controller.chartDateFormat;
      return KChartWidget(
        controller.chartData, style, _chartColors(),
        isLine: controller.chartMode.value == ChartMode.line,
        isTrendLine: false, volHidden: true,
        isTapShowInfoDialog: controller.chartMode.value == ChartMode.candle,
        hideGrid: false, timeFormat: TimeFormat.yearMONTHDAY,
      );
    });
  }
}

// ─── Chart Tab Bar ────────────────────────────────────────────────────────────

class CryptoChartTabs extends StatelessWidget {
  const CryptoChartTabs({super.key, required this.controller});
  final CryptoDetailController controller;

  static const List<String> _ranges = ['1 D', '7 D', '1 M', '6 M', '1 Y', 'YTD'];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final range in _ranges)
          _RangeTab(
            label: range,
            selected: controller.selectedRange.value == range,
            onTap: () => controller.setRange(range),
          ),
        _ModeTab(
          mode: ChartMode.line,
          current: controller.chartMode.value,
          onTap: () => controller.setMode(ChartMode.line),
        ),
        _ModeTab(
          mode: ChartMode.candle,
          current: controller.chartMode.value,
          onTap: () => controller.setMode(ChartMode.candle),
        ),
      ],
    ));
  }
}

// ─── Full Screen Chart Page ───────────────────────────────────────────────────

class CryptoFullScreenChartPage extends StatefulWidget {
  const CryptoFullScreenChartPage({super.key});

  @override
  State<CryptoFullScreenChartPage> createState() =>
      _CryptoFullScreenChartPageState();
}

class _CryptoFullScreenChartPageState
    extends State<CryptoFullScreenChartPage> {
  final controller = Get.find<CryptoDetailController>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          final style = ChartStyle()
            ..dateTimeFormat = controller.chartDateFormat;
          final colors = ChartColors(
            hCrossColor: Colors.white.withOpacity(0.4),
            bgColor: Colors.black,
            gridColor: Colors.white.withOpacity(0.1),
            kLineColor: const Color(0xFF2EADA5),
            lineFillColor: const Color(0xFF2EADA5).withOpacity(0.3),
            crossTextColor: Colors.white,
            selectFillColor: Colors.black,
            selectBorderColor: Colors.grey.withOpacity(0.4),
            infoWindowTitleColor: Colors.white,
            infoWindowNormalColor: Colors.white,
            infoWindowUpColor: const Color(0xFF2EADA5),
            infoWindowDnColor: const Color(0xFFD5405D),
            sizeText: 11,
            maxColor: Colors.transparent,
            minColor: Colors.transparent,
          );

          return Stack(children: [
            KChartWidget(
              controller.chartData, style, colors,
              isLine: controller.chartMode.value == ChartMode.line,
              isTrendLine: false, volHidden: true,
              isTapShowInfoDialog: true, hideGrid: false,
              timeFormat: TimeFormat.yearMONTHDAY,
            ),
            Positioned(
              top: 10, right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: Get.back,
              ),
            ),
          ]);
        }),
      ),
    );
  }
}

// ─── Private helpers ──────────────────────────────────────────────────────────

ChartColors _chartColors() => ChartColors(
  hCrossColor: Colors.white.withOpacity(0.4),
  bgColor: Colors.transparent,
  gridColor: Colors.transparent,
  kLineColor: const Color(0xFF2EADA5),
  lineFillColor: const Color(0xFF2EADA5).withOpacity(0.3),
  crossTextColor: Colors.white,
  selectFillColor: Colors.black,
  selectBorderColor: Colors.grey.withOpacity(0.4),
  infoWindowTitleColor: Colors.white,
  infoWindowNormalColor: Colors.white,
  infoWindowUpColor: const Color(0xFF2EADA5),
  infoWindowDnColor: const Color(0xFFD5405D),
  sizeText: 11,
  maxColor: Colors.transparent,
  minColor: Colors.transparent,
);

class _RangeTab extends StatelessWidget {
  const _RangeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF313131) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w400 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.mode,
    required this.current,
    required this.onTap,
  });
  final ChartMode mode;
  final ChartMode current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool selected = mode == current;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF313131) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: mode == ChartMode.line
            ? Image.asset(
          ImagePaths.line_graph, width: 18, height: 18,
          color: selected ? Colors.white : Colors.grey,
        )
            : Icon(
          Icons.candlestick_chart, size: 16,
          color: selected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}

class _ChartIconButton extends StatelessWidget {
  const _ChartIconButton({required this.assetPath, required this.onTap});
  final String assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          assetPath, width: 18, height: 18,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
}