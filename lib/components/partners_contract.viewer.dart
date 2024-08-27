import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      // body: SfPdfViewer.asset(
      //   'assets/aaa.pdf',
      // ),
    );
  }

  // Future<void> _fetchData() async {
  //   // print('fetch data called');
  //   try {
  //     final response = await Request().requestWithRefreshToken(url: 'agent/partnerInfo', method: 'GET');
  //     Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

  //     if (decodedRes['statusCode'] == 200) {
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     print('profile error: $e');
  //     showCustomSnackBar(e.toString());
  //   }
  // }
}
