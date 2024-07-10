import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

class FormsPage extends StatefulWidget {
  const FormsPage({super.key});

  @override
  State<FormsPage> createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  final List _types = [
    {'code': 'PO', 'name': '후붛'},
    {'code': 'PR', 'name': '선불'},
  ];

  final List _carriers = [
    {'code': '', 'name': '전체', 'url': null},
    {'code': 'KT', 'name': 'KT', 'url': 'lib/assets/logos/kt.png'},
    {'code': 'SK', 'name': 'SKT', 'url': 'lib/assets/logos/skt.png'},
    {'code': 'LG', 'name': 'LG U+', 'url': 'lib/assets/logos/lgu.png'},
  ];

  List _mvnos = [];

  List _plans = [];

  String _selectedType = 'PO';
  String _selectedCarrier = '';
  String _selectedMvno = '';

  // bool _loading = true;
  // bool _mvnosLoading = true;
  // bool _plansLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMvnos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[2])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: _types
                    .map(
                      (item) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 45),
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
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: _carriers
                    .map(
                      (item) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 45),
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
            const SizedBox(height: 30),
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
                              await _fetchPlans();
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
                            // color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              // height: 60,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                itemCount: _plans.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return _buildCardWwidget(_plans[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWwidget(item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Material(
        color: Theme.of(context).colorScheme.onPrimary,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['usim_plan_nm'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.signal_cellular_alt,
                      size: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      (item['cell_data'] ?? "") + (item['qos'] ?? ""),
                      style: const TextStyle(
                        // fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item['voice'] ?? "",
                      style: const TextStyle(
                        // fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item['message'] ?? "",
                      style: const TextStyle(
                        // fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${InputFormatter().wonify(item['sales_fee'])} 원/월",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchMvnos() async {
    _mvnos.clear();
    _plans.clear();
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

  Future<void> _fetchPlans() async {
    _plans.clear();

    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/planlist', method: 'POST', body: {
        "carrier_type": _selectedType, // 선불:PR ,후불:PO
        "carrier_cd": _selectedCarrier, // SKT : SK ,KT : KT,LG U+ : LG
        "mvno_cd": _selectedMvno,
        "usim_plan_nm": ""
      });
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      // print(decodedRes);

      if (decodedRes['statusCode'] != 200) throw decodedRes['message'] ?? 'Fetch data error';

      if (decodedRes['statusCode'] == 200) {
        _plans = decodedRes['data']['info'];
        setState(() {});
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
