import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class TopMoverList extends StatelessWidget {
  final String? name;
  final String? symbol;
  final String? image;
  final double? price;
  final double? priceChange;
  final VoidCallback onTap;
  final bool showBorder;

  const TopMoverList({
    super.key,
    required this.name,
    required this.symbol,
    required this.image,
    required this.price,
    required this.priceChange,
    required this.onTap,
    this.showBorder = false,
  });

  static const double _imageRadius = 17.0; // radius = size / 2
  static const double _verticalMargin = 8.0;
  static const double _horizontalSpacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: _verticalMargin),
        padding: showBorder ? const EdgeInsets.only(bottom: 10) : null,
        decoration: BoxDecoration(
          color: context.colors.transparent,
          border: showBorder
              ? const Border(
            bottom: BorderSide(color: Color(0xff252525), width: 0.6),
          )
              : null,
        ),
        child: Row(
          children: [
            AppImageAvatar(
              avatarUrl: image,
              radius: _imageRadius,
              fallbackAsset: 'assets/icons/coin_placeholder.png',
              borderWidth: 0,
              investmentIcon: true,
              isCircular: true,
            ),
            const SizedBox(width: _horizontalSpacing),
            _buildCoinInfo(context),
            _buildPriceInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            txt: name ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: context.colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          AppText(
            txt: symbol?.toUpperCase() ?? '',
            style: TextStyle(color: context.colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FormattedNumberText(
          value: price,
          hint: NumberHint.price,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        FormattedNumberText(
          value: priceChange,
          hint: NumberHint.percentChange,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}