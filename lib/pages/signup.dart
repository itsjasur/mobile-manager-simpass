import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/sign_up_waiting_popup.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/validators.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final TextEditingController _employeeCodeCntr = TextEditingController();
  final TextEditingController _nameCntr = TextEditingController();
  final TextEditingController _phoneNumberCntr = TextEditingController();
  final TextEditingController _birthdayCntr = TextEditingController();

  bool _agreementChecked = false;
  bool _noEmployeeCode = false;

  final _formKey = GlobalKey<FormState>();

  bool _submitted = false;

  String _selectedCertType = 'KAKAO';

  final InputFormatter _formatter = InputFormatter();

  @override
  void initState() {
    super.initState();
    _nameCntr.text = 'SOBIRJONOV JASURBEK ARISLONBEK UGLI';
    _birthdayCntr.text = '1995-08-18';
    _phoneNumberCntr.text = '010-5818-9352';
  }

  @override
  void dispose() {
    _employeeCodeCntr.dispose();
    _nameCntr.dispose();
    _phoneNumberCntr.dispose();
    _birthdayCntr.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 70),
                    const Text(
                      '본 신청서는 심패스에서 직접 운영하는 판매점 전자계약서이며 고객님에 소중한 개인정보는 암호화되어 안전하게 보호됩니다.',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _agreementChecked,
                            onChanged: (newValue) => {
                              _agreementChecked = newValue ?? false,
                              setState(() {}),
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '개인정보 수집이용 동의 (필수)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '약관내용',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '영업사원코드 입력',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  value: _noEmployeeCode,
                                  onChanged: (newValue) => {
                                    _noEmployeeCode = newValue ?? false,
                                    setState(() {}),
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Flexible(
                                child: Text(
                                  '코드없음',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      enabled: _noEmployeeCode == false,
                      controller: _employeeCodeCntr,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        label: Text('영업사원코드'),
                      ),
                      errorText: !_noEmployeeCode && _submitted ? InputValidator().validateEmployeeCode(_employeeCodeCntr.text) : null,
                      onChanged: (p0) => setState(() {}),
                      key: ValueKey(_noEmployeeCode),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      '본인인증',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _nameCntr,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        label: Text('이름'),
                        hintText: '홍길동',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      errorText: _submitted ? InputValidator().validateName(_nameCntr.text) : null,
                      onChanged: (p0) => setState(() {}),
                    ),
                    const SizedBox(height: 30),
                    CustomTextFormField(
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      autovalidateMode: AutovalidateMode.always,
                      controller: _phoneNumberCntr,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('본인명의 휴대폰번호'),
                        hintText: '010-1234-1234',
                      ),
                      errorText: _submitted ? InputValidator().validatePhoneNumber(_phoneNumberCntr.text) : null,
                      onChanged: (p0) => setState(() {}),
                      inputFormatters: [_formatter.phoneNumber],
                    ),
                    const SizedBox(height: 30),
                    CustomTextFormField(
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      autovalidateMode: AutovalidateMode.always,
                      controller: _birthdayCntr,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('생년월일'),
                        hintText: '1981-01-31',
                      ),
                      errorText: _submitted ? InputValidator().validateDate(_birthdayCntr.text) : null,
                      onChanged: (value) {
                        _birthdayCntr.text = _formatter.validateAndCorrectDate(value);
                        setState(() {});
                      },
                      inputFormatters: [_formatter.birthday],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () => chooseType('KAKAO'),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'lib/assets/logos/kakao.png',
                                  height: 60,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '카카오 인증서',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Transform.scale(
                                scale: 1.2,
                                child: Radio(
                                  groupValue: _selectedCertType,
                                  value: 'KAKAO',
                                  onChanged: (value) => chooseType(value!),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 50),
                        InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () => chooseType('PASS'),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'lib/assets/logos/pass.png',
                                  height: 60,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '카카오 인증서',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Transform.scale(
                                scale: 1.2,
                                child: Radio(
                                  groupValue: _selectedCertType,
                                  value: 'PASS',
                                  onChanged: (value) => chooseType(value!),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.verified_user,
                          color: Color.fromARGB(255, 61, 220, 67),
                        ),
                        Flexible(
                          child: Text(
                            '전자서명 인증을 위해서는 앱이 설치가 되어있어야 되며, 앱에서 인증서가 발급이 되어 있어야 됩니다.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        _submitted = true;
                        setState(() {});

                        if ((!_noEmployeeCode ? _employeeCodeCntr.text.isNotEmpty : true) && _nameCntr.text.isNotEmpty && _phoneNumberCntr.text.isNotEmpty && _birthdayCntr.text.isNotEmpty) _submit();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_user,
                            size: 22,
                          ),
                          SizedBox(width: 10),
                          Text('전자서명'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void chooseType(type) {
    _selectedCertType = type;
    setState(() {});
  }

  Future<void> _submit() async {
    print('submit clicked');
    if (!_agreementChecked) {
      showCustomSnackBar('개인정보 보호 약관에 동의해주세요.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${BASEURL}auth/requestSign'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": _nameCntr.text,
          "birthday": _formatter.birthday.getUnmaskedText(),
          "cert_phone_number": _formatter.phoneNumber.getUnmaskedText(),
          "id_cert_type": _selectedCertType,
          "sales_cd": _employeeCodeCntr.text,
        }),
      );

      if (response.body.isEmpty) throw 'Request error';

      Map data = await jsonDecode(utf8.decode(response.bodyBytes));

      if (data['result'] == 'ERROR') throw data['message'];
      if (data['result'] == 'BAD') throw data['message'];
      if (data['result'] == 'SUCCESS') {
        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: SignUpWaitingPopup(
                name: _nameCntr.text,
                birthday: _formatter.birthday.getUnmaskedText(),
                certType: _selectedCertType,
                phoneNumber: _formatter.phoneNumber.getUnmaskedText(),
                receiptId: data['receipt_id'],
                employeeCode: _employeeCodeCntr.text,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) showCustomSnackBar(e.toString());
    }
  }
}
