import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/show_html.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/pages/terms.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _passwordCntr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[5])),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    onTap: () {
                      // showHtmlContentPopup(context, 'privacy');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsPage(type: 'privacy')));
                    },
                    minLeadingWidth: 200,
                    minTileHeight: 55,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: Colors.white,
                    title: const Text(
                      '개인정보보호정책',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    onTap: () {
                      // showHtmlContentPopup(context, 'useterms');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsPage(type: 'useterms')));
                    },
                    minLeadingWidth: 200,
                    minTileHeight: 55,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: Colors.white,
                    title: const Text(
                      '이용약관',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        //  barrierDismissible: false,
                        // barrierColor: Colors.white,
                        useRootNavigator: true,
                        context: context,
                        builder: (context) => Dialog(
                          surfaceTintColor: Colors.transparent,
                          backgroundColor: Colors.white,
                          child: SingleChildScrollView(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '회원탈퇴하려면 아래에 비밀번호를 입력하세요.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextFormField(
                                    obscureText: true,
                                    controller: _passwordCntr,
                                    decoration: const InputDecoration(
                                      label: Text('비밀번호'),
                                    ),
                                    // errorText: _submitted ? InputValidator().validatePass(_passwordCntr.text) : null,
                                    onChanged: (p0) => setState(() {}),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('취소'),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          onPressed: _terminating ? null : _terminateAccount,
                                          child: _terminating
                                              ? const SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Text('회원탈퇴'),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    minLeadingWidth: 200,
                    minTileHeight: 55,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: Colors.white,
                    title: const Text(
                      '회원탈퇴',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  bool _terminating = false;

  Future<void> _terminateAccount() async {
    _terminating = true;
    setState(() {});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('username');

    if (userName == null) {
      showCustomSnackBar('Username is not given');
      return;
    }

    try {
      final response = await Request().requestWithRefreshToken(url: 'admin/memberCancel', method: 'POST', body: {
        "username": userName,
        "password": _passwordCntr.text,
      });

      Map decodedRes = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        showCustomSnackBar(decodedRes['message'] ?? "Account terminated");
        if (mounted) Navigator.pop(context);
        if (mounted) Provider.of<AuthenticationModel>(context, listen: false).logout();
        return;
      }

      _terminating = false;
      setState(() {});
      showCustomSnackBar(decodedRes['message'] ?? "Account terminate request error");
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
