import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/title_header.dart';
import 'package:signature/signature.dart';

class AgreeDrawPad extends StatefulWidget {
  const AgreeDrawPad({super.key});

  @override
  State<AgreeDrawPad> createState() => _AgreeDrawPadState();
}

class _AgreeDrawPadState extends State<AgreeDrawPad> {
  double _pencilWidth = 3;
  // initialize the signature controller
  late SignatureController _agreePadCntr;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _agreePadCntr = SignatureController(
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
    double screenWidth = MediaQuery.of(context).size.width;
    //mobile

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
                      mainAxisSize: MainAxisSize.min,
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

                        SizedBox(
                          height: 174,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'lib/assets/umobile_agree_seal.png',
                                ),
                                Signature(
                                  key: const Key('signature'),
                                  controller: _agreePadCntr,
                                  height: 174,
                                  backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.06),
                                ),
                              ],
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
                                  _agreePadCntr.clear();
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            IntrinsicWidth(
                              child: ElevatedButton(
                                child: const Text('서명 저장'),
                                onPressed: () async {
                                  if (_agreePadCntr.isNotEmpty) {
                                    Uint8List? agreePng = await _agreePadCntr.toPngBytes();
                                    if (context.mounted) Navigator.pop(context, agreePng);
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
                const TitleHeader(title: '서명'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
