import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

class PartnerRequestResultsPage extends StatefulWidget {
  const PartnerRequestResultsPage({super.key});

  @override
  State<PartnerRequestResultsPage> createState() => _PartnerRequestResultsPageState();
}

class _PartnerRequestResultsPageState extends State<PartnerRequestResultsPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _rowItemTextGenerator(String? text) {
    return Text(
      text ?? "",
      style: const TextStyle(
        fontSize: 16,
        // fontWeight: FontWeight.w600,
      ),
    );
  }

  bool _dataLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: const Text('거래요청 상태')),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: _dataLoading
                ? const Center(child: CircularProgressIndicator())
                : _agents.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '거래가 진행중인 대리점이 존재하지 않습니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context, '/partner-request', (route) => false);
                            },
                            child: const Text('거래요청으로 가기'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                            },
                            child: const Text('홈으로 가기'),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 200),
                          child: Wrap(
                            spacing: 30,
                            runSpacing: 30,
                            children: [
                              ..._agents.map(
                                (agent) => Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  margin: EdgeInsets.zero,
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    width: 500,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            constraints: const BoxConstraints(minWidth: 150),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: agent['status'] == 'W'
                                                  ? Colors.orange
                                                  : agent['status'] == 'N'
                                                      ? Theme.of(context).colorScheme.tertiary
                                                      : Theme.of(context).colorScheme.primary,
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              agent['status_nm'] ?? "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.onPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: Container(
                                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                child: Image.network(
                                                  agent['logo_img_url'],
                                                  height: 30,
                                                  width: 150,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              agent['agent_nm'] ?? "",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "정보",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    _rowItemTextGenerator("주소:"),
                                                    const SizedBox(width: 10),
                                                    _rowItemTextGenerator(agent['address']),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    _rowItemTextGenerator("사업자번호:"),
                                                    const SizedBox(width: 10),
                                                    _rowItemTextGenerator(agent['business_num']),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    _rowItemTextGenerator("전화번호:"),
                                                    const SizedBox(width: 10),
                                                    _rowItemTextGenerator(agent['contact']),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ...agent['usim_agent_info'].map(
                                          (type) {
                                            return type['list'].length > 0
                                                ? Padding(
                                                    padding: const EdgeInsets.only(bottom: 20),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(6),
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              type['carrier_type_nm'] ?? "",
                                                              style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            ..._generateCarrierList(type['list']).entries.map(
                                                                  (e) => e.value.length > 0
                                                                      ? Padding(
                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                          child: Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                e.key ?? "",
                                                                                style: const TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 10),
                                                                              Expanded(
                                                                                child: Wrap(
                                                                                  spacing: 10,
                                                                                  runSpacing: 15,
                                                                                  children: List.generate(
                                                                                    e.value.length,
                                                                                    (index) => ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(50),
                                                                                      child: Container(
                                                                                        padding: const EdgeInsets.all(7),
                                                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                                                        child: Image.network(
                                                                                          e.value[index]['image_url'],
                                                                                          width: 100,
                                                                                          height: 25,
                                                                                          fit: BoxFit.contain,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : const SizedBox.shrink(),
                                                                ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  List _agents = [];

  Future<void> _fetchData() async {
    _agents = [];

    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/getContractAgentInfo', method: 'GET');
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      if (decodedRes['data'] == null || decodedRes['data']?.length < 0) throw (decodedRes['message'] ?? 'No agent found');

      // print(decodedRes);

      _agents = decodedRes['data'];
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      _dataLoading = false;
      setState(() {});
    }
  }

  Map _generateCarrierList(List list) {
    Map<String, List<dynamic>> carriers = {'KT': [], 'SK': [], 'LG': []};

    for (var carrierCd in carriers.keys) {
      for (var item in list) {
        if (item['carrier_cd'] == carrierCd) {
          carriers[carrierCd]!.add(item);
        }
      }
    }

    return carriers;
  }
}
