import 'package:flutter/material.dart';
import 'package:wealthnxai/core/constants/app_webview_url_constant.dart';
import 'package:wealthnxai/presentation/widgets/web_view/web_view_screen.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
  return  WebViewScreen(
    url: AppWebviewUrlConstant.privacyPolicyUrl,
    title: 'Privacy Policy',
    onHeightChanged: (newHeight) {
      Future.microtask(() {
        debugPrint('Chart Height: $newHeight');
      });
    },
  );
  }
}
