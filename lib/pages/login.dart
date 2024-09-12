import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/info_text.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/utils/validators.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../sensitive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final TextEditingController _userNameCntr = TextEditingController();
  // final TextEditingController _passwordCntr = TextEditingController();
  final TextEditingController _userNameCntr = TextEditingController(text: MYID__);
  final TextEditingController _passwordCntr = TextEditingController(text: MYPASS__);

  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    '판매점 아이디 와 비밀번호를 입력하세요',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    controller: _userNameCntr,
                    decoration: const InputDecoration(
                      label: Text('판매점 아이디'),
                    ),
                    errorText: _submitted ? InputValidator().validateId(_userNameCntr.text) : null,
                    onChanged: (p0) => setState(() {}),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    obscureText: true,
                    controller: _passwordCntr,
                    decoration: const InputDecoration(
                      label: Text('비밀번호'),
                    ),
                    errorText: _submitted ? InputValidator().validatePass(_passwordCntr.text) : null,
                    onChanged: (p0) => setState(() {}),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _submitted = true;
                        setState(() {});
                        if (InputValidator().validatePass(_passwordCntr.text) == null && InputValidator().validateId(_userNameCntr.text) == null) _login();
                        _login();
                      },
                      child: const Text('로그인'),
                    ),
                  ),
                  const Divider(
                    height: 60,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.black12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA927),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text('판매점 계약 접수'),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const InfoText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse('${BASEURL}auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "username": _userNameCntr.text,
          "password": _passwordCntr.text,
        }),
      );

      if (response.statusCode != 200) throw '로그인 또는 비밀번호가 잘못되었습니다.';

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _userNameCntr.text);
      await prefs.setString('password', _passwordCntr.text);

      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      print(decodedRes);
      if (mounted) await Provider.of<AuthenticationModel>(context, listen: false).login(decodedRes['accessToken'], decodedRes['refreshToken'], decodedRes['username']);
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
