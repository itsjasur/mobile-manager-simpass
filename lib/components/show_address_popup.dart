import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/models/daum_address_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<DaumAddressModel?> showAddressSelect(BuildContext context) async {
  DaumAddressModel? model = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
            maxHeight: 800,
          ),
          child: const DaumAddressFinder(),
        ),
      ),
    ),
  );
  return model;
}

class DaumAddressFinder extends StatefulWidget {
  const DaumAddressFinder({super.key, this.callback});

  @override
  DaumAddressFinderState createState() => DaumAddressFinderState();
  final Function? callback;
}

class DaumAddressFinderState extends State<DaumAddressFinder> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
      ..addJavaScriptChannel('onComplete', onMessageReceived: (JavaScriptMessage message) {
        DaumAddressModel result = DaumAddressModel.fromJson(jsonDecode(message.message));
        if (widget.callback != null) {
          widget.callback!(result);
        }
        Navigator.pop(context, result);
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {},
        ),
      )
      // ..loadRequest(Uri.parse('about:blank'))
      ..loadHtmlString(
        """
          <html>
          <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          <head>
              <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
              <title>주소검색</title>
          </head>
          <style>
          html,body{ margin:0; padding:0; height:100%; width:100%; }
          #full-size{
            height: 100%;
            width: 100%;
            overflow:hidden; /* or overflow:auto; if you want scrollbars */
          }
          </style>
          <body>
          <div id="full-size"></div>
          </body>
          <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
          <script type="text/javascript">
              // 우편번호 찾기 화면을 넣을 element
              var element_layer = document.getElementById('full-size');

              daum.postcode.load(function() {

                function callbackMessage(message) {
                  try { onComplete.postMessage(message); } catch(err) {}
                }

                new daum.Postcode({
                    oncomplete: function(data) {
                        // 우편번호와 주소 정보를 해당 필드에 넣는다.
                        callbackMessage(JSON.stringify(data));
                    },
                    width : '100%',
                    height : '100%',
                    maxSuggestItems : 5,
                    alwaysShowEngAddr: false,
                    hideMapBtn: true,
                    hideEngBtn: false,
                }).embed(element_layer);

                // iframe을 넣은 element를 보이게 한다.
                element_layer.style.display = 'block';
              });

          </script>
          </html>
        """,
        baseUrl: 'https://baroform.com',
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: const Text(
          '주소검색',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData().copyWith(color: Colors.black),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
