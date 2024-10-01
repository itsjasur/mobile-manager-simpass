import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/popup_header.dart';
import 'package:mobile_manager_simpass/sensitive.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

Future<void> showHtmlViewerPopup(BuildContext context, String title, String id) async {
  if (context.mounted) {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupHeader(title: title),
              Expanded(child: HtmlEditorContent(id: id, title: title)),
            ],
          ),
        ),
      ),
    );
  }
}

class HtmlEditorContent extends StatefulWidget {
  final String id;
  final String title;
  const HtmlEditorContent({super.key, required this.id, required this.title});

  @override
  State<HtmlEditorContent> createState() => _HtmlEditorContentState();
}

class _HtmlEditorContentState extends State<HtmlEditorContent> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {},
        ),
      );

    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.post(
        Uri.parse('${CHATSERVER_API_URL}get-html'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"id": widget.id}),
      );

      if (response.statusCode != 200) throw 'Error fetching htmls';

      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      // _controller.loadHtmlString(decodedRes['html']['content']);

      String wrappedHtml = '''
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
              body { margin: 0; padding: 10px 20px ; width: 100%; box-sizing: border-box; }
              img { max-width: 100%; height: auto; }
            </style>
          </head>
          <body>
            ${decodedRes['html']['content']}
          </body>
        </html>
      ''';

      _controller.loadHtmlString(wrappedHtml);

      setState(() {});
    } catch (e) {
      print(e);
      showCustomSnackBar(e.toString());
    }
  }
}
