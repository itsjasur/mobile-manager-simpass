import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

class PartnerRequestPage extends StatefulWidget {
  const PartnerRequestPage({super.key});

  @override
  State<PartnerRequestPage> createState() => _PartnerRequestPageState();
}

class _PartnerRequestPageState extends State<PartnerRequestPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('거래요청')),
      body: Container(),
    );
  }

  List _partners = [];

  Future<void> _fetchData() async {
    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/getAgentInfo', method: 'GET');
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      if (decodedRes['data']?.length > 0) throw 'Fetch get Agent info error';

      _partners = decodedRes['data'];

      // print(decodedRes);

      setState(() {});
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
