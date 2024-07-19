import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/pages/applications.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    Widget topbarItemsW = Row(
      children: [
        Text(
          '가입접수',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 17,
            // fontSize: screenWidth * 0.035,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '진행상태',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    Widget countsW = LayoutBuilder(
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
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ApplicationsPage(status: _dataList[dataIndex]['usim_act_status'])));
                            },
                            child: Column(
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
                                        fontSize: 17,
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
                            ),
                          ),
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
    );

    Widget topbarContainerW = Container(
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
                topbarItemsW,
                SizedBox(
                  height: 32,
                  width: 32,
                  child: FloatingActionButton(
                    backgroundColor: colorScheme.onPrimary,
                    elevation: 0,
                    shape: const CircleBorder(),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ApplicationsPage(status: 'A')));
                    },
                    child: Icon(
                      Icons.east,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          countsW,
        ],
      ),
    );

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[2])),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: !_pageLoaded
            ? const SizedBox()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: isTablet ? Alignment.center : null,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (!isTablet)
                        Column(
                          children: [
                            topbarContainerW,
                            const SizedBox(height: 20),
                            _buttonGenerate(_buttonsInfo[0]),
                            const SizedBox(height: 10),
                            _buttonGenerate(_buttonsInfo[1]),
                            const SizedBox(height: 10),
                            _buttonGenerate(_buttonsInfo[2]),
                            const SizedBox(height: 10),
                            _buttonGenerate(_buttonsInfo[3]),
                          ],
                        ),
                      if (isTablet)
                        SizedBox(
                          width: 600,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              topbarContainerW,
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(child: _buttonGenerate(_buttonsInfo[0])),
                                  const SizedBox(width: 15),
                                  Expanded(child: _buttonGenerate(_buttonsInfo[1])),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(child: _buttonGenerate(_buttonsInfo[2])),
                                  const SizedBox(width: 15),
                                  Expanded(child: _buttonGenerate(_buttonsInfo[3])),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buttonGenerate(info) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    Widget titleW = Text(
      info['title'],
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 15,
      ),
    );

    Widget contentTextW = info['contentText'] != null
        ? Text(
            info['contentText'] ?? "",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 15,
            ),
          )
        : const SizedBox.shrink();

    Widget imageW = Image.asset(
      info['image'],
      width: 60,
      height: 60,
      fit: BoxFit.contain,
    );

    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.onPrimary,
      elevation: 3,
      shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          if (info['route'] != null) Navigator.pushReplacementNamed(context, info['route'], result: true);
        },
        child: isTablet
            ? Container(
                height: 150,
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageW,
                    const SizedBox(height: 10),
                    titleW,
                    const SizedBox(height: 5),
                    contentTextW,
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    imageW,
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleW,
                        const SizedBox(height: 5),
                        contentTextW,
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
      'route': '/plans',
    },
    {
      'image': 'lib/assets/icons/docs.png',
      'title': '정책보기',
      'contentText': null,
      'route': null,
    },
    {
      'image': 'lib/assets/icons/handshake.png',
      'title': '거래요청',
      'contentText': null,
      'route': '/partner-request',
    },
    {
      'image': 'lib/assets/icons/store.png',
      'title': '거래대리점',
      'contentText': null,
      'route': '/partner-request-results',
    },
  ];
  List<dynamic> _dataList = [{}];

  Future<void> _fetchData() async {
    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/actCntStatus', method: 'GET');

      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      // print(decodedRes);

      if (decodedRes['statusCode'] == 200) {
        _dataList = decodedRes['data']['act_status_cnt'];

        _pageLoaded = true;
        setState(() {});
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
