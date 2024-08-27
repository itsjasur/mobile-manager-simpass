import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:mobile_manager_simpass/components/signature_pad.dart';

class SignaturePadsContainer extends StatefulWidget {
  final String? title;
  final String? errorText;
  final String? signData;
  final String? sealData;
  final Function(String?, String?) updateDatas;

  const SignaturePadsContainer({super.key, this.title = 'Sign/Seal', this.signData, this.sealData, required this.updateDatas, this.errorText});

  @override
  State<SignaturePadsContainer> createState() => _SignaturePadsContainerState();
}

class _SignaturePadsContainerState extends State<SignaturePadsContainer> {
  Uint8List? _signData;
  Uint8List? _sealData;

  @override
  void initState() {
    super.initState();
    _setData();
  }

  Future<void> _setData() async {
    _signData = await _convertBase64ToByte(widget.signData);
    _sealData = await _convertBase64ToByte(widget.sealData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Text(
              widget.title!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '서명',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Stack(
                      children: [
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(4),
                          strokeWidth: 2,
                          dashPattern: const [4],
                          color: Theme.of(context).colorScheme.primary,
                          child: Container(
                            color: Colors.white,
                            height: 70,
                            width: double.infinity,
                            child: _signData != null
                                ? Image.memory(
                                    _signData!,
                                    // fit: BoxFit.contain,
                                    height: double.infinity,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                  )
                                : _drawButton('sign'),
                          ),
                        ),
                        if (_signData != null) _deleteButton('sign'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '사인',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Stack(
                      children: [
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(4),
                          strokeWidth: 2,
                          dashPattern: const [4],
                          color: Theme.of(context).colorScheme.primary,
                          child: Container(
                            color: Colors.white,
                            height: 70,
                            width: double.infinity,
                            child: _sealData != null
                                ? Image.memory(
                                    _sealData!,
                                    // fit: BoxFit.contain,
                                    height: double.infinity,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                  )
                                : _drawButton('seal'),
                          ),
                        ),
                        if (_sealData != null) _deleteButton('seal')
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          if (widget.errorText != null)
            Text(
              widget.errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
              ),
            )
        ],
      ),
    );
  }

  Widget _drawButton(String type) {
    return Center(
      child: IconButton(
        onPressed: () async {
          final data = await showDialog(
            barrierDismissible: false,
            context: context,
            useSafeArea: false,
            builder: (context) => SignaturePad(
              type: type,
            ),
          );
          if (type == 'sign') {
            _signData = data;
          }
          if (type == 'seal') {
            _sealData = data;
          }

          setState(() {});

          if (_signData != null && _sealData != null) {
            String signData = base64Encode(_signData!);
            String sealData = base64Encode(_sealData!);
            widget.updateDatas('data:image/png;base64,$signData', 'data:image/png;base64,$sealData');
          }
        },
        icon: Icon(
          Icons.draw_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 22,
        ),
      ),
    );
  }

  Widget _deleteButton(String type) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        visualDensity: VisualDensity.compact,
        onPressed: () {
          String? signData = _signData != null ? base64Encode(_signData!) : null;
          String? sealData = _sealData != null ? base64Encode(_sealData!) : null;

          if (type == 'sign') {
            _signData = null;
            widget.updateDatas(null, sealData);
          }

          if (type == 'seal') {
            _sealData = null;
            widget.updateDatas(signData, null);
          }

          if (_signData != null && _sealData != null) {
            widget.updateDatas(null, null);
          }

          setState(() {});
        },
        icon: const Icon(
          Icons.delete_outline,
          color: Colors.red,
          size: 22,
        ),
      ),
    );
  }

  Future<Uint8List?> _convertBase64ToByte(String? base64String) async {
    try {
      final cleanedBase64String = base64String!.split(',').last;
      final bytes = base64Decode(cleanedBase64String);

      // Attempt to decode the image to check if it's valid
      await ui.instantiateImageCodec(bytes);
      // If successful, return the bytes
      return bytes;
    } catch (e) {
      // If any error occurs, return null
      return null;
    }
  }
}
