import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _controller = TextEditingController();

  final InputFormatter _formatter = InputFormatter();

  final MaskTextInputFormatter _formatter2 = MaskTextInputFormatter(
    mask: '##/##/##/##',
    filter: {"#": RegExp(r'[0-9]')},
    // type: MaskAutoCompletionType.eager,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextFormField(
            controller: _controller,
            inputFormatters: [_formatter2],
            // inputFormatters: [_formatter.phoneNumber],
            onChanged: (p0) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
