import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/html_viewer.dart';
import 'package:mobile_manager_simpass/sensitive.dart';

import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class HtmlsPage extends StatefulWidget {
  const HtmlsPage({super.key});

  @override
  State<HtmlsPage> createState() => _HtmlsPageState();
}

class _HtmlsPageState extends State<HtmlsPage> {
  List _dataList = [];
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('정책')),
      body: ListView.separated(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemCount: _dataList.length + 1,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (index == _dataList.length) {
            if (_totalCount > _dataList.length) {
              return Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    _pageNumber++;
                    _fetchData();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('더보기'),
                      SizedBox(width: 5),
                      Icon(Icons.expand_more_outlined, size: 20),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Material(
              color: Theme.of(context).colorScheme.onPrimary,
              child: InkWell(
                onTap: () {
                  if (_dataList[index]['id'] != null) {
                    // showHtmlViewerPopup(context, _dataList[index]['title'] ?? "", _dataList[index]['id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HtmlEditorContent(
                          id: _dataList[index]['id'],
                          title: _dataList[index]['title'] ?? "",
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  constraints: const BoxConstraints(minHeight: 60),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          (_dataList[index]['num'] ?? 0).toString(),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 18,
                        child: Text(_dataList[index]['title']),
                      ),
                      const SizedBox(width: 10),
                      if (_dataList[index]['createdAt'] != null)
                        Expanded(
                          flex: 6,
                          child: Text(
                            _dataList[index]['createdAt'] ?? "",
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  int _pageNumber = 1;
  final int _perPage = 10;
  bool _dataLoading = true;

  Future<void> _fetchData() async {
    if (_pageNumber == 1) _dataList.clear();
    setState(() {});

    try {
      final response = await http.post(
        Uri.parse('${CHATSERVER_API_URL}get-htmls'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "pageNumber": _pageNumber,
          'perPage': _perPage,
        }),
      );

      if (response.statusCode != 200) throw 'Error fetching htmls';
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      developer.log(decodedRes['htmls'].length.toString());
      _dataList.addAll(decodedRes['htmls']);
      _totalCount = decodedRes['total_count'] ?? 0;

      setState(() {});
    } catch (e) {
      // print(e);
      developer.log(e.toString());
      showCustomSnackBar(e.toString());
    }
  }
}
