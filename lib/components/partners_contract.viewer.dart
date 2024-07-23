import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

showPartnerContract(BuildContext context, String agentCode, String partnerName) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: PartnersContractViewer(agentCode: agentCode, partnerName: partnerName),
      ),
    ),
  );
}

class PartnersContractViewer extends StatefulWidget {
  final String agentCode;
  final String partnerName;
  const PartnersContractViewer({super.key, required this.agentCode, required this.partnerName});

  @override
  State<PartnersContractViewer> createState() => PartnersContractViewerState();
}

class PartnersContractViewerState extends State<PartnersContractViewer> {
  final List<String> _spImagesPaths = [
    'assets/contracts/s/s1.png',
    'assets/contracts/s/s2.png',
    'assets/contracts/s/s3.png',
    'assets/contracts/s/s4.png',
    'assets/contracts/s/s5.png',
    'assets/contracts/s/s6.png',
  ];
  final List<String> _sjImagesPaths = [
    'assets/contracts/j/j1.jpg',
    'assets/contracts/j/j2.jpg',
    'assets/contracts/j/j3.jpg',
    'assets/contracts/j/j4.jpg',
    'assets/contracts/j/j5.jpg',
    'assets/contracts/j/j6.jpg',
  ];

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
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            widget.agentCode == 'SP' ? _spImagesPaths.length : _sjImagesPaths.length,
            (index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ZoomableImage(
                    child: ImageWithText(
                      imagePath: widget.agentCode == 'SP' ? _spImagesPaths[index] : _sjImagesPaths[index],
                      text: widget.partnerName,
                      agentCd: widget.agentCode,
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ZoomableImage(
                  child: Image.asset(
                    widget.agentCode == 'SP' ? _spImagesPaths[index] : _sjImagesPaths[index],
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ZoomableImage extends StatefulWidget {
  final Widget child;

  const ZoomableImage({super.key, required this.child});

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
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ImageWithText extends StatefulWidget {
  final String imagePath;
  final String text;
  final String agentCd;
  const ImageWithText({super.key, required this.imagePath, required this.text, required this.agentCd});

  @override
  State<ImageWithText> createState() => _ImageWithTextState();
}

class _ImageWithTextState extends State<ImageWithText> {
  Future<ui.Image> _getImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _getImage(widget.imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          double originalImageWidth = snapshot.data!.width.toDouble();
          double originalImageHeight = snapshot.data!.height.toDouble();

          return LayoutBuilder(
            builder: (context, constraints) {
              double renderedImageWidth = constraints.maxWidth;
              double scaleFactor = renderedImageWidth / originalImageWidth;

              // calculates text position (adjust these values as needed) for SP
              double textLeft = originalImageWidth * 0.44 * scaleFactor; // 60% from left
              double textTop = originalImageHeight * 0.19 * scaleFactor; // 26% from top

              double textSize = originalImageWidth * 0.018 * scaleFactor;

              if (widget.agentCd == 'SJ') {
                textLeft = originalImageWidth * 0.41 * scaleFactor;
                textTop = originalImageHeight * 0.06 * scaleFactor;
                textSize = originalImageWidth * 0.012 * scaleFactor;
              }

              return Stack(
                children: [
                  Image.asset(
                    widget.imagePath,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    left: textLeft,
                    top: textTop,
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: textSize,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
