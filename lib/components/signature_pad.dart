import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/signature_pad_popup_content.dart';

class SignNaturePad extends StatefulWidget {
  final String? nameData;
  final String? signData;
  final Function(Uint8List, Uint8List) saveData;

  const SignNaturePad({super.key, this.signData, this.nameData, required this.saveData});

  @override
  State<SignNaturePad> createState() => _SignNaturePadState();
}

class _SignNaturePadState extends State<SignNaturePad> {
  Uint8List? _nameData;
  Uint8List? _signData;

  @override
  void initState() {
    super.initState();
    _nameData = _convertBase64ToByte(widget.nameData);
    _signData = _convertBase64ToByte(widget.signData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 350),
      // width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: _nameData != null || _signData != null
          ? Stack(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.01),
                        child: _nameData != null
                            ? Image.memory(
                                _nameData!,
                                // fit: BoxFit.contain,
                                height: double.infinity,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.01),
                        child: _signData != null
                            ? Image.memory(
                                _signData!,
                                // fit: BoxFit.contain,
                                height: double.infinity,
                                width: double.infinity,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
                Positioned(
                    right: -6,
                    top: -6,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        setState(() {
                          _nameData = null;
                          _signData = null;
                        });
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ))
              ],
            )
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () async {
                  await showDialog(
                    barrierDismissible: false,
                    useSafeArea: true,
                    context: context,
                    builder: (context) => SingNaturePads(
                      saveData: ((nameD, signD) {
                        widget.saveData(nameD, signD);

                        _nameData = nameD;
                        _signData = signD;
                        setState(() {});
                      }),
                      overlayName: "Jasur",
                    ),
                  );

                  print('show dialogue content');
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Icon(
                    Icons.draw_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                ),
              ),
            ),
    );
  }

  Uint8List? _convertBase64ToByte(String? base64String) {
    if (base64String != null) {
      // removes the data:image/png;base64, prefix if present
      final cleanedBase64String = base64String.split(',').last;
      // decods the Base64 string
      final bytes = base64Decode(cleanedBase64String);
      // creates an Image widget using the decoded bytes
      return bytes;
    }

    return null;
  }
}
