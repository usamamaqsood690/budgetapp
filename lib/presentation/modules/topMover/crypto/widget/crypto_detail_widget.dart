// lib/presentation/modules/crypto/widget/crypto_detail_widget/crypto_detail_widgets.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/controller/crypto_detail_controller.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_option.dart';
import 'package:wealthnxai/presentation/widgets/text/formatted_number_text.dart';

// ─── Formatters ───────────────────────────────────────────────────────────────

String _fmtDate(String? raw) {
  if (raw == null || raw.isEmpty) return 'N/A';
  try { return DateFormat('MMM d, y').format(DateTime.parse(raw)); }
  catch (_) { return 'N/A'; }
}

// ─── Top Section ─────────────────────────────────────────────────────────────

class CryptoDetailTopSection extends StatelessWidget {
  const CryptoDetailTopSection({super.key, required this.detail});
  final CryptoCoinEntity? detail;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CryptoDetailController>();
    final change = double.tryParse(detail?.priceChangesPer24h ?? '0') ?? 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Price + change ─────────────────────────────────────────────────
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final price = controller.selectedCandle.value != null
                  ? controller.currentPrice.value
                  : double.tryParse(detail?.currentPrice ?? '0') ?? 0.0;
              return FormattedNumberText(
                value: price,
                hint: NumberHint.price,
                showSign: false,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              );
            }),
            const SizedBox(height: 4),
            Row(children: [
              Text(
                '(${change.toStringAsFixed(2)}%)',
                style: TextStyle(
                  color: change >= 0 ? Colors.green : Colors.red,
                  fontSize: 14,
                ),
              ),
              const Text(
                '  24H',
                style: TextStyle(color: Color(0xFFC6C6C6), fontSize: 12),
              ),
            ]),
          ],
        ),

        const Spacer(),

        // ── 4 stat boxes ───────────────────────────────────────────────────
        Row(children: [
          Column(children: [
            SectionOption(
              heading: '24h High',
              title: detail?.high24h,
              hint: NumberHint.price,
              fontSize: 10.5,
            ),
            const SizedBox(height: 8),
            SectionOption(
              heading: '24h Low',
              title: detail?.low24h,
              hint: NumberHint.price,
              fontSize: 10.5,
            ),
          ]),
          const SizedBox(width: 20),
          Column(children: [
            _CompactStatBox(
              heading: '24h Vol(${detail?.symbol?.toUpperCase() ?? ''})',
              value: detail?.totalVolume,
            ),
            const SizedBox(height: 8),
            _CompactStatBox(
              heading: '24h Vol(USD)',
              value: detail?.totalVolume,
            ),
          ]),
        ]),
      ],
    );
  }
}

// ─── Market Stats Section ─────────────────────────────────────────────────────

class CryptoMarketStatsSection extends StatelessWidget {
  const CryptoMarketStatsSection({
    super.key,
    required this.detail,
    required this.controller,
  });
  final CryptoCoinEntity? detail;
  final CryptoDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Market Stats'),
        const SizedBox(height: 10),

        _row(
          SectionOption(heading: 'High', title: detail?.high24h, hint: NumberHint.price),
          SectionOption(heading: 'Low',  title: detail?.low24h,  hint: NumberHint.price),
        ),
        const SizedBox(height: 8),
        _row(
          SectionOption(heading: 'Price Change 24h', title: detail?.priceChangesPer24h, hint: NumberHint.price),
          _PriceChangePct(raw: detail?.priceChangesPer24h),
        ),
        const SizedBox(height: 8),
        _row(
          SectionOption(heading: 'Circulating Supply', title: detail?.circulatingSupply, hint: NumberHint.compact),
          SectionOption(heading: 'Total Supply',       title: detail?.totalSupply,       hint: NumberHint.compact),
        ),
        const SizedBox(height: 8),
        _row(
          SectionOption(
            heading: 'Max Supply',
            title: (detail?.maxSupply == null || detail?.maxSupply == '0')
                ? '∞'
                : detail?.maxSupply,
            hint: NumberHint.compact,
          ),
          const SizedBox(width: 150),
        ),

        // ── Expandable ────────────────────────────────────────────────────
        if (controller.isMarketStatsExpanded.value) ...[
          const SizedBox(height: 8),
          _row(
            SectionOption(heading: 'ATH',      title: detail?.ath,     hint: NumberHint.price),
            SectionOption(heading: 'ATH Date', title: _fmtDate(detail?.athDate), hint: NumberHint.plain),
          ),
          const SizedBox(height: 8),
          _row(
            SectionOption(heading: 'ATL',      title: detail?.atl,     hint: NumberHint.price),
            SectionOption(heading: 'ATL Date', title: _fmtDate(detail?.atlDate), hint: NumberHint.plain),
          ),
          const SizedBox(height: 8),
          _row(
            SectionOption(heading: 'Market Cap',       title: detail?.marketCap,    hint: NumberHint.compact),
            SectionOption(heading: 'Market Change 24h', title: detail?.marketCapPer24h, hint: NumberHint.compact),
          ),
          const SizedBox(height: 8),
          _row(
            SectionOption(heading: 'FDV',    title: detail?.fdv,         hint: NumberHint.compact),
            SectionOption(heading: 'Volume', title: detail?.totalVolume, hint: NumberHint.compact),
          ),
        ],

        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => controller.isMarketStatsExpanded.toggle(),
          child: Text(
            controller.isMarketStatsExpanded.value ? 'See Less' : 'See More',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _row(Widget left, Widget right) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(width: 150, child: left),
      SizedBox(width: 150, child: right),
    ],
  );
}

class _PriceChangePct extends StatelessWidget {
  const _PriceChangePct({required this.raw});
  final String? raw;

  @override
  Widget build(BuildContext context) {
    final clean = raw?.replaceAll(RegExp(r'[^\d.-]'), '') ?? '';
    return SectionOption(
      heading: 'Price Change 24H (%)',
      title: clean.isEmpty ? 'N/A' : '$clean%',
      hint: NumberHint.plain,
    );
  }
}

// ─── About Section ────────────────────────────────────────────────────────────

class CryptoAboutSection extends StatelessWidget {
  const CryptoAboutSection({super.key, required this.description});
  final String? description;

  @override
  Widget build(BuildContext context) {
    final text = (description ?? '').trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('About'),
        const SizedBox(height: 10),
        _ExpandableText(text: text.isEmpty ? 'No description available.' : text),
      ],
    );
  }
}

class _ExpandableText extends StatefulWidget {
  const _ExpandableText({required this.text});
  final String text;

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;
  static const int _maxLines = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _expanded ? null : _maxLines,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'See Less' : 'See More',
            style: const TextStyle(
              color: Colors.grey, fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Shared section title ─────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500,
      ),
    );
  }
}

// ─── Compact stat box (heading + FormattedNumberText) ─────────────────────────
// Used for 24h Vol where the dynamic symbol prevents use of SectionOption alone.

class _CompactStatBox extends StatelessWidget {
  const _CompactStatBox({required this.heading, required this.value, this.fontSize = 10.5});
  final String heading;
  final String? value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading,
            style: TextStyle(
                color: Colors.grey, fontSize: fontSize, fontWeight: FontWeight.w300)),
        const SizedBox(height: 2),
        FormattedNumberText(
          value: value,
          hint: NumberHint.compact,
          showSign: false,
          fontSize: fontSize,
        ),
      ],
    );
  }
}