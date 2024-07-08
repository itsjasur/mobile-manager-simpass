import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/utils/validators.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameCntr = TextEditingController(text: 'SM00001');
  final TextEditingController _passwordCntr = TextEditingController(text: 'SM00001');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
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
                      TextFormField(
                        controller: _userNameCntr,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          label: Text('판매점 아이디'),
                        ),
                        validator: InputValidator().validateId,
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordCntr,
                        decoration: const InputDecoration(
                          label: Text('비밀번호'),
                        ),
                        validator: InputValidator().validatePass,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) _login();
                        },
                        child: const Text('로그인'),
                      ),
                      const Divider(
                        height: 60,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.black12,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA927),
                        ),
                        onPressed: () {},
                        child: const Text('판매점 계약 접수'),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        """상호 : 심패스(Simpass) | 대표 : 김익태 | 대표전화 : 02-2108-3121 | FAX : 02-2108-3120 사업자등록번호 : 343-18-00713 | 통신판매신고번호 : 제 2021-서울구로-1451 호 서울시 구로구 디지털로33길 28, 우림이비지센터 1차 1210호""",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
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

      if (response.statusCode == 200 && mounted) {
        Map data = jsonDecode(response.body);
        await Provider.of<AuthenticationModel>(context, listen: false).login(data['accessToken'], data['refreshToken']);
        return;
      }

      throw 'Login error';
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
