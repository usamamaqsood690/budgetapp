import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/controller/stats_controller.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';

class BudgetSummeryCard extends GetView<StatsController> {
  const BudgetSummeryCard({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF072B28), width: 0.5),
      ),
      child: Obx(() {
        final totalBudget = controller.statsModel.value?.body.budget.totalBudget ?? 0.0;
        final remainingAmount = controller.statsModel.value?.body.budget.remainingBudget ?? 0.0;
        final usedFraction = totalBudget > 0
            ? ((totalBudget - remainingAmount).clamp(0.0, totalBudget) / totalBudget)
            : 0.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0), // Removed bottom padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Budget',
                        style: TextStyle(
                          color: Color(0xFF5A6570),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FormattedNumberText(
                        value: totalBudget,
                        showSign: true,
                        style:  context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _BudgetGauge(
              usedFraction: usedFraction,
              remainingAmount: remainingAmount,
            ),
            AppSpacing.addHeight(20)
          ],
        );
      }),
    );
  }
}

class _BudgetGauge extends StatelessWidget {
  final double usedFraction;
  final double remainingAmount;
  const _BudgetGauge({
    required this.usedFraction,
    required this.remainingAmount,
  });

  @override
  Widget build(BuildContext context) {
    final usedPercent = (usedFraction * 100).clamp(0.0, 100.0);

    return SizedBox(
      height: 100, // Reduced height from 120
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                startAngle: 180,
                endAngle: 0,
                showTicks: false,
                showLabels: false,
                radiusFactor: 1, // Reduced slightly
                canScaleToFit: true,
                axisLineStyle: const AxisLineStyle(
                  thickness: 0.3,
                  thicknessUnit: GaugeSizeUnit.factor,
                  color: Color(0xFF505050),
                  cornerStyle: CornerStyle.bothFlat,
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: usedPercent,
                    cornerStyle: CornerStyle.bothFlat,
                    width: 0.3,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: const Color(0xFF4ECDC4),
                  ),
                  MarkerPointer(
                    value: usedPercent,
                    markerType: MarkerType.triangle,
                    color: Colors.white,
                    markerHeight: 8,
                    markerWidth: 10,
                    markerOffset: 12, // Reduced offset
                    enableAnimation: true,
                    borderWidth: 0.5,
                    // borderColor: const Color(0xFF4ECDC4),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    angle: 90,
                    positionFactor: 0.1, // Moved even closer to gauge
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                       AppSpacing.addWidth(20),
                        const Text(
                          '0%',
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AppSpacing.addWidth(10),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Remaining',
                              style: TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 8,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 2),
                            FormattedNumberText(
                              value: remainingAmount,
                              hint:NumberHint.price,
                              showSign: true,
                              style:  context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        AppSpacing.addWidth(10),
                        Text(
                          '${usedPercent.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AppSpacing.addWidth(10),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}