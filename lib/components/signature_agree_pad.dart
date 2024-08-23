import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:signature/signature.dart';

class SignatureAgreePad extends StatefulWidget {
  const SignatureAgreePad({super.key});

  @override
  State<SignatureAgreePad> createState() => _SignatureAgreePadState();
}

class _SignatureAgreePadState extends State<SignatureAgreePad> {
  late SignatureController _padController;
  double _pencilWidth = 4;

  @override
  void initState() {
    super.initState();
    _initializePadController();
  }

  void _initializePadController() {
    _padController = SignatureController(
      penStrokeWidth: _pencilWidth,
      penColor: Colors.black,
      exportPenColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
      // exportBackgroundColor: Colors.red.shade200,
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 20,
                      spacing: 20,
                      children: [
                        Container(
                          constraints: const BoxConstraints(minWidth: 100),
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () {
                              _padController.clear();
                            },
                            child: const Text('지우기'),
                          ),
                        ),
                        Container(
                          constraints: const BoxConstraints(minWidth: 100),
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_padController.isNotEmpty) {
                                Uint8List? data = await _padController.toPngBytes();
                                if (context.mounted) Navigator.pop(context, data);
                              } else {
                                showCustomSnackBar('가입약관에 동의하지 않았습니다.');
                              }
                            },
                            child: const Text('저장'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '펜 잉크 멀미: $_pencilWidth',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: Material(
                        color: Colors.transparent,
                        child: Slider(
                          label: _pencilWidth.toString(),
                          divisions: 6,
                          value: _pencilWidth,
                          min: 2,
                          max: 8,
                          onChanged: (double value) => setState(() {
                            _pencilWidth = value;
                            _initializePadController();
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 220,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Signature(
                          key: const Key('signature'),
                          controller: _padController,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
