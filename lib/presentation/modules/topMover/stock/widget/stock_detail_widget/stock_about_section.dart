import 'package:flutter/material.dart';
import 'package:wealthnxai/domain/entities/stock/stock_detail_entity.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/presentation/widgets/text/load_more_text.dart';

class StockAboutSection extends StatelessWidget {
  const StockAboutSection({super.key, required this.detail});

  final StockDetailEntity? detail;

  @override
  Widget build(BuildContext context) {
    final description = detail?.description.isEmpty == true
        ? 'No description available'
        : detail?.description ?? 'No description available';

    return Column(
      children: [
        SectionName(title: 'About', titleOnTap: ''),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: LoadMoreText(
            text: description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}