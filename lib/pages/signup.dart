import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/show_html.dart';
import 'package:mobile_manager_simpass/components/sign_up_waiting_popup.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/sensitive.dart';
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

  bool _useTermsChecked = false;
  bool _privacyPolicyChecked = false;
  bool _noEmployeeCode = true;

  bool _submitted = false;

  String _selectedCertType = 'KAKAO';

  final InputFormatter _formatter = InputFormatter();

  @override
  void initState() {
    super.initState();
    // _nameCntr.text = 'SOBIRJONOV JASURBEK ARISLONBEK UGLI';
    // _birthdayCntr.text = '1995-08-18';
    // _phoneNumberCntr.text = '010-5818-9352';
    // _nameCntr.text = '박기철';
    // _phoneNumberCntr.text = '010-4201-3337';
    // _birthdayCntr.text = '1974-07-25';
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
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50),
                    const Center(
                      child: Text(
                        '판매점 회원 가입',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _useTermsChecked,
                            onChanged: (newValue) => {
                              _useTermsChecked = newValue ?? false,
                              setState(() {}),
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '이용약관 (필수)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            showHtmlContentPopup(context, 'useterms');
                          },
                          child: Text(
                            '전문보기',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _privacyPolicyChecked,
                            onChanged: (newValue) => {
                              _privacyPolicyChecked = newValue ?? false,
                              setState(() {}),
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '개인정보보호정책 (필수)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            showHtmlContentPopup(context, 'privacy');
                          },
                          child: Text(
                            '전문보기',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                      decoration: const InputDecoration(
                        label: Text('이름'),
                        hintText: '홍길동',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      errorText: _submitted ? InputValidator().validateName(_nameCntr.text) : null,
                      inputFormatters: [koreanAndEnlishRegexp],
                      onChanged: (p0) => setState(() {}),
                    ),
                    const SizedBox(height: 30),
                    CustomTextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
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
                      controller: _birthdayCntr,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('생년월일'),
                        hintText: '1981-01-31',
                      ),
                      errorText: _submitted ? InputValidator().validateBirthday(_birthdayCntr.text) : null,
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
                                  'assets/logos/kakao.png',
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
                                  'assets/logos/pass.png',
                                  height: 60,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'PASS 인증서',
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitting
                            ? null
                            : () async {
                                _submitted = true;
                                setState(() {});

                                bool allFiled = [
                                  (!_noEmployeeCode ? InputValidator().validateEmployeeCode(_employeeCodeCntr.text) == null : true),
                                  InputValidator().validateName(_nameCntr.text) == null,
                                  InputValidator().validatePhoneNumber(_phoneNumberCntr.text) == null,
                                  InputValidator().validateBirthday(_birthdayCntr.text) == null,
                                ].every((element) => element == true);

                                if (allFiled) _submit();
                              },
                        child: _submitting
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
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

  bool _submitting = false;

  void chooseType(String type) {
    // print(type);
    _selectedCertType = type;
    setState(() {});
  }

  Future<void> _submit() async {
    // print('submit clicked');
    if (!_useTermsChecked) {
      showCustomSnackBar('이용약관에 동의해주세요.');
      return;
    }

    if (!_privacyPolicyChecked) {
      showCustomSnackBar('개인정보보호정책에 동의해주세요.');
      return;
    }

    try {
      _submitting = true;
      setState(() {});

      final response = await http.post(
        Uri.parse('${BASEURL}auth/requestSign'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": _nameCntr.text,
          "birthday": _birthdayCntr.text.replaceAll('-', ''),
          "cert_phone_number": _phoneNumberCntr.text.replaceAll('-', ''),
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
                certType: _selectedCertType,
                birthday: _birthdayCntr.text.replaceAll('-', ''),
                phoneNumber: _phoneNumberCntr.text.replaceAll('-', ''),
                receiptId: data['receipt_id'],
                employeeCode: _employeeCodeCntr.text,
              ),
            ),
          );
        }
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      _submitting = false;
      setState(() {});
    }
  }
}
