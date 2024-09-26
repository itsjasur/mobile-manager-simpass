import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

class Base64ImageViewPage extends StatefulWidget {
  final List<String> base64Images;
  final bool goHome;
  const Base64ImageViewPage({super.key, required this.base64Images, this.goHome = true});

  @override
  State<Base64ImageViewPage> createState() => _Base64ImageViewPageState();
}

class _Base64ImageViewPageState extends State<Base64ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (widget.goHome) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ...List.generate(
                      widget.base64Images.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: ZoomableImage(
                          base64Image: widget.base64Images[index],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              Positioned(
                // bottom: 0,
                bottom: 20,
                right: 20,
                child: SafeArea(
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: _processing ? null : _convertAndDownloadPdf,
                        child: _processing
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : const Row(
                                children: [
                                  Icon(
                                    Icons.file_download_outlined,
                                    size: 23,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '다운로드',
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _printing ? null : _printImages,
                        child: _printing
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : const Row(
                                children: [
                                  Icon(
                                    Icons.print_outlined,
                                    size: 23,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '출력',
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _printing = false;

  Future<void> _printImages() async {
    _printing = true;
    setState(() {});

    try {
      final pdf = pw.Document();

      for (String base64Image in widget.base64Images) {
        final image = pw.MemoryImage(base64Decode(base64Image));
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(image),
              );
            },
          ),
        );
      }

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      _printing = false;
      setState(() {});
    }
  }

  bool _processing = false;

  Future<void> _convertAndDownloadPdf() async {
    if (_processing) return; // prevents multiple taps
    setState(() => _processing = true);

    try {
      Directory? directory;
      Uint8List bytes = await _createPdf();

      // Request storage permission (only needed for Android)
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();

        if (!status.isGranted) {
          throw Exception('Storage permission not granted');
        }
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        // Get app's documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      // Construct the file path
      String fileName = 'form.pdf';
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // Write the PDF to the file
      await file.writeAsBytes(bytes);
      await OpenFile.open(filePath);
    } catch (e) {
      print(e);
      showCustomSnackBar('오류가 발생했습니다: ${e.toString()}');
    } finally {
      setState(() => _processing = false);
    }
  }

  Future<Uint8List> _createPdf() async {
    final pdf = pw.Document();

    for (String base64Image in widget.base64Images) {
      final image = pw.MemoryImage(base64Decode(base64Image));
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );
    }

    // performs the CPU-intensive part in an isolate
    final Uint8List pdfBytes = await Isolate.run(() => pdf.save());
    return pdfBytes;
  }
}

class ZoomableImage extends StatefulWidget {
  final String base64Image;

  const ZoomableImage({super.key, required this.base64Image});

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  final TransformationController _controller = TransformationController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (_controller.value != Matrix4.identity()) {
          _controller.value = Matrix4.identity();

          setState(() {});
        } else {}
      },
      child: InteractiveViewer(
        panEnabled: true,
        transformationController: _controller,
        minScale: 0.5,
        maxScale: 4,
        child: Image.memory(
          base64.decode(widget.base64Image),
        ),
      ),
    );
  }
}
