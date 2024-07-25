import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/popup_header.dart';

Future<void> showHomePagePopup(BuildContext context, String contractStatus, List agentsInfo) async {
  await showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Stack(
            children: [
              HomePagePopupContent(contractStatus: contractStatus, agentsIngo: agentsInfo),
              const PopupHeader(title: ''),
            ],
          ),
        ),
      ),
    ),
  );
}

class HomePagePopupContent extends StatefulWidget {
  final String contractStatus;
  final List agentsIngo;
  const HomePagePopupContent({super.key, required this.contractStatus, required this.agentsIngo});

  @override
  State<HomePagePopupContent> createState() => _HomePagePopupContentState();
}

class _HomePagePopupContentState extends State<HomePagePopupContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45, left: 20, right: 20, bottom: 20),
      child: SingleChildScrollView(
        child: widget.contractStatus == 'P'
            ? Column(
                children: [
                  _textBuilder('현재, 아래 대리점과 자동거래승인이 되어 대리점과 거래계약서에 자필서명을 완료해 주시면 정상적으로 서비스를이용하실 수 있습니다.'),
                  ...widget.agentsIngo.map(
                    (e) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            e['logo_img_url'],
                            width: 100,
                            fit: BoxFit.fitWidth,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            e['agent_nm'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/partner-request-results');
                    },
                    child: const Text('대리점계약 서명하기'),
                  ),
                ],
              )
            : Column(
                children: [
                  _textBuilder('현재 거래대리점이 존재하지 않습니다.'),
                  const SizedBox(height: 10),
                  _textBuilder('대리점과 거래계약이 되어야 정상적으로 서비스를 이용하실 수 있습니다. '),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/partner-request');
                    },
                    child: const Text('대리점거래 요청하기'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _textBuilder(text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
