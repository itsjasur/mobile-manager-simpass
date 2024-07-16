import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Base64ImageViewPage extends StatefulWidget {
  final List base64Images;
  const Base64ImageViewPage({super.key, required this.base64Images});

  @override
  State<Base64ImageViewPage> createState() => _Base64ImageViewPageState();
}

class _Base64ImageViewPageState extends State<Base64ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                padding: const EdgeInsets.only(top: 30, bottom: 100, right: 0, left: 0),
                itemCount: widget.base64Images.length,
                itemBuilder: (BuildContext context, int index) {
                  return ZoomableImage(base64Image: widget.base64Images[index]);
                },
              ),
            ),
            Positioned(
              // bottom: 0,
              bottom: 20,
              right: 20,
              child: ElevatedButton(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.print_outlined,
                            size: 23,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '줄력',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
