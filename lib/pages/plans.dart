import 'dart:convert';
import 'dart:math';
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
  int? _selectedMvnoIndex = 0;

  final TextEditingController _searchTextCntr = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final ScrollController _verticalScrollController = ScrollController();

  int _randomNum = Random().nextInt(100);

  @override
  void initState() {
    super.initState();
    _fetchMvnos();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchTextCntr.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  void _animateScroll() {
    if (_scrollController.hasClients) {
      _scrollController
          .animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      )
          .then((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        });
      });
    }
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
          _randomNum = Random().nextInt(100);
        },
        child: SingleChildScrollView(
          controller: _verticalScrollController,
          physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
          // physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            // height: double.infinity,
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
                // card button for mvnos

                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(width: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    itemCount: _mvnos.length + 1,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                _selectedMvnoIndex = 0;
                                _selectedMvno = "";
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: _selectedMvnoIndex == index
                                      ? Border.all(
                                          color: Theme.of(context).colorScheme.primary,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                height: 200,
                                width: 100,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: Colors.orange,
                                      size: 40,
                                    ),
                                    Text(
                                      '즐겨찾기',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      Map mvno = _mvnos[index - 1];
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
                                  _selectedMvno = mvno['mvno_cd'];
                                  _selectedCarrier = mvno['carrier_cd'];
                                  _selectedMvnoIndex = null;
                                  setState(() {});
                                  // await _fetchPlans();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: _selectedMvno == mvno['mvno_cd']
                                        // border: _selectedMvnoIndex == index
                                        ? Border.all(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Image.network(
                                    mvno['image_url'],
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
                              mvno['carrier_nm'],
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
                  key: ValueKey(_selectedType + _selectedCarrier + _selectedMvno + _selectedMvnoIndex.toString() + _randomNum.toString()),
                  typeCd: _selectedType,
                  carrierCd: _selectedCarrier,
                  mvnoCd: _selectedMvno,
                  onlyFavorites: _selectedMvnoIndex == 0,
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
    _selectedMvno = "";
    setState(() {});

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

        // Schedule the scroll animation after the build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _animateScroll();
        });
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
