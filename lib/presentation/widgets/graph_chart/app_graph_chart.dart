import 'package:flutter/material.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/graph_data_model/graph_data_model.dart';

class AppGraphChart extends StatefulWidget {
  final List<GraphData> data;
  final Color lineColor;
  final Color highlightColor;
  final Color circleColor;
  final Color circleBorderColor;
  final double height;
  final bool showVerticalBar;
  final ValueChanged<GraphData>? onPositionChanged;

  const AppGraphChart({
    super.key,
    required this.data,
    this.lineColor = const Color(0xFF104E48),
    this.highlightColor = const Color(0xFF28A79B),
    this.circleColor = Colors.black,
    this.circleBorderColor = Colors.white,
    this.height = 200,
    this.showVerticalBar = true,
    this.onPositionChanged,
  });

  @override
  State<AppGraphChart> createState() => _AppGraphChartState();
}

class _AppGraphChartState extends State<AppGraphChart> {
  double _circlePosition = 0; // Position from 0.0 (left) to 1.0 (right)
  bool _showTooltip = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanStart: (details) {
              setState(() {
                _showTooltip = true;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                // Update position based on drag
                _circlePosition = (details.localPosition.dx / constraints.maxWidth)
                    .clamp(0.0, 1.0);
                _showTooltip = true;

                // Notify listener with current data point
                if (widget.onPositionChanged != null && widget.data.isNotEmpty) {
                  final index = (_circlePosition * (widget.data.length - 1)).round();
                  widget.onPositionChanged!(widget.data[index]);
                }
              });
            },
            onPanEnd: (details) {
              setState(() {
                _showTooltip = false;
              });
            },
            child: CustomPaint(
              painter: GraphPainter(
                circlePosition: _circlePosition,
                data: widget.data,
                lineColor: widget.lineColor,
                highlightColor: widget.highlightColor,
                circleColor: widget.circleColor,
                circleBorderColor: widget.circleBorderColor,
                showVerticalBar: widget.showVerticalBar,
                showTooltip: _showTooltip,
              ),
            ),
          );
        },
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final double circlePosition;
  final List<GraphData> data;
  final Color lineColor;
  final Color highlightColor;
  final Color circleColor;
  final Color circleBorderColor;
  final bool showVerticalBar;
  final bool showTooltip;

  GraphPainter({
    required this.circlePosition,
    required this.data,
    required this.lineColor,
    required this.highlightColor,
    required this.circleColor,
    required this.circleBorderColor,
    required this.showVerticalBar,
    required this.showTooltip,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Find min and max values for scaling
    final values = data.map((d) => d.volume).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final valueRange = maxValue - minValue;

    // Add padding to the graph (10% on top and bottom)
    final paddingFactor = 0.1;

    // Normalize data points to fit in the canvas
    List<double> normalizedPoints = data.map((d) {
      if (valueRange == 0) return 0.5; // If all values are same
      final normalized = (d.volume - minValue) / valueRange;
      // Apply padding and invert (so higher values are at top)
      return paddingFactor + (normalized * (1 - 2 * paddingFactor));
    }).toList();

    // Calculate spacing between points
    final spacing = size.width / (data.length - 1);

    // Find which segment the circle is currently on
    final currentSegmentIndex = (circlePosition * (data.length - 1)).floor();

    final graphPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Highlighted line paint
    final highlightedGraphPaint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.stroke;

    // Draw lines connecting the points
    for (int i = 0; i < data.length - 1; i++) {
      final x1 = i * spacing;
      final y1 = size.height - (normalizedPoints[i] * size.height);
      final x2 = (i + 1) * spacing;
      final y2 = size.height - (normalizedPoints[i + 1] * size.height);

      // Calculate distance from current segment
      final distanceFromCenter = (i - currentSegmentIndex).abs();

      // Determine if should highlight and calculate thickness
      if (distanceFromCenter <= 2) {
        // Create thickness that decreases as we move away from center
        final thickness = 3.0 - (distanceFromCenter * 1.5);

        highlightedGraphPaint.strokeWidth = thickness;

        canvas.drawLine(
          Offset(x1, y1),
          Offset(x2, y2),
          highlightedGraphPaint,
        );
      } else {
        canvas.drawLine(
          Offset(x1, y1),
          Offset(x2, y2),
          graphPaint,
        );
      }
    }

    // Calculate the position on the graph based on circle position
    final circleX = size.width * circlePosition;

    // Find the interpolated Y value at this X position
    final segmentIndex = (circlePosition * (data.length - 1)).floor();
    final nextIndex = (segmentIndex + 1).clamp(0, data.length - 1);
    final segmentProgress = (circlePosition * (data.length - 1)) - segmentIndex;

    final y1 = normalizedPoints[segmentIndex];
    final y2 = normalizedPoints[nextIndex];
    final interpolatedY = y1 + (y2 - y1) * segmentProgress;
    final circleY = size.height - (interpolatedY * size.height);

    // Draw vertical bar with gradient from top (opaque) to bottom (transparent)
    if (showVerticalBar) {
      final barPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            highlightColor, // Full opacity at top
            highlightColor.withOpacity(0), // Transparent at bottom
          ],
        ).createShader(Rect.fromPoints(
          Offset(circleX, circleY),
          Offset(circleX, size.height),
        ))
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(circleX, circleY), // Start from graph point
        Offset(circleX, size.height), // Draw to bottom
        barPaint,
      );
    }

    // Draw the circle with center at the graph point
    final circleFillPaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(circleX, circleY),
      8.0, // Circle radius
      circleFillPaint,
    );

    // Draw border around the circle
    final circleBorderPaint = Paint()
      ..color = circleBorderColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(circleX, circleY),
      8.0, // Circle radius
      circleBorderPaint,
    );

    // Draw tooltip if enabled
    if (showTooltip) {
      final currentIndex = (circlePosition * (data.length - 1)).round();
      final currentData = data[currentIndex];

      _drawTooltip(
        canvas,
        size,
        circleX,
        circleY,
        currentData.total,
        currentData.label,
      );
    }
  }

  void _drawTooltip(
      Canvas canvas,
      Size size,
      double x,
      double y,
      double value,
      String label,
      ) {
    // Tooltip dimensions
    const tooltipWidth = 90.0;
    const tooltipHeight = 50.0;
    const padding = 8.0;
    const arrowSize = 8.0;

    // Determine if tooltip should be on left or right
    final bool showOnLeft = x > size.width / 2;

    // Calculate tooltip position
    final tooltipX = showOnLeft
        ? x - tooltipWidth - arrowSize - 10
        : x + arrowSize + 10;
    final tooltipY = y - tooltipHeight / 2;

    // Draw tooltip background with rounded corners
    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tooltipX, tooltipY, tooltipWidth, tooltipHeight),
      const Radius.circular(8),
    );

    final tooltipPaint = Paint()
      ..color = Color(0xFF101010)
      ..style = PaintingStyle.fill;


    // Draw tooltip background
    canvas.drawRRect(tooltipRect, tooltipPaint);

    // Draw tooltip border
    final borderPaint = Paint()
      ..color = Color(0xFF323232)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    canvas.drawRRect(tooltipRect, borderPaint);

    // Draw arrow pointing to the circle
    final arrowPath = Path();
    if (showOnLeft) {
      // Arrow on right side of tooltip
      arrowPath.moveTo(tooltipX + tooltipWidth, y - arrowSize);
      arrowPath.lineTo(tooltipX + tooltipWidth + arrowSize, y);
      arrowPath.lineTo(tooltipX + tooltipWidth, y + arrowSize);
    } else {
      // Arrow on left side of tooltip
      arrowPath.moveTo(tooltipX, y - arrowSize);
      arrowPath.lineTo(tooltipX - arrowSize, y);
      arrowPath.lineTo(tooltipX, y + arrowSize);
    }
    arrowPath.close();

    canvas.drawPath(arrowPath, tooltipPaint);
    canvas.drawPath(arrowPath, borderPaint);

    // Draw text - Amount
    final amountTextPainter = TextPainter(
      text: TextSpan(
        text: '\$${_formatNumber(value)}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    amountTextPainter.layout();
    amountTextPainter.paint(
      canvas,
      Offset(
        tooltipX + (tooltipWidth - amountTextPainter.width) / 2,
        tooltipY + padding,
      ),
    );

    // Draw text - Label (date)
    final labelTextPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    );
    labelTextPainter.layout(maxWidth: tooltipWidth - padding * 2);
    labelTextPainter.paint(
      canvas,
      Offset(
        tooltipX + (tooltipWidth - labelTextPainter.width) / 2,
        tooltipY + padding + amountTextPainter.height + 4,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return oldDelegate.circlePosition != circlePosition ||
        oldDelegate.data != data ||
        oldDelegate.showTooltip != showTooltip;
  }
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
  }
  return value.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
}