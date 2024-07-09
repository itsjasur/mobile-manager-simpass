import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignNaturePad extends StatefulWidget {
  const SignNaturePad({super.key});

  @override
  State<SignNaturePad> createState() => _SignNaturePadState();
}

class _SignNaturePadState extends State<SignNaturePad> {
  @override

  // initialize the signature controller
  final SignatureController _signController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();

    _signController
      ..addListener(() => print('Value changed'))
      ..onDrawEnd = () => setState(
            () {},
          );
  }

  @override
  void dispose() {
    _signController.dispose();
    super.dispose();
  }

  void _clear() {
    _signController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 800,
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Signature(
          key: const Key('signature'),
          controller: _signController,
          height: 300,
          backgroundColor: Colors.black12,
        ),
      ),
    );
  }
}
