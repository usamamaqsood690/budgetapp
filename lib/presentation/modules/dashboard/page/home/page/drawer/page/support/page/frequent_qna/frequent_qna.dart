import 'package:flutter/material.dart';
import 'package:wealthnxai/core/constants/app_webview_url_constant.dart';
import 'package:wealthnxai/presentation/widgets/web_view/web_view_screen.dart';

class QNAWebViewScreen extends StatelessWidget {

  const QNAWebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewScreen(
      url: AppWebviewUrlConstant.frequentQNAUrl,
      onHeightChanged: (newHeight) {
        Future.microtask(() {
          print('Chart Height: $newHeight');
        });
      },
      title: 'Answers your Traditional questions',
    );
  }
}