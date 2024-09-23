import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/popup_header.dart';
import 'package:mobile_manager_simpass/sensitive.dart';
import 'package:webview_flutter/webview_flutter.dart';

showHtmlContentPopup(BuildContext context, String type) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            HtmlContent(type: type),
            PopupHeader(title: type == 'privacy' ? '개인정보' : '이용약관'),
          ],
        ),
      ),
    ),
  );
}

class HtmlContent extends StatefulWidget {
  final String type;
  const HtmlContent({super.key, required this.type});

  @override
  State<HtmlContent> createState() => _HtmlContentState();
}

class _HtmlContentState extends State<HtmlContent> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // print(url);
          },
        ),
      )
      ..loadRequest(Uri.parse(openingUrl()));
  }

  String openingUrl() {
    String url = "";

    if (APPOWNER == 'sjnetworks') {
      if (widget.type == 'privacy') {
        url = 'https://mvno.sjnetworks.net/terms/privacy';
      } else {
        url = 'https://mvno.sjnetworks.net/terms/useterms';
      }
    } else {
      if (widget.type == 'privacy') {
        url = 'https://www.baroform.com/terms/privacy';
      } else {
        url = 'https://www.baroform.com/terms/useterms';
      }
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: WebViewWidget(controller: _controller),
    );
  }
}
