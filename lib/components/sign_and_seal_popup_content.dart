import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/popup_header.dart';
import 'package:signature/signature.dart';

class SingNaturePads extends StatefulWidget {
  final String? overlayName;
  const SingNaturePads({super.key, this.overlayName});

  @override
  State<SingNaturePads> createState() => _SingNaturePadsState();
}

class _SingNaturePadsState extends State<SingNaturePads> {
  double _pencilWidth = 3;
  // initialize the signature controller
  late SignatureController _nameController;
  late SignatureController _signController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = SignatureController(
      penStrokeWidth: _pencilWidth,
      penColor: Colors.black,
      exportPenColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
      // exportBackgroundColor: Colors.red.shade200,
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
    );

    _signController = SignatureController(
      penStrokeWidth: _pencilWidth,
      penColor: Colors.black,
      exportPenColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
      // exportBackgroundColor: Colors.red.shade200,
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
    );
  }

  double _nameTextSize = 20;
  double _nameTextSpacing = 20;

  // String _name = 'SOBIRJONOV JASURBEK';
  // String _name = 'SOBIRJONOV JASURBEK ARISLONBEK UGLI';
  // String _name = '박기철';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //mobile

    _nameTextSize = screenWidth * 0.05;

    if (widget.overlayName != null && widget.overlayName != '') {
      if (widget.overlayName!.length <= 4) {
        _nameTextSize = screenWidth * 0.2;
        _nameTextSpacing = 20;
      }

      if (widget.overlayName!.length > 4 && widget.overlayName!.length < 20) {
        _nameTextSize = screenWidth * 0.11;
        _nameTextSpacing = 1;
      }

      if (widget.overlayName!.length >= 20 && widget.overlayName!.length < 40) {
        _nameTextSize = screenWidth * 0.07;
        _nameTextSpacing = 1;
      }
    }

    return Align(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        //name pad
                        Text(
                          '서명(Name)란',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),

                        Stack(
                          alignment: Alignment.center,
                          children: [
                            if (widget.overlayName != null && widget.overlayName != '')
                              Center(
                                child: Text(
                                  widget.overlayName!,
                                  style: TextStyle(
                                    fontSize: _nameTextSize,
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: _nameTextSpacing,
                                  ),
                                ),
                              ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Signature(
                                key: const Key('signature'),
                                controller: _nameController,
                                height: 300,
                                backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        //sign pad
                        Text(
                          '사인(Sign)란',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Signature(
                              key: const Key('signature'),
                              controller: _signController,
                              height: 300,
                              backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                        Text(
                          '펜 잉크 멀미: $_pencilWidth',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Slider(
                          label: _pencilWidth.toString(),
                          divisions: 7,
                          value: _pencilWidth,
                          min: 1,
                          max: 8,
                          onChanged: (double value) => setState(() {
                            _pencilWidth = value;
                            _initializeControllers();
                          }),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            IntrinsicWidth(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                                ),
                                child: const Text('지우기'),
                                onPressed: () {
                                  _nameController.clear();
                                  _signController.clear();
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            IntrinsicWidth(
                              child: ElevatedButton(
                                child: const Text('서명 저장'),
                                onPressed: () async {
                                  if (_nameController.isNotEmpty && _signController.isNotEmpty) {
                                    Uint8List? signpng = await _nameController.toPngBytes();
                                    Uint8List? sealpng = await _signController.toPngBytes();
                                    // widget.saveData(signpng!, sealpng!);
                                    if (context.mounted) Navigator.pop(context, [signpng, sealpng]);
                                  } else {
                                    showCustomSnackBar('먼저 서명을 해주세요.');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
                const PopupHeader(title: '서명'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
