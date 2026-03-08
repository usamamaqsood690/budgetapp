import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/controller/stats_controller.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';

class CashFlowSummeryCard extends GetView<StatsController> {
  const CashFlowSummeryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF072B28), width: 0.5),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This month',
            style: TextStyle(
              color: Color(0xFF5A6570),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            'Cash Flow',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() =>
                  FormattedNumberText(
                    value:   controller.statsModel.value?.body.cashflow.cashflow ?? 0.0,
                    showSign: true,
                    style:  context.textTheme.bodyLarge,
                  ),),
              FormattedNumberText(
                value:controller.statsModel.value?.body.cashflow.cashflowPercentChange ?? 0.0,
                hint: NumberHint.percentChange,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Line Chart with proper clipping
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(height: 80, child: _buildLineChart()),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return Obx(() {
      if (controller.isCashFlowChartLoading.value) {
        return const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      }

      final data = controller.cashFlowChartData;

      List<FlSpot> spots = [];

      if (data.isNotEmpty) {
        for (int i = 0; i < data.length; i++) {
          final value = (data[i]['volume'] ?? 0) as num;
          spots.add(FlSpot(i.toDouble(), value.toDouble()));
        }
      } else {
        spots = const [
          FlSpot(0, 0),
          FlSpot(1, 0),
          FlSpot(2, 0),
        ];
      }

      final minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 1;
      final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1;

      return AbsorbPointer(
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
            minY: minY,
            maxY: maxY,
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: const Color(0xFF00D9B5),
                barWidth: 0.5,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        ),
      );
    });
  }
}
