import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_webview_url_constant.dart' show AppWebviewUrlConstant;
import 'package:wealthnxai/presentation/widgets/web_view/web_view_screen.dart';

/// Live Support Chat Page
/// Separated from `support_page.dart` to keep support sections modular.
class LiveSupportChatPage extends StatelessWidget {
  const LiveSupportChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewScreen(
      url:
      AppWebviewUrlConstant.liveSupportChatUrl,
      onHeightChanged: (newHeight) {},
      title: "Support Chat".tr,
    );
  }
}

