import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sideMenuNames[5])),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      useSafeArea: false,
                      builder: (BuildContext context) => Scaffold(
                        appBar: AppBar(),
                      ),
                    );
                  },
                  minLeadingWidth: 200,
                  minTileHeight: 55,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  tileColor: Colors.white,
                  title: const Text(
                    '개인정보보호정책',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () async {
                    // You can implement similar functionality for 이용약관 here

                    await showDialog(
                      context: context,
                      useSafeArea: false,
                      builder: (BuildContext context) => Scaffold(
                        appBar: AppBar(),
                      ),
                    );
                  },
                  minLeadingWidth: 200,
                  minTileHeight: 55,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  tileColor: Colors.white,
                  title: const Text(
                    '이용약관',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        <h1>HTML content111</h1>
        </body>
      </html>
    ''';
  }
}
