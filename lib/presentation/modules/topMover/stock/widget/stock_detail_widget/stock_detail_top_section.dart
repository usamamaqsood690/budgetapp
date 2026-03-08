import 'package:flutter/material.dart';
import 'package:wealthnxai/domain/entities/stock/stock_detail_entity.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_option.dart';
import 'package:wealthnxai/presentation/widgets/text/formatted_number_text.dart';

class StockDetailTopSection extends StatelessWidget {
  const StockDetailTopSection({super.key, required this.detail});

  final StockDetailEntity? detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ── Left: Price + Change % ───────────────────────────────────────
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormattedNumberText(
              value: detail?.price,
              hint: NumberHint.price,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                FormattedNumberText(
                  value: detail?.changesPercentage,
                  hint: NumberHint.percentChange,
                  fontSize: 14,
                ),
                const Text(
                  '  24H',
                  style: TextStyle(
                    color: Color(0xFFC6C6C6),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),

        const Spacer(),

        // ── Right: 4 stat items ──────────────────────────────────────────
        Row(
          children: [
            Column(
              children: [
                SectionOption(
                  fontSize: 10.5,
                  heading: '24h High',
                  title: '${detail?.dayHigh}',
                ),
                const SizedBox(height: 8),
                SectionOption(
                  fontSize: 10.5,
                  heading: '24h Low',
                  title: '${detail?.dayLow}',
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                SectionOption(
                  fontSize: 10.5,
                  heading: '24h Vol',
                  title: '${detail?.volume}',
                ),
                const SizedBox(height: 8),
                SectionOption(
                  fontSize: 10.5,
                  heading: 'Change',
                  title: '${detail?.change}',
                  hint: NumberHint.change,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}