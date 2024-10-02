import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/auth.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/show_home_page_popup.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/pages/applications.dart';
import 'package:mobile_manager_simpass/utils/notification.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                                    fontSize: 10,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _dataList[dataIndex]['cnt'].toString(),
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 0.8,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      "건",
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontSize: 12,
                                        height: 1,
                                      ),
                                      textAlign: TextAlign.end,
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

    Widget topbarContainerW = Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.primary,
      elevation: 3,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthGuard(child: ApplicationsPage(status: 'A'))));
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
      appBar: AppBar(title: const Text('홈')),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: !_pageLoaded
            ? const SizedBox()
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 110,
                  ),
                  child: Align(
                    alignment: isTablet ? Alignment.center : Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isTablet)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
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
                              width: 500,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
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
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          // const SizedBox(height: 40),
                        ],
                      ),
                    ),
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
        ? Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              info['contentText'] ?? "",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 15,
              ),
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
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          if (info['route'] == '/htmls') {
            Navigator.pushNamed(context, info['route']);
            return;
          }

          if (info['route'] != null) {
            Navigator.pushReplacementNamed(context, info['route'], result: true);
            return;
          }

          // if (info['route'] == null) {
          //   showWarningDailogue(context, '현재 정책보기 서비스는 개발진행중 입니다.', ['빠른시일내 서비스 제공해 드리겠습니다. ^^']);
          // }
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
      'image': 'assets/icons/sim.png',
      'title': '후불/선불유심',
      'contentText': '가입신청서',
      'route': '/plans',
    },
    {
      'image': 'assets/icons/docs.png',
      'title': '정책보기',
      'contentText': null,
      'route': '/htmls',
    },
    {
      'image': 'assets/icons/handshake.png',
      'title': '거래요청',
      'contentText': null,
      'route': '/partner-request',
    },
    {
      'image': 'assets/icons/store.png',
      'title': '거래대리점',
      'contentText': null,
      'route': '/partner-request-results',
    },
  ];
  List<dynamic> _dataList = [{}];

  Future<void> _fetchData() async {
    // print('home page fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/actCntStatus', method: 'GET');

      if (response.statusCode != 200) throw 'Home request error';

      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      _dataList = decodedRes['data']['act_status_cnt'];
      _pageLoaded = true;
      setState(() {});

      await _fetchHomeInfo();
      await _updateDeviceData();
    } catch (e) {
      // print('homepage error: $e');
      // showCustomSnackBar(e.toString());
    }
  }

  Map homeInfo = {};

  Future<void> _fetchHomeInfo() async {
    // print('home page fetch home info called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/homeInfo', method: 'GET');

      if (response.statusCode != 200) throw 'Home info request error';

      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      homeInfo = decodedRes['data'];
      _pageLoaded = true;
      setState(() {});

      if (homeInfo['contract_status'] == 'P' || homeInfo['contract_status'] == 'N') {
        if (mounted) {
          await showHomePagePopup(
            context,
            homeInfo['contract_status'],
            homeInfo['agent_info_list'] ?? [],
          );
        }
      }
    } catch (e) {
      // print('homepage error: $e');
      showCustomSnackBar(e.toString());
    }
  }

  Future<void> _updateDeviceData() async {
    await Firebase.initializeApp();
    final notificationService = NotificationService();
    await notificationService.init();
    String? fcmToken = await notificationService.requestPermissions();

    if (fcmToken != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('fcmToken', fcmToken);
    }

    try {
      final response = await Request().requestWithRefreshToken(
        url: 'setFcmToken',
        method: 'POST',
        body: {
          "fcm_token": fcmToken,
          "platform": Platform.operatingSystem,
          "version": "1.0.0",
        },
      );
      await jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
