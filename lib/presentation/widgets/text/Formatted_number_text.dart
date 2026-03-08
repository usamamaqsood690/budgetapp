import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum NumberHint {
  /// Auto-detect (default)
  auto,

  /// Signed % with color  e.g. changesPercentage  →  +1.63% (green) / -0.45% (red)
  percentChange,

  /// Signed $ with color  e.g. change amount  →  +$3.01 (green) / -$0.45 (red)
  change,

  /// Plain %  e.g. divYield, perRange  →  0.09%
  percent,

  /// Compact K/M/B/T  e.g. volume, marketCap  →  159.9M / $4.6T
  compact,

  /// Price $x.xx  e.g. price, dayHigh, dayLow  →  $187.98
  price,

  /// Plain string passthrough  e.g. range, 24hRange  →  86.62-212.19
  plain,
}

class FormattedNumberText extends StatelessWidget {
  const FormattedNumberText({
    super.key,
    required this.value,
    this.hint = NumberHint.auto,
    this.showCurrency = true,

    /// Set false to suppress green/red coloring even for change/percentChange.
    /// Useful in stat grids where you just want white text.
    this.showSign = true,

    this.fallback = 'N/A',
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.positiveColor = const Color(0xFF4CAF50),
    this.negativeColor = const Color(0xFFF44336),
    this.style,
    this.textAlign,
    this.overflow,
    this.shrinkWrap = false

  });

  final dynamic value;
  final NumberHint hint;
  final bool showCurrency;

  /// Controls whether positive/negative colors are applied.
  /// Default: true — colors shown.
  /// Set to false in market stats / section options for plain white.
  final bool showSign;

  final String fallback;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final Color positiveColor;
  final Color negativeColor;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool shrinkWrap ;
  static final _priceFmt = NumberFormat('#,##0.00', 'en_US');

  @override
  Widget build(BuildContext context) {
    final result = _resolve();
    return Text(
      result.text,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: shrinkWrap,
      style: style ??
          TextStyle(
            // showSign=false → always white (or custom color), ignore result.color
            color: showSign
                ? (result.color ?? color ?? Colors.white)
                : (color ?? Colors.white),
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
    );
  }

  _Result _resolve() {
    if (value == null) return _Result(fallback);
    final raw = value.toString().trim();
    if (raw.isEmpty || raw == 'null') return _Result(fallback);

    // Plain passthrough — letters, spaces, or range dashes like "86.62-212.19"
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(raw);
    final hasSpace = raw.contains(' ');
    final multiDash = RegExp(r'\d-\d').allMatches(raw).length > 1 ||
        (raw.contains('-') &&
            raw.indexOf('-') != 0 &&
            raw.contains('-', raw.indexOf('-') + 1));

    if (hint == NumberHint.plain || hasLetters || hasSpace || multiDash) {
      return _Result(raw.isEmpty ? fallback : raw);
    }

    final cleaned = raw.replaceAll(RegExp(r'[^0-9.-]'), '');
    final num? parsed = num.tryParse(cleaned);
    if (parsed == null) return _Result(raw);

    final abs = parsed.abs().toDouble();
    final isNeg = parsed < 0;
    final currency = showCurrency ? '\$' : '';
    final resolved = hint == NumberHint.auto ? _detect(parsed, abs) : hint;

    switch (resolved) {
      case NumberHint.percentChange:
        final sign = isNeg ? '' : '';
        return _Result(
          '$sign${_toFixed(parsed.toDouble())}%',
          color: isNeg ? negativeColor : positiveColor,
        );

      case NumberHint.change:
        final sign = isNeg ? '-' : '';
        return _Result(
          '$sign$currency${_toFixed(abs)}',
          color: isNeg ? negativeColor : positiveColor,
        );

      case NumberHint.percent:
        return _Result('${_toFixed(parsed.toDouble())}%');

      case NumberHint.compact:
        final sign = isNeg ? '-' : '';
        return _Result('$sign$currency${_compact(abs)}');

      case NumberHint.price:
        final sign = isNeg ? '-' : '';
        return _Result('$sign$currency${_priceFmt.format(abs)}');

      case NumberHint.plain:
        return _Result(raw);

      case NumberHint.auto:
        return _Result(raw);
    }
  }

  NumberHint _detect(num parsed, double abs) {
    if (abs >= 1000 && parsed == parsed.truncate()) return NumberHint.compact;
    if (abs >= 1000) return NumberHint.compact;
    return NumberHint.price;
  }

  String _toFixed(double v) => v.toStringAsFixed(2);

  String _compact(double v) {
    if (v >= 1e12) return _fix(v / 1e12, 'T');
    if (v >= 1e9) return _fix(v / 1e9, 'B');
    if (v >= 1e6) return _fix(v / 1e6, 'M');
    if (v >= 1e3) return _fix(v / 1e3, 'K');
    return v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1);
  }

  String _fix(double v, String unit) =>
      '${v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1)}$unit';
}

class _Result {
  const _Result(this.text, {this.color});
  final String text;
  final Color? color;
}