import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  bool _pageLoaded = false;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[2])),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            // physics: const AlwaysScrollableScrollPhysics(),
            child: !_pageLoaded
                ? const SizedBox()
                : Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorScheme.primary,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '진행상태',
                                            style: TextStyle(
                                              color: colorScheme.onPrimary,
                                              fontSize: 18,
                                              // fontSize: screenWidth * 0.035,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '진행상태',
                                            style: TextStyle(
                                              color: colorScheme.onPrimary,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Progress',
                                        style: TextStyle(
                                          color: colorScheme.onPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: FloatingActionButton(
                                      backgroundColor: colorScheme.onPrimary,
                                      elevation: 0,
                                      shape: const CircleBorder(),
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.east,
                                        color: colorScheme.primary,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: List.generate(
                                            _dataList.length * 2 - 1,
                                            (index) {
                                              if (index.isOdd) {
                                                return VerticalDivider(
                                                  color: colorScheme.onPrimary,
                                                  indent: 5,
                                                  endIndent: 5,
                                                  width: 20,
                                                );
                                              } else {
                                                final dataIndex = index ~/ 2;
                                                return Column(
                                                  children: [
                                                    Text(
                                                      _dataList[dataIndex]['usim_act_status_nm'] ?? "",
                                                      style: TextStyle(
                                                        color: colorScheme.onPrimary,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          _dataList[dataIndex]['cnt'].toString(),
                                                          style: TextStyle(
                                                            color: colorScheme.onPrimary,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 3),
                                                        Text(
                                                          "건",
                                                          style: TextStyle(
                                                            color: colorScheme.onPrimary,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      ...List.generate(
                        _buttonsInfo.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          child: _buttonGenerate(
                            _buttonsInfo[index],
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

  Widget _buttonGenerate(info) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      elevation: 3,
      shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Image.asset(
                info['image'],
                width: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (info['contentText'] != null)
                    Text(
                      info['contentText'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 15,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<dynamic> _buttonsInfo = [
    {
      'image': 'lib/assets/icons/sim.png',
      'title': '후불/선불유심',
      'contentText': '가입신청서',
    },
    {
      'image': 'lib/assets/icons/docs.png',
      'title': '정책보기',
      'contentText': null,
    },
    {
      'image': 'lib/assets/icons/handshake.png',
      'title': '거래요청',
      'contentText': null,
    },
    {
      'image': 'lib/assets/icons/store.png',
      'title': '후불/선불유심',
      'contentText': null,
    },
  ];
  List<dynamic> _dataList = [{}];

  Future<void> _fetchData() async {
    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/actCntStatus', method: 'GET');

      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      print(decodedRes);

      if (decodedRes['statusCode'] == 200) {
        _dataList = decodedRes['data']['act_status_cnt'];

        _pageLoaded = true;
        setState(() {});
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
