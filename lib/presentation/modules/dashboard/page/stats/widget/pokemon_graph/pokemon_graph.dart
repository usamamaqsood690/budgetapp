import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';

class PokemonGraphChart extends StatelessWidget {
  final bool isLoading;
  final List<PokemonChartGraphModel> data;
  final PokemonChartGraphModel? selectedMonth;
  final Function(PokemonChartGraphModel) onMonthSelected;
  final double height;

  const PokemonGraphChart({
    super.key,
    required this.data,
    required this.onMonthSelected,
    this.isLoading = false,
    this.selectedMonth,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor:context.colors.shimmerBaseColor,
        highlightColor: context.colors.shimmerHighlightColor,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              return Column(
                children: [
                  // Capsule/Pill Bar
                  Container(
                    width: 30,
                    height: 100, // Fixed height for shimmer
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Label (Jan, Feb...)
                  Container(
                    width: 20,
                    height: 8,
                    color: Colors.white,
                  ),
                ],
              );
            }),
          ),
        ),
      );
    }

    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Calculate selected index automatically based on the passed object
    final int selectedIndex = selectedMonth == null
        ? -1
        : data.indexOf(selectedMonth!);

    return _InteractiveNeonGraph(
      data: data,
      height: height,
      selectedIndex: selectedIndex,
      onMonthSelected: onMonthSelected,
    );
  }
}

// --- INTERNAL GRAPH IMPLEMENTATION ---
// This is private (_) so it doesn't clutter your global namespace,
// but it contains the logic you provided.

class _InteractiveNeonGraph extends StatefulWidget {
  final List<PokemonChartGraphModel> data;
  final double height;
  final Function(PokemonChartGraphModel) onMonthSelected;
  final int selectedIndex;

  const _InteractiveNeonGraph({
    required this.data,
    required this.onMonthSelected,
    this.height = 200,
    this.selectedIndex = -1,
  });

  @override
  State<_InteractiveNeonGraph> createState() => _InteractiveNeonGraphState();
}

class _InteractiveNeonGraphState extends State<_InteractiveNeonGraph> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
      // Auto-select last month if nothing is selected
      if (widget.selectedIndex == -1 && widget.data.isNotEmpty) {
        widget.onMonthSelected(widget.data.last);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double barWidth = 30.0;
    const double horizontalGap = 25.0;
    const double slotWidth = barWidth + horizontalGap;
    final double totalCanvasWidth = slotWidth * widget.data.length;

    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double graphHeight =
          constraints.maxHeight.isFinite ? constraints.maxHeight : widget.height;

          return SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: GestureDetector(
              onTapUp: (details) {
                final double x = details.localPosition.dx;
                final int index = (x / slotWidth).floor();
                if (index >= 0 && index < widget.data.length) {
                  widget.onMonthSelected(widget.data[index]);
                }
              },
              child: CustomPaint(
                size: Size(totalCanvasWidth, graphHeight),
                painter: _GraphPainter(
                  widget.data,
                  barWidth,
                  slotWidth,
                  widget.selectedIndex,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  final List<PokemonChartGraphModel> data;
  final double barWidth;
  final double slotWidth;
  final int selectedIndex;

  _GraphPainter(this.data, this.barWidth, this.slotWidth, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    const double paddingBottom = 0.0;
    const double paddingTop = 0.0;
    final double drawableHeight = size.height - paddingTop - paddingBottom;
    const double minBarHeight = 15.0;
    const double heightUtilization = 0.5;

    int activeIndex = selectedIndex;
    if (activeIndex == -1 && data.isNotEmpty) {
      activeIndex = data.length - 1;
    }

    double maxIncome = 0;
    double maxExpense = 0;
    for (var item in data) {
      maxIncome = max(maxIncome, item.value1);
      maxExpense = max(maxExpense, item.value2);
    }

    double totalDataRange = maxIncome + maxExpense;
    const double minVirtualRange = 200.0;
    if (totalDataRange < minVirtualRange) {
      totalDataRange = minVirtualRange;
    }

    final double scaleFactor = totalDataRange == 0
        ? 0.0
        : (drawableHeight * heightUtilization) / totalDataRange;

    final double usedHeight = totalDataRange * scaleFactor;
    final double centeringOffset = (drawableHeight - usedHeight) / 2;
    double baselineY = paddingTop + centeringOffset + (maxIncome * scaleFactor);

    final Paint linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path linePath = Path();
    List<Offset> pointOffsets = [];

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final double centerX = (i * slotWidth) + (slotWidth / 2);

      double incomeHeight = item.value1 * scaleFactor;
      double expenseHeight = item.value2 * scaleFactor;

      if (item.value1 == 0) incomeHeight = minBarHeight;
      else if (incomeHeight < minBarHeight) incomeHeight = minBarHeight;

      if (item.value2 == 0) expenseHeight = minBarHeight;
      else if (expenseHeight < minBarHeight) expenseHeight = minBarHeight;

      final double topBarTopY = baselineY - incomeHeight;
      final double bottomBarTopY = baselineY + 3.0;
      final double bottomBarBottomY = bottomBarTopY + expenseHeight;
      final double dotY = baselineY - (item.value3 * scaleFactor);

      final bool isSelected = i == activeIndex;

      final Paint expensePaint = Paint()
        ..color = isSelected
            ? const Color.fromARGB(255, 11, 105, 97)
            : const Color(0xFF004943);

      final Paint incomePaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(centerX, topBarTopY),
          Offset(centerX, baselineY),
          isSelected
              ? [const Color(0xFF80FFEA), const Color.fromARGB(255, 40, 182, 173)]
              : [const Color(0xFF2BDFD2), const Color(0xFF1D9A91)],
        );
      RRect topBar = RRect.fromRectAndCorners(
        Rect.fromPoints(
          Offset(centerX - barWidth / 2, topBarTopY),
          Offset(centerX + barWidth / 2, baselineY),
        ),
        topLeft: Radius.circular(barWidth / 2),
        topRight: Radius.circular(barWidth / 2),
      );
      canvas.drawRRect(topBar, incomePaint);

      RRect bottomBar = RRect.fromRectAndCorners(
        Rect.fromPoints(
          Offset(centerX - barWidth / 2, bottomBarTopY),
          Offset(centerX + barWidth / 2, bottomBarBottomY),
        ),
        bottomLeft: Radius.circular(barWidth / 2),
        bottomRight: Radius.circular(barWidth / 2),
      );
      canvas.drawRRect(bottomBar, expensePaint);

      final pointOffset = Offset(centerX, dotY);
      pointOffsets.add(pointOffset);
      if (i == 0) linePath.moveTo(pointOffset.dx, pointOffset.dy);
      else linePath.lineTo(pointOffset.dx, pointOffset.dy);

      TextSpan span = TextSpan(
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        text: item.shortLabel,
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(centerX - (tp.width / 2), size.height - tp.height - 5.0),
      );
    }

    canvas.drawPath(linePath, linePaint);
    for (var point in pointOffsets) {
      canvas.drawCircle(point, 3.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex || oldDelegate.data != data;
}