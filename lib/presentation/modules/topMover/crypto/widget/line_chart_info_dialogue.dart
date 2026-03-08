import 'package:flutter/material.dart';
import 'package:k_chart_plus_deeping/entity/k_line_entity.dart';

class LineChartInfoDialog extends StatelessWidget {
  final KLineEntity entity;
  final double width;
  final Color backgroundColor;
  final Color textColor;

  const LineChartInfoDialog({
    Key? key,
    required this.entity,
    required this.width,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.withOpacity(0.4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price: \$${entity.close?.toStringAsFixed(2) ?? 'N/A'}',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Time: ${DateTime.fromMillisecondsSinceEpoch(entity.time ?? 0).toString().split(' ')[0]}',
            style: TextStyle(color: textColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
