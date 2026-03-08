import 'package:flutter/material.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_option.dart';
import 'package:wealthnxai/presentation/widgets/text/formatted_number_text.dart';

class StockPositionSection extends StatelessWidget {
  const StockPositionSection({super.key, required this.assetPosition});

  final Map<String, String> assetPosition;

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(assetPosition['price'] ?? '0') ?? 0.0;
    final updated = double.tryParse(assetPosition['updateAmount'] ?? '0') ?? 0.0;
    final totalReturn = price != 0
        ? ((price - updated / price) * 100).toStringAsFixed(2)
        : '0.00';

    return Column(
      children: [
        SectionName(title: 'Your Position', titleOnTap: ''),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150,
              child: SectionOption(
                heading: 'Quantity',
                title: assetPosition['quantity'] ?? '0',
              ),
            ),
            SizedBox(
              width: 150,
              child: SectionOption(
                heading: 'Holding',
                title: assetPosition['amount'] ?? '0',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150,
              child: SectionOption(
                heading: 'Price',
                title: assetPosition['price'] ?? '0',
              ),
            ),
            SizedBox(
              width: 150,
              child: SectionOption(
                heading: 'Institution Price',
                title: assetPosition['institutionPrice'] ?? '0',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: 150,
              child: SectionOption(
                heading: 'Total return',
                title: totalReturn,
                hint: NumberHint.percent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}