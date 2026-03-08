/// WebView New Screen - Presentation Layer
/// Located in: lib/presentation/modules/news/page/web_view_new_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/widgets/web_view/web_view_screen.dart';

class WebsViewNewScreen extends StatelessWidget {
  const WebsViewNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments from route
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String url = args['url'] ?? '';
    final String title = args['title'] ?? '';

    return Scaffold(
    //  appBar: CustomAppBar(title: title),
      body: WebViewScreen(
        url: url,
        title: title,
      ),
    );
  }
}