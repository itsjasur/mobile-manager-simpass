import "package:flutter/material.dart";
import "package:webview_flutter/webview_flutter.dart";

class TermsPage extends StatefulWidget {
  final String type;
  const TermsPage({super.key, required this.type});

  @override
  State<TermsPage> createState() => TermsPageState();
}

class TermsPageState extends State<TermsPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    String assetPath = widget.type == 'privacy' ? 'assets/htmls/privacy.html' : 'assets/htmls/useterms.html';

    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadFlutterAsset(assetPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'privacy' ? '개인정보보호정책' : '이용약관'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
