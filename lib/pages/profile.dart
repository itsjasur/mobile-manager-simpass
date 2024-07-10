import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/components/signature_pad.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

class ProfilePafe extends StatefulWidget {
  const ProfilePafe({super.key});

  @override
  State<ProfilePafe> createState() => _ProfilePafeState();
}

class _ProfilePafeState extends State<ProfilePafe> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  bool _pageLoaded = false;

  Map _data = {};

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Widget partnerCdW = TextFormField(
      decoration: const InputDecoration(
        label: Text('판매점 아이디'),
      ),
      initialValue: _data['partner_cd'],
      readOnly: true,
    );

    Widget partnerNameW = TextFormField(
      decoration: const InputDecoration(
        label: Text('판매점 판매점명'),
      ),
      initialValue: _data['partner_nm'],
      readOnly: true,
    );
    Widget directorNameW = TextFormField(
      decoration: const InputDecoration(
        label: Text('대표자명'),
      ),
      initialValue: _data['contractor'],
      readOnly: true,
    );
    Widget busNumW = TextFormField(
      decoration: const InputDecoration(
        label: Text('사업자번호'),
      ),
      initialValue: InputFormatter().businessNumber.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: _data['business_num'] ?? "")).text,
      readOnly: true,
    );
    Widget contactW = TextFormField(
      decoration: const InputDecoration(
        label: Text('연락처'),
      ),
      initialValue: InputFormatter().phoneNumber.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: _data['phone_number'] ?? "")).text,
      readOnly: true,
      inputFormatters: [InputFormatter().phoneNumber],
    );

    Widget emailW = TextFormField(
      decoration: const InputDecoration(
        label: Text('이메일'),
      ),
      initialValue: _data['email'],
      readOnly: true,
    );

    Widget addressW = TextFormField(
      decoration: const InputDecoration(
        label: Text('매장주소'),
      ),
      initialValue: _data['address'],
      readOnly: true,
    );

    Widget addressdetailsW = TextFormField(
      decoration: const InputDecoration(
        label: Text('매장상세주소'),
      ),
      initialValue: _data['dtl_address'],
      readOnly: true,
    );

    Widget rowBuilder(item1, item2) {
      if (screenWidth > 600) {
        return Row(
          children: [
            Expanded(child: item1),
            const SizedBox(width: 20),
            Expanded(child: item2),
          ],
        );
      } else {
        return Column(
          children: [
            item1,
            const SizedBox(height: 20),
            item2,
          ],
        );
      }
    }

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[2])),
      body: !_pageLoaded
          ? const SizedBox()
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '가입신청/고객정보',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    rowBuilder(partnerCdW, partnerNameW),
                    const SizedBox(height: 20),
                    rowBuilder(directorNameW, busNumW),
                    const SizedBox(height: 20),
                    rowBuilder(contactW, emailW),
                    const SizedBox(height: 20),
                    rowBuilder(addressW, addressdetailsW),
                    const SizedBox(height: 20),
                    const Text(
                      '판매자 서명',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 350),
                      child: SignNaturePad(
                        nameData: _signData,
                        signData: _sealData,
                        saveData: (signData, sealData) {
                          _signData = base64Encode(signData);
                          _sealData = base64Encode(sealData);
                          ;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    IntrinsicWidth(
                      child: ElevatedButton(
                        onPressed: _saveSigns,
                        child: const Text('사인 저장'),
                      ),
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
    );
  }

  String? _signData;
  String? _sealData;

  Future<void> _fetchData() async {
    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/partnerInfo', method: 'GET');
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      // print(decodedRes);

      if (decodedRes['statusCode'] == 200) {
        _data = decodedRes['data']['info'];

        _signData = _data['partner_sign'];
        _sealData = _data['partner_seal'];

        _pageLoaded = true;
        setState(() {});
      }
    } catch (e) {
      // showCustomSnackBar(e.toString());
    }
  }

  Future<void> _saveSigns() async {
    if (_signData == null || _sealData == null) {
      showCustomSnackBar('저장할 이미지가 없습니다.');
      return;
    }

    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/setActSign', method: 'POST', body: {
        "partner_sign": 'data:image/png;base64,$_signData',
        "partner_seal": 'data:image/png;base64,$_sealData',
      });
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      showCustomSnackBar(decodedRes['message']);
      setState(() {});
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
