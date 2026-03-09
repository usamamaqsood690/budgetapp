import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int _selectedPeriod = 0;
  final List<String> _periods = ['Day', 'Week', 'Month', 'Year'];
  String _selectedType = 'Expense';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4FAF8),
      child: SafeArea(
        child: Column(
          children: [
            AppSpacing.addHeight(8),

            // 1. Header
            _StatisticsHeader(),
            AppSpacing.addHeight(20),

            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Period selector
                    _PeriodSelector(
                      periods: _periods,
                      selectedIndex: _selectedPeriod,
                      onSelected: (i) => setState(() => _selectedPeriod = i),
                    ),
                    AppSpacing.addHeight(16),

                    // 3. Type dropdown (right-aligned)
                    Align(
                      alignment: Alignment.centerRight,
                      child: _TypeDropdown(
                        value: _selectedType,
                        onChanged:
                            (v) => setState(
                              () => _selectedType = v ?? _selectedType,
                            ),
                      ),
                    ),
                    AppSpacing.addHeight(8),

                    // 4. Chart with draggable pin
                    const _SpendingChart(),
                    AppSpacing.addHeight(28),

                    // 5. Top Spending
                    const _TopSpendingSection(),
                    AppSpacing.addHeight(28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _StatisticsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 28,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const Expanded(
            child: Text(
              'Statistics',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          const Icon(Icons.upload_rounded, size: 24, color: Color(0xFF1A1A2E)),
        ],
      ),
    );
  }
}

// ─── Period Selector ──────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _PeriodSelector({
    required this.periods,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(periods.length, (i) {
        final isActive = i == selectedIndex;
        return GestureDetector(
          onTap: () => onSelected(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF3DAA8E) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              periods[i],
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Colors.white : const Color(0xFF888888),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Type Dropdown ────────────────────────────────────────────────────────────

class _TypeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _TypeDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Color(0xFF3DAA8E),
          ),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A2E),
          ),
          items: const [
            DropdownMenuItem(value: 'Expense', child: Text('Expense')),
            DropdownMenuItem(value: 'Income', child: Text('Income')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ─── Spending Chart (Stateful — draggable pin) ────────────────────────────────

class _SpendingChart extends StatefulWidget {
  const _SpendingChart();

  @override
  State<_SpendingChart> createState() => _SpendingChartState();
}

class _SpendingChartState extends State<_SpendingChart> {
  static const List<double> _points = [
    0.35, // Mar
    0.20, // Apr
    0.72, // May
    0.45, // Jun
    0.55, // Jul
    0.40, // Aug
    0.60, // Sep
  ];

  static const List<String> _labels = [
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
  ];

  static const List<String> _amounts = [
    '\$430',
    '\$280',
    '\$1,230',
    '\$650',
    '\$820',
    '\$510',
    '\$740',
  ];

  int _activeIndex = 2; // default: May
  double _chartWidth = 0;

  void _updateIndex(double dx) {
    if (_chartWidth == 0) return;
    final stepX = _chartWidth / (_points.length - 1);
    final index = (dx / stepX).round().clamp(0, _points.length - 1);
    if (index != _activeIndex) {
      setState(() => _activeIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _chartWidth = constraints.maxWidth;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate:
                (d) => _updateIndex(d.localPosition.dx.clamp(0, _chartWidth)),
            onTapDown:
                (d) => _updateIndex(d.localPosition.dx.clamp(0, _chartWidth)),
            child: CustomPaint(
              painter: _ChartPainter(
                points: _points,
                activeIndex: _activeIndex,
              ),
              child: _ChartOverlay(
                points: _points,
                labels: _labels,
                amounts: _amounts,
                activeIndex: _activeIndex,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Chart Painter ────────────────────────────────────────────────────────────

class _ChartPainter extends CustomPainter {
  final List<double> points;
  final int activeIndex;

  const _ChartPainter({required this.points, required this.activeIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final chartH = size.height - 24;
    final stepX = size.width / (points.length - 1);

    final offsets = List.generate(
      points.length,
      (i) => Offset(i * stepX, chartH * (1 - points[i])),
    );

    // ── Smooth cubic path ──
    final path = Path()..moveTo(offsets[0].dx, offsets[0].dy);
    for (int i = 0; i < offsets.length - 1; i++) {
      final cp1 = Offset(
        (offsets[i].dx + offsets[i + 1].dx) / 2,
        offsets[i].dy,
      );
      final cp2 = Offset(
        (offsets[i].dx + offsets[i + 1].dx) / 2,
        offsets[i + 1].dy,
      );
      path.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        offsets[i + 1].dx,
        offsets[i + 1].dy,
      );
    }

    // ── Gradient fill ──
    final fillPath =
        Path.from(path)
          ..lineTo(offsets.last.dx, chartH)
          ..lineTo(offsets.first.dx, chartH)
          ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFF3DAA8E).withOpacity(0.30),
            const Color(0xFF3DAA8E).withOpacity(0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, chartH)),
    );

    // ── Line stroke ──
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF3DAA8E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // ── Active pin ──
    final hiOffset = offsets[activeIndex];

    // Dashed vertical line
    const dashH = 6.0, dashGap = 4.0;
    double y = hiOffset.dy + 8;
    final dashPaint =
        Paint()
          ..color = const Color(0xFF3DAA8E).withOpacity(0.5)
          ..strokeWidth = 1.2;
    while (y < chartH) {
      canvas.drawLine(
        Offset(hiOffset.dx, y),
        Offset(hiOffset.dx, (y + dashH).clamp(0.0, chartH)),
        dashPaint,
      );
      y += dashH + dashGap;
    }

    // Outer glow ring
    canvas.drawCircle(
      hiOffset,
      12,
      Paint()..color = const Color(0xFF3DAA8E).withOpacity(0.18),
    );
    // White ring
    canvas.drawCircle(hiOffset, 7, Paint()..color = Colors.white);
    // Inner teal dot
    canvas.drawCircle(hiOffset, 5, Paint()..color = const Color(0xFF3DAA8E));
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) =>
      old.activeIndex != activeIndex;
}

// ─── Chart Overlay (tooltip + x-axis labels) ─────────────────────────────────

class _ChartOverlay extends StatelessWidget {
  final List<double> points;
  final List<String> labels;
  final List<String> amounts;
  final int activeIndex;

  const _ChartOverlay({
    required this.points,
    required this.labels,
    required this.amounts,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final chartH = h - 24.0;
        final stepX = w / (points.length - 1);

        final hiX = activeIndex * stepX;
        final hiY = chartH * (1 - points[activeIndex]);

        const tooltipW = 90.0;
        final tooltipLeft = (hiX - tooltipW / 2).clamp(0.0, w - tooltipW);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Tooltip ──
            Positioned(
              left: tooltipLeft,
              top: hiY - 50,
              child: _Tooltip(text: amounts[activeIndex]),
            ),

            // ── X-axis labels ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(labels.length, (i) {
                  final isActive = i == activeIndex;
                  return SizedBox(
                    width: stepX,
                    child: Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w400,
                        color:
                            isActive
                                ? const Color(0xFF3DAA8E)
                                : const Color(0xFF999999),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Tooltip ─────────────────────────────────────────────────────────────────

class _Tooltip extends StatelessWidget {
  final String text;
  const _Tooltip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 90,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F7F3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF3DAA8E).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3DAA8E).withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3DAA8E),
            ),
          ),
        ),
        CustomPaint(size: const Size(12, 6), painter: _TooltipArrow()),
      ],
    );
  }
}

class _TooltipArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(size.width, 0)
        ..close(),
      Paint()..color = const Color(0xFFE8F7F3),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── Top Spending ─────────────────────────────────────────────────────────────

class _TopSpendingSection extends StatelessWidget {
  const _TopSpendingSection();

  static const List<_SpendData> _items = [
    _SpendData(
      logo: _SpendLogo.starbucks,
      title: 'Starbucks',
      subtitle: 'Jan 12, 2022',
      amount: '- \$ 150.00',
      isHighlighted: false,
    ),
    _SpendData(
      logo: _SpendLogo.transfer,
      title: 'Transfer',
      subtitle: 'Yesterday',
      amount: '- \$ 85.00',
      isHighlighted: true,
    ),
    _SpendData(
      logo: _SpendLogo.youtube,
      title: 'Youtube',
      subtitle: 'Jan 16, 2022',
      amount: '- \$ 11.99',
      isHighlighted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Top Spending',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const Icon(
              Icons.swap_vert_rounded,
              size: 22,
              color: Color(0xFF888888),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...List.generate(
          _items.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SpendTile(data: _items[i]),
          ),
        ),
      ],
    );
  }
}

enum _SpendLogo { starbucks, transfer, youtube }

class _SpendData {
  final _SpendLogo logo;
  final String title;
  final String subtitle;
  final String amount;
  final bool isHighlighted;

  const _SpendData({
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isHighlighted,
  });
}

class _SpendTile extends StatelessWidget {
  final _SpendData data;
  const _SpendTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final bg = data.isHighlighted ? const Color(0xFF3DAA8E) : Colors.white;
    final titleColor =
        data.isHighlighted ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor =
        data.isHighlighted
            ? Colors.white.withOpacity(0.75)
            : const Color(0xFF999999);
    final amountColor =
        data.isHighlighted ? Colors.white : const Color(0xFFE53935);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                data.isHighlighted
                    ? const Color(0xFF3DAA8E).withOpacity(0.35)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _SpendLogoWidget(logo: data.logo, highlighted: data.isHighlighted),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            data.amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendLogoWidget extends StatelessWidget {
  final _SpendLogo logo;
  final bool highlighted;

  const _SpendLogoWidget({required this.logo, required this.highlighted});

  @override
  Widget build(BuildContext context) {
    switch (logo) {
      case _SpendLogo.starbucks:
        return _LogoBox(
          bg: const Color(0xFF006241),
          child: const Text('☕', style: TextStyle(fontSize: 18)),
        );
      case _SpendLogo.transfer:
        return _LogoBox(
          bg:
              highlighted
                  ? Colors.white.withOpacity(0.20)
                  : const Color(0xFFE3F2FD),
          child: Icon(
            Icons.swap_horiz_rounded,
            color: highlighted ? Colors.white : const Color(0xFF1565C0),
            size: 22,
          ),
        );
      case _SpendLogo.youtube:
        return _LogoBox(
          bg: const Color(0xFFFFEBEE),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Color(0xFFFF0000),
            size: 24,
          ),
        );
    }
  }
}

class _LogoBox extends StatelessWidget {
  final Color bg;
  final Widget child;

  const _LogoBox({required this.bg, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
