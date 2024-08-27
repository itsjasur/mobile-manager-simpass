import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/components/signature_agree_container.dart';
import 'package:mobile_manager_simpass/components/signature_pads_container.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:mobile_manager_simpass/utils/validators.dart';

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

  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passReentryController = TextEditingController();

  bool _submitted = false;
  bool _isPasswordUpdating = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Widget partnerCdW = CustomTextFormField(
      decoration: const InputDecoration(
        label: Text('판매점 아이디'),
      ),
      initialValue: _data['partner_cd'],
      readOnly: true,
    );

    Widget partnerNameW = CustomTextFormField(
      decoration: const InputDecoration(
        label: Text('판매점 판매점명'),
      ),
      initialValue: _data['partner_nm'],
      readOnly: true,
    );
    Widget directorNameW = CustomTextFormField(
      decoration: const InputDecoration(
        label: Text('대표자명'),
      ),
      initialValue: _data['contractor'],
      readOnly: true,
    );
    Widget busNumW = CustomTextFormField(
      decoration: const InputDecoration(
        label: Text('사업자번호'),
      ),
      initialValue: InputFormatter().businessNumber.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: _data['business_num'] ?? "")).text,
      readOnly: true,
    );
    Widget contactW = CustomTextFormField(
      decoration: const InputDecoration(
        label: Text('연락처'),
      ),
      initialValue: InputFormatter().phoneNumber.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: _data['phone_number'] ?? "")).text,
      readOnly: true,
      inputFormatters: [InputFormatter().phoneNumber],
    );

    Widget emailW = CustomTextFormField(
      decoration: const InputDecoration(
        label: Text('이메일'),
      ),
      initialValue: _data['email'],
      readOnly: true,
    );

    Widget addressW = CustomTextFormField(
      decoration: const InputDecoration(
        label: Text('매장주소'),
      ),
      initialValue: _data['address'],
      readOnly: true,
    );

    Widget addressdetailsW = CustomTextFormField(
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
          children: [item1, const SizedBox(height: 20), item2],
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
                constraints: const BoxConstraints(maxWidth: 1000),
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
                    SignaturePadsContainer(
                      title: '판매자 서명',
                      signData: _signData,
                      sealData: _sealData,
                      updateDatas: (signData, sealData) {
                        // _signData = signData != null ? base64Encode(signData) : null;
                        // _sealData = sealData != null ? base64Encode(sealData) : null;
                        _signData = signData;
                        _sealData = sealData;
                        setState(() {});
                      },
                      // errorText: 'Error text',
                    ),
                    // const SizedBox(height: 20),
                    // SignatureAgreeContainer(
                    //   title: 'Agree',
                    //   agreeData: null,
                    //   updateData: (data) {},
                    // ),
                    const SizedBox(height: 30),
                    IntrinsicWidth(
                      child: ElevatedButton(
                        onPressed: _saveSigns,
                        child: const Text('사인 저장'),
                      ),
                    ),
                    const SizedBox(height: 30),

                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '비밀번호 변경',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            decoration: const InputDecoration(
                              label: Text('현재 비밀번호'),
                            ),
                            controller: _oldPassController,
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            decoration: const InputDecoration(
                              label: Text('새 비밀번호'),
                            ),
                            controller: _passController,
                            obscureText: true,
                            errorText: _submitted ? InputValidator().validatePass(_passController.text) : null,
                            onChanged: (p0) => setState(() {}),
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            decoration: const InputDecoration(
                              label: Text('새 비밀번호 확인'),
                            ),
                            controller: _passReentryController,
                            obscureText: true,
                            errorText: _submitted ? InputValidator().validateRentryPass(_passController.text, _passReentryController.text) : null,
                            onChanged: (p0) => setState(() {}),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '강력한 비밀번호를 얻으려면 이 가이드를 따르세요.',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 5),
                          _passReqTextGen('특수 문자 1개'),
                          _passReqTextGen('최소 8 글자'),
                          _passReqTextGen('숫자 1개(2개 권장'),
                          _passReqTextGen('자주 바꾸세요'),
                          const SizedBox(height: 20),
                          Container(
                            height: 50,
                            constraints: const BoxConstraints(minWidth: 150),
                            child: ElevatedButton(
                              onPressed: _isPasswordUpdating ? null : _changeMyPassword,
                              child: _isPasswordUpdating ? const CircularProgressIndicator() : const Text('비밀번호 업데이트'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _passReqTextGen(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.circle, color: Colors.black54, size: 10),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(height: 1),
          ),
        ],
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

      if (decodedRes['statusCode'] == 200) {
        _data = decodedRes['data']['info'];
        // print(_data);
        _signData = _data['partner_sign'];
        _sealData = _data['partner_seal'];

        _pageLoaded = true;
        setState(() {});
      }
    } catch (e) {
      print('profile error: $e');
      showCustomSnackBar(e.toString());
    }
  }

  Future<void> _saveSigns() async {
    if (_signData == null || _sealData == null) {
      showCustomSnackBar('저장할 이미지가 없습니다.');
      return;
    }

    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/setActSign', method: 'POST', body: {
        "partner_sign": _signData,
        "partner_seal": _sealData,
      });
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      showCustomSnackBar(decodedRes['message']);
      setState(() {});
    } catch (e) {
      // print('profile error: $e');
      showCustomSnackBar(e.toString());
    }
  }

  Future<void> _changeMyPassword() async {
    _submitted = true;
    setState(() {});

    if (_oldPassController.text.isEmpty ||
        InputValidator().validatePass(_passController.text) != null ||
        InputValidator().validateRentryPass(_passController.text, _passReentryController.text) != null) {
      showCustomSnackBar('이전 비밀번호와 새 비밀번호를 입력하세요.');
      return;
    }

    _isPasswordUpdating = true;
    setState(() {});

    try {
      var response = await Request().requestWithRefreshToken(
        url: 'admin/myPassword',
        method: 'POST',
        body: {
          "id": _data['id'],
          "username": _data['partner_cd'],
          "password": _oldPassController.text,
          "new_password": _passController.text,
        },
      );
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      // print(decodedRes);
      showCustomSnackBar(decodedRes['message'] ?? 'Password update error');
    } catch (e) {
      // print('profile error: $e');
      showCustomSnackBar(e.toString());
    } finally {
      _isPasswordUpdating = false;
      setState(() {});
    }
  }
}
