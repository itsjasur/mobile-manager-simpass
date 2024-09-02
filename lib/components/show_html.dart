import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_manager_simpass/components/popup_header.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
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
  String _useTerms = "";
  String _privacy = "";

  String _openingHtml = "";

  @override
  void initState() {
    super.initState();
    _loadHtmlFromAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: WebView(
        initialUrl: 'about:blank',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlContent();
        },
      ),
    );
  }

  Future<void> _loadHtmlFromAsset() async {
    if (APPOWNER == 'sjnetworks') {
      _useTerms = await rootBundle.loadString('assets/htmls/sj_useterms.html');
      _privacy = await rootBundle.loadString('assets/htmls/sj_privacy.html');
    } else {
      _useTerms = await rootBundle.loadString('assets/htmls/useterms.html');
      _privacy = await rootBundle.loadString('assets/htmls/privacy.html');
    }

    if (widget.type == 'privacy') _openingHtml = _privacy;
    if (widget.type == 'useterms') _openingHtml = _useTerms;

    setState(() {});
  }

  void _loadHtmlContent() {
    final String wrappedHtml = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
          <style>
            body {
              font-family: Arial, sans-serif;
              font-size: 16px;
              line-height: 1.5;
              padding: 16px;
              word-wrap: break-word;
            }
            img {
              max-width: 100%;
              height: auto;
            }
          </style>
        </head>
        <body>
          $_openingHtml
        </body>
      </html>
    ''';

    _controller.loadUrl(
      Uri.dataFromString(
        wrappedHtml,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );
  }
}
