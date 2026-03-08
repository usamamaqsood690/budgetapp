/// WebView Screen - Presentation Layer
/// Located in: lib/presentation/widgets/web_view/web_view_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String? url;
  final String? title;
  final Function(double height)? onHeightChanged;

  const WebViewScreen({
    super.key,
    this.url,
    this.title,
    this.onHeightChanged,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController webViewController;
  bool isLoading = true;
  String? uId;

  @override
  void initState() {
    super.initState();
    fetchUserId();
    _initWebView();
  }

  void _initWebView() {
    if (widget.url == null || widget.url!.isEmpty) return;

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() => isLoading = true);
            }
          },
          onPageFinished: (String url) async {
            if (mounted) {
              setState(() => isLoading = false);

              try {
                final extractedHeight = _extractHeightFromUrl(url);
                if (extractedHeight != null && widget.onHeightChanged != null) {
                  widget.onHeightChanged!(extractedHeight.toDouble());
                }
              } catch (_) {}
            }
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url!));
  }

  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    uId = userId;
  }

  double? _extractHeightFromUrl(String url) {
    try {
      Uri uri = Uri.parse(url);
      String? heightParam = uri.queryParameters['height'];
      if (heightParam != null) {
        return double.tryParse(heightParam);
      }
    } catch (_) {}
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title ?? '',
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.url == null || widget.url!.isEmpty) {
      return const Center(
        child: Text(
          'Invalid URL',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
        ),
      );
    } else {
      return WebViewWidget(controller: webViewController);
    }
  }

  @override
  bool get wantKeepAlive => true;
}