import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/agree_draw_popup_content.dart';
import 'package:mobile_manager_simpass/components/sign_and_seal_popup_content.dart';
import 'dart:ui' as ui;

class SignatureContainer extends StatefulWidget {
  final String? signData;
  final String? sealData;
  final String? overlayName;
  final String? padTitle;
  final String? errorText;
  final String? type;
  final Function(Uint8List, Uint8List)? saveSigns;

  final Function(Uint8List)? saveAgree;

  const SignatureContainer({
    super.key,
    this.sealData,
    this.signData,
    this.saveSigns,
    this.overlayName,
    this.padTitle,
    this.type,
    this.saveAgree,
    this.errorText,
  });

  @override
  State<SignatureContainer> createState() => _SignatureContainerState();
}

class _SignatureContainerState extends State<SignatureContainer> {
  Uint8List? _signData;
  Uint8List? _sealData;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();

    _setData();
  }

  Future<void> _setData() async {
    _signData = await _convertBase64ToByte(widget.signData);
    _sealData = await _convertBase64ToByte(widget.sealData);
    _dataLoaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.padTitle != null)
          Text(
            widget.padTitle!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        const SizedBox(height: 8),
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(4),
          strokeWidth: 2,
          dashPattern: const [4],
          color: Theme.of(context).colorScheme.primary,
          child: Container(
            height: 100,
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 350),
            color: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.all(5),
            child: _dataLoaded && _signData != null || _sealData != null
                ? Stack(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (_signData != null)
                            Expanded(
                              child: Container(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.01),
                                  child: Image.memory(
                                    _signData!,
                                    // fit: BoxFit.contain,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                  )),
                            ),
                          const SizedBox(width: 5),
                          if (_sealData != null)
                            Expanded(
                              child: Container(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.01),
                                  child: Image.memory(
                                    _sealData!,
                                    // fit: BoxFit.contain,
                                    height: double.infinity,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                  )),
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
                              _signData = null;
                              _sealData = null;
                            });
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  )
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () async {
                        if (widget.type == 'agree') {
                          final agreeData = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => const AgreeDrawPad(),
                          );

                          _signData = agreeData;
                          if (widget.saveAgree != null) {
                            await widget.saveAgree!(agreeData);
                          }
                        } else {
                          final [signData, sealData] = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.all(20),
                              child: SingNaturePads(
                                overlayName: widget.overlayName,
                              ),
                            ),
                          );

                          _signData = signData;
                          _sealData = sealData;
                          if (widget.saveSigns != null) {
                            await widget.saveSigns!(signData, sealData);
                          }
                        }

                        setState(() {});
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
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                fontSize: 13,
                color: Color.fromARGB(255, 255, 17, 0),
              ),
            ),
          ),
      ],
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
