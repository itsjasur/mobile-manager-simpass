import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/plans_list_widget.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  final List _types = [
    {'code': 'PO', 'name': '후불'},
    {'code': 'PR', 'name': '선불'},
  ];

  final List _carriers = [
    {'code': '', 'name': '전체', 'url': null},
    {'code': 'KT', 'name': 'KT', 'url': 'assets/logos/kt.png'},
    {'code': 'SK', 'name': 'SKT', 'url': 'assets/logos/skt.png'},
    {'code': 'LG', 'name': 'LG U+', 'url': 'assets/logos/lgu.png'},
  ];

  List _mvnos = [];

  String _selectedType = 'PO';
  String _selectedCarrier = '';
  String _selectedMvno = '';

  final TextEditingController _searchTextCntr = TextEditingController();

  // bool _loading = true;
  // bool _mvnosLoading = true;
  // bool _plansLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMvnos();
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextCntr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[2])),
      body: RefreshIndicator(
        onRefresh: () async {
          _selectedCarrier = '';
          await _fetchMvnos();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: _types
                      .map(
                        (item) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: displayWidth > 600 ? const Size(100, 45) : null,
                            elevation: 0,
                            backgroundColor: _selectedType == item['code'] ? null : Theme.of(context).colorScheme.tertiary,
                          ),
                          onPressed: () async {
                            _selectedType = item['code'];

                            setState(() {});
                            await _fetchMvnos();
                          },
                          child: Text(item['name']),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: _carriers
                      .map(
                        (item) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            minimumSize: displayWidth > 600 ? const Size(100, 45) : null,
                            elevation: 0,
                            backgroundColor: _selectedCarrier == item['code'] ? null : Theme.of(context).colorScheme.tertiary,
                          ),
                          onPressed: () async {
                            _selectedCarrier = item['code'];
                            setState(() {});
                            await _fetchMvnos();
                          },
                          child: Text(item['name']),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 90,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(width: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  itemCount: _mvnos.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () async {
                                _selectedMvno = _mvnos[index]['mvno_cd'];
                                _selectedCarrier = _mvnos[index]['carrier_cd'];

                                setState(() {});
                                // await _fetchPlans();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: _selectedMvno == _mvnos[index]['mvno_cd']
                                      ? Border.all(
                                          color: Theme.of(context).colorScheme.primary,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: Image.network(
                                  _mvnos[index]['image_url'],
                                  fit: BoxFit.fitWidth,
                                  width: 150,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 10,
                          child: Text(
                            _mvnos[index]['carrier_nm'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              PlansListWidget(
                key: ValueKey(_selectedType + _selectedCarrier + _selectedMvno),
                typeCd: _selectedType,
                carrierCd: _selectedCarrier,
                mvnoCd: _selectedMvno,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchMvnos() async {
    _mvnos.clear();
    _selectedMvno = "";

    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/applyCarrier', method: 'POST', body: {
        "carrier_type": _selectedType, // 선불:PR ,후불:PO
        "carrier_cd": _selectedCarrier // SKT : SK ,KT : KT,LG U+ : LG
      });
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      // print(decodedRes);

      if (decodedRes['statusCode'] != 200) throw decodedRes['message'] ?? 'Fetch data error';

      if (decodedRes['statusCode'] == 200) {
        _mvnos = decodedRes['data']['info'];
        setState(() {});
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
