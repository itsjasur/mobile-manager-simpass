// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class HtmlViewPage extends StatefulWidget {
//   final String htmlFilePath;

//   const HtmlViewPage({Key? key, required this.htmlFilePath}) : super(key: key);

//   @override
//   _HtmlViewPageState createState() => _HtmlViewPageState();
// }

// class _HtmlViewPageState extends State<HtmlViewPage> {
//   late WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageFinished: (String url) {
//             // Page finished loading
//           },
//         ),
//       );
//     _loadHtmlFromAssets();
//   }

//   _loadHtmlFromAssets() async {
//     String fileHtmlContents = await rootBundle.loadString(widget.htmlFilePath);
//     _controller.loadHtmlString(fileHtmlContents);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('HTML View'),
//       ),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }