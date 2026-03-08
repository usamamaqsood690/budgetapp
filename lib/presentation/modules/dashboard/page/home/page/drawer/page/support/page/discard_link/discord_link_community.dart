import 'package:flutter/material.dart';
import 'package:wealthnxai/core/constants/app_webview_url_constant.dart';
import 'package:wealthnxai/presentation/widgets/web_view/web_view_screen.dart';

class DiscordLinkCommunity extends StatelessWidget {
  const DiscordLinkCommunity({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewScreen(
      url: AppWebviewUrlConstant.discardCommunityLinkUrl,
      onHeightChanged: (newHeight) {
      },
      title: 'Discord Community',
    );
  }
}
