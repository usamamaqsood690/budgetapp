import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/domain/entities/stock/stock_detail_entity.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/controller/stock_detail_controller.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_option.dart';
import 'package:wealthnxai/presentation/widgets/text/formatted_number_text.dart';

class StockMarketStatsSection extends StatelessWidget {
  const StockMarketStatsSection({
    super.key,
    required this.detail,
    required this.controller,
  });

  final StockDetailEntity? detail;
  final StockDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionName(title: 'Market Stats', titleOnTap: ''),
          const SizedBox(height: 10),

          // High / Low
          _row(
            SectionOption(heading: 'High', title: '${detail?.dayHigh}'),
            SectionOption(heading: 'Low', title: '${detail?.dayLow}'),
          ),
          const SizedBox(height: 8),

          // Open / Close
          _row(
            SectionOption(heading: 'Open', title: '${detail?.open}'),
            SectionOption(heading: 'Close', title: '${detail?.previousClose}'),
          ),
          const SizedBox(height: 8),

          // AT Range / 24h Range — plain strings
          _row(
            SectionOption(heading: 'AT Range', title: detail?.range),
            SectionOption(heading: '24h Range', title: detail?.twentyFourHRange),
          ),
          const SizedBox(height: 8),

          // Volume / Avg. Volume
          _row(
            SectionOption(heading: 'Volume (24h)', title: '${detail?.volume}'),
            SectionOption(heading: 'Avg. Volume', title: '${detail?.averageVolume}'),
          ),

          // ── Expanded Stats ─────────────────────────────────────────────
          if (controller.isMarketStatsExpanded.value && detail != null) ...[
            const SizedBox(height: 8),

            // Market Cap / Turnover
            _row(
              SectionOption(heading: 'Market Cap', title: '${detail!.marketCap}'),
              SectionOption(heading: 'Turnover', title: '${detail!.turnover}'),
            ),
            const SizedBox(height: 8),

            // Shares Outstanding / Exchange
            _row(
              SectionOption(
                heading: 'Shares Outstanding',
                title: detail!.sharesOutstanding == 0
                    ? null
                    : '${detail!.sharesOutstanding}',
              ),
              SectionOption(
                heading: 'Exchange',
                title: detail!.exchange.isEmpty ? null : detail!.exchange,
              ),
            ),
            const SizedBox(height: 8),

            // Dividend / Div. Yield
            _row(
              SectionOption(heading: 'Dividend', title: '${detail!.lastDividend}'),
              SectionOption(
                heading: 'Div. Yield',
                title: '${detail!.divYield}',
                hint: NumberHint.percent,
              ),
            ),
            const SizedBox(height: 8),

            // Change OverTime / % Range
            _row(
              SectionOption(
                heading: 'Change OverTime',
                title: '${detail!.changeOvertime}',
                hint: NumberHint.change,
              ),
              SectionOption(
                heading: '% Range',
                title: '${detail!.perRange}',
                hint: NumberHint.percent,
              ),
            ),
          ],

          const SizedBox(height: 10),

          // See More / See Less
          GestureDetector(
            onTap: () => controller.isMarketStatsExpanded.value =
            !controller.isMarketStatsExpanded.value,
            child: Obx(
                  () => Text(
                controller.isMarketStatsExpanded.value ? 'See Less' : 'See More',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helper: 2-column stat row ─────────────────────────────────────────────

  Widget _row(Widget left, Widget right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 150, child: left),
        SizedBox(width: 150, child: right),
      ],
    );
  }
}