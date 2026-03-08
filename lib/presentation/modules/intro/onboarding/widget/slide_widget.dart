import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

/// Slide Widget for Onboarding
/// Displays title and subtitle with highlighted keywords
class SlideWidget extends StatelessWidget {
  const SlideWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.highlightWords = const ['Agents', 'AI', 'Ask'],
  });

  final String title;
  final String subtitle;
  final List<String> highlightWords;

  Widget _buildStyledText(
    BuildContext context,
    String text,
    List<String> highlightWords,
    TextStyle baseStyle,
  ) {
    final words = text.split(' ');
    final List<TextSpan> spans = [];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final isHighlightWord = highlightWords.any(
        (highlightWord) =>
            word.toLowerCase().contains(highlightWord.toLowerCase()),
      );

      spans.add(
        TextSpan(
          text: word + (i < words.length - 1 ? ' ' : ''),
          style:
              isHighlightWord
                  ? baseStyle.copyWith(color: context.colorScheme.primary)
                  : baseStyle,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtitleFontSize =  AppTextTheme.fontSize24;

    return Column(
      children: [
        AppText(
          txt: title,
          textAlign: TextAlign.center,
          style: context.bodyMedium?.copyWith(
            fontWeight: AppTextTheme.weightBold,
            fontSize: AppTextTheme.fontSize18,
          ),
        ),
        AppSpacing.addHeight(AppSpacing.sm),
        _buildStyledText(
          context,
          subtitle,
          highlightWords,
          context.titleMedium?.copyWith(
                fontSize: subtitleFontSize,
                fontWeight: AppTextTheme.weightBold,

              ) ??
              TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: AppTextTheme.weightBold,
              ),
        ),
      ],
    );
  }
}
