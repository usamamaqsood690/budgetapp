import 'package:flutter/material.dart';
import 'package:wealthnxai/presentation/widgets/text/formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class SectionOption extends StatelessWidget {
  const SectionOption({
    super.key,
    required this.heading,
    this.title,
    this.fontSize,
    this.hint = NumberHint.auto,
  });

  final String heading;
  final String? title;
  final double? fontSize;
  final NumberHint hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          txt: heading,
          style: TextStyle(
            color: Colors.grey,
            fontSize: fontSize ?? 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        FormattedNumberText(
          value: title,
          hint: hint,
          showSign: false,
          // ← always white in stat grids
          fontSize: fontSize ?? 14,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
