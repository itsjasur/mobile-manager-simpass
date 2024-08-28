import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'dart:developer' as developer;

showPartnerContract(BuildContext context, String agentCode) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: PartnersContractViewer(agentCode: agentCode),
      ),
    ),
  );
}

class PartnersContractViewer extends StatefulWidget {
  final String agentCode;
  const PartnersContractViewer({super.key, required this.agentCode});

  @override
  State<PartnersContractViewer> createState() => PartnersContractViewerState();
}

class PartnersContractViewerState extends State<PartnersContractViewer> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Uint8List? _pdf;
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _pdf != null
              ? SfPdfViewer.memory(_pdf!)
              : const SizedBox.shrink(),
    );
  }

  Future<void> _fetchData() async {
    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(
        url: 'agent/contractForms',
        method: 'POST',
        body: {
          'agent_cd': widget.agentCode,
        },
      );
      final pdfData = response.bodyBytes;
      _pdf = pdfData;
      setState(() {});
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      _loading = false;
      setState(() {});
    }
  }
}
