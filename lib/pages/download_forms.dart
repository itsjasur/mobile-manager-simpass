import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/global_loading.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class DownloadFormsPage extends StatefulWidget {
  const DownloadFormsPage({super.key});

  @override
  State<DownloadFormsPage> createState() => _DownloadFormsPageState();
}

class _DownloadFormsPageState extends State<DownloadFormsPage> {
  List _dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    bool isTablet = displayWidth > 600;

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[3])),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 10),
                isTablet
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 15,
                        runSpacing: 15,
                        children: _dataList
                            .map((item) => SizedBox(
                                  width: 320,
                                  child: _createCard(item),
                                ))
                            .toList(),
                      )
                    : Wrap(
                        runSpacing: 15,
                        children: _dataList.map((item) => _createCard(item)).toList(),
                      ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createCard(info) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.onPrimary,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              // width: 300,
              // height: 250,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.network(
                      info['image_url'],
                      height: 25,
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    info['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    info['sub_title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 40),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        onPressed: () {
                          _downloadPdfAndOpen(info['filename']);
                        },
                        child: const Text('다운로드'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 40),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        onPressed: () {
                          _printPdf(info['filename']);
                        },
                        child: const Text('프린트'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Future<void> _fetchData() async {
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/applyForms', method: 'GET');

      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      if (decodedRes['data']?['info'] != null && decodedRes['data']['info'].isNotEmpty) {
        _dataList = decodedRes['data']['info'];

        // print(_dataList);
        if (mounted) setState(() {});
        return;
      }
      throw 'Fetch issue found';
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      showGlobalLoading(false);
    }
  }

  Future<Uint8List?> _fetchPdf(String filename) async {
    try {
      showGlobalLoading(true);
      final response = await Request().requestWithRefreshToken(url: 'agent/attach/$filename', method: 'GET');
      Uint8List bytes = response.bodyBytes;

      if (bytes.isEmpty) throw 'Empty';

      return bytes;
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      showGlobalLoading(false);
    }
    return null;
  }

  Future<void> _printPdf(String filename) async {
    try {
      Uint8List? bytes = await _fetchPdf(filename);
      if (bytes != null) {
        await Printing.layoutPdf(
          onLayout: (_) async => bytes,
        );
      } else {
        showCustomSnackBar('No form received');
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }

  Future<void> _downloadPdfAndOpen(String filename) async {
    try {
      Uint8List? bytes = await _fetchPdf(filename);
      if (bytes != null) {
        final directory = await getTemporaryDirectory();

        final filePath = '${directory.path}/$filename.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        await OpenFile.open(filePath);
      } else {
        showCustomSnackBar('No form received');
      }
    } catch (e) {
      // print(e);
      showCustomSnackBar(e.toString());
    }
  }
}
