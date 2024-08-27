import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_manager_simpass/components/signature_agree_pad.dart';
import 'dart:ui' as ui;

class SignatureAgreeContainer extends StatefulWidget {
  final String? title;
  final String? errorText;
  final String? agreeData;
  final Function(String?) updateData;

  const SignatureAgreeContainer({super.key, this.title = 'Pad title', required this.updateData, this.agreeData, this.errorText});

  @override
  State<SignatureAgreeContainer> createState() => _SignatureAgreeContainerState();
}

class _SignatureAgreeContainerState extends State<SignatureAgreeContainer> {
  Uint8List? _agreeData;

  @override
  void initState() {
    super.initState();
    _setData();
  }

  Future<void> _setData() async {
    if (widget.agreeData != null) {
      _agreeData = await _convertBase64ToByte(widget.agreeData);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
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
                            height: 60,
                            width: double.infinity,
                            child: _agreeData != null
                                ? Image.memory(
                                    _agreeData!,
                                    // fit: BoxFit.contain,
                                    height: double.infinity,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                  )
                                : _drawButton(),
                          ),
                        ),
                        if (_agreeData != null) _deleteButton(),
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

  Widget _drawButton() {
    return Center(
      child: IconButton(
        onPressed: () async {
          final data = await showDialog(
            barrierDismissible: false,
            context: context,
            useSafeArea: false,
            builder: (context) => const SignatureAgreePad(),
          );

          _agreeData = data;
          setState(() {});
          if (data != null) {
            String stringData = base64Encode(data!);
            widget.updateData('data:image/png;base64,$stringData');
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

  Widget _deleteButton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        visualDensity: VisualDensity.compact,
        onPressed: () {
          _agreeData = null;
          setState(() {});
          widget.updateData(null);
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
