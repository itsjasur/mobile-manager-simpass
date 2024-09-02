import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/show_address_popup.dart';
import 'package:mobile_manager_simpass/components/warning.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/validators.dart';
import 'package:http/http.dart' as http;

class SecondarySignup extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String birthday;
  final String receiptId;
  final String certType;
  final String? employeeCode;
  const SecondarySignup({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.receiptId,
    required this.certType,
    required this.birthday,
    required this.employeeCode,
  });

  @override
  State<SecondarySignup> createState() => _SecondarySignupState();
}

class _SecondarySignupState extends State<SecondarySignup> {
  final TextEditingController _partnerNameCntr = TextEditingController();
  final TextEditingController _businessNumberCntr = TextEditingController();
  final TextEditingController _emailCntrl = TextEditingController();
  final TextEditingController _storeTelCntr = TextEditingController();
  final TextEditingController _storeFaxCntr = TextEditingController();
  final TextEditingController _addressCntr = TextEditingController();
  final TextEditingController _addressAdditionsxCntr = TextEditingController();
  final TextEditingController _userNameCntr = TextEditingController();
  final TextEditingController _passwordCntr = TextEditingController();
  final TextEditingController _passwordCheckCntr = TextEditingController();

  final InputFormatter _formatter = InputFormatter();

  bool _submitted = false;
  bool _submitting = false;

  @override
  void dispose() {
    _partnerNameCntr.dispose();
    _businessNumberCntr.dispose();
    _emailCntrl.dispose();
    _storeTelCntr.dispose();
    _storeFaxCntr.dispose();
    _addressCntr.dispose();
    _addressAdditionsxCntr.dispose();
    _userNameCntr.dispose();
    _passwordCntr.dispose();
    _passwordCheckCntr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  '판매점 정보',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _partnerNameCntr,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text('상호명*'),
                  ),
                  errorText: _submitted ? _formValidate('partnername') : null,
                  onChanged: (p0) => setState(() {}),
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _businessNumberCntr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text('사업자번호*'),
                          hintText: '000-00-00000',
                        ),
                        errorText: _businessNumberPrompt ?? _formValidate('businessnumber'),
                        errorTextStyle: _businessNumberOK ? const TextStyle(color: Colors.green) : null,
                        inputFormatters: [_formatter.businessNumber],
                        onChanged: (value) {
                          _businessNumberOK = false;
                          _businessNumberPrompt = null;
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    IntrinsicWidth(
                      child: ElevatedButton(
                        onPressed: _checkBusinessNumber,
                        child: const Text('중북체크'),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  readOnly: true,
                  initialValue: _formatter.formatPhoneNumber(widget.phoneNumber),
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text('연락 번호*'),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  readOnly: true,
                  initialValue: widget.name,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text('대표자 명*'),
                  ),
                  inputFormatters: [_formatter.officeFax],
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: _emailCntrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text('이메일주소*'),
                  ),
                  errorText: _submitted ? _formValidate('email') : null,
                  onChanged: (p0) => setState(() {}),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: _storeTelCntr,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text('매장 전화'),
                  ),
                  onChanged: (newValue) {
                    _storeTelCntr.text = _formatter.formatPhoneNumber(newValue);
                  },
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: _storeFaxCntr,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text('매장 팩스'),
                  ),
                  onChanged: (newValue) {
                    _storeFaxCntr.text = _formatter.formatPhoneNumber(newValue);
                  },
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: _addressCntr,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text('주소*'),
                  ),
                  errorText: _submitted ? _formValidate('address') : null,
                  onChanged: (p0) => setState(() {}),
                  readOnly: true,
                  onTap: () async {
                    final model = await showAddressSelect(context);
                    setState(() {
                      _addressCntr.text = model.addressType == 'R' ? model.roadAddress ?? "" : model.jibunAddress ?? "";
                      _addressAdditionsxCntr.text = model.buildingName ?? "";
                    });
                  },
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: _addressAdditionsxCntr,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text('상세주소'),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  '가입 정보',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _userNameCntr,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text('아이디*'),
                          hintText: 'abc00',
                        ),
                        errorText: _usernamePrompt ?? _formValidate('username'),
                        errorTextStyle: _usernameOK ? const TextStyle(color: Colors.green) : null,
                        onChanged: (value) {
                          _usernameOK = false;
                          _usernamePrompt = null;
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _checkUsername,
                      child: const Text('중북체크'),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  obscureText: true,
                  controller: _passwordCntr,
                  decoration: const InputDecoration(
                    label: Text('비밀번호'),
                  ),
                  errorText: _submitted ? _formValidate('password') : null,
                  onChanged: (p0) => setState(() {}),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  obscureText: true,
                  controller: _passwordCheckCntr,
                  decoration: const InputDecoration(
                    label: Text('비밀번호 확인'),
                  ),
                  onChanged: (p0) => setState(() {}),
                  errorText: _submitted ? _formValidate('passcheck') : null,
                ),
                const SizedBox(height: 30),
                Align(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('인증완료'),
                    ),
                  ),
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<String> _reqForms = ['partnername', 'businessnumber', 'email', 'address', 'username', 'password', 'passcheck'];

  String? _formValidate(String formname) {
    InputValidator validator = InputValidator();

    if (formname == 'partnername') return validator.validateForNoneEmpty(_partnerNameCntr.text, '상호명을');
    if (formname == 'businessnumber') return validator.validateForNoneEmpty(_businessNumberCntr.text, '사업자번호을');
    if (formname == 'email') return validator.validateEmail(_emailCntrl.text);
    if (formname == 'address') return validator.validateForNoneEmpty(_addressCntr.text, '주소을');
    if (formname == 'username') return validator.validateForNoneEmpty(_addressCntr.text, '아이디을');
    if (formname == 'password') return validator.validatePass(_passwordCntr.text);
    if (formname == 'passcheck') return validator.validateRentryPass(_passwordCntr.text, _passwordCheckCntr.text);

    setState(() {});
    return null;
  }

  Future<void> _submit() async {
    _submitted = true;

    setState(() {});

    if (!_businessNumberOK) {
      _businessNumberPrompt = '사업자번호 중복체크 해야합니다';
      showCustomSnackBar('사업자번호 중복체크 해야합니다');
      setState(() {});
      return;
    }

    if (!_usernameOK) {
      _usernamePrompt = '아이디 중복체크 해야합니다';
      showCustomSnackBar('아이디 중복체크 해야합니다');
      return;
    }

    for (var formname in _reqForms) {
      String? res = _formValidate(formname);
      if (res != null) {
        showCustomSnackBar(res);
        return;
      }
    }

    try {
      setState(() {
        _submitting = true;
      });

      Map body = {
        "username": _userNameCntr.text, //아이디
        "password": _passwordCntr.text, //패스워드
        "partner_nm": _partnerNameCntr.text, //판매점명
        "business_num": _businessNumberCntr.text.replaceAll('-', ''), //사업자번호
        "address": _addressCntr.text, //주소
        "dtl_address": _addressAdditionsxCntr.text, //상세주소
        "email": _emailCntrl.text,
        "store_contact": _storeTelCntr.text.replaceAll('-', ''), //매장번호
        "store_fax": _storeFaxCntr.text.replaceAll('-', ''), //매장팩스
        "contractor": widget.name, //대표자명
        "receipt_id": widget.receiptId,
        "id_cert_type": widget.certType,
        "phone_number": widget.phoneNumber,
        "birthday": widget.birthday, // 생년월일
        "sales_cd": widget.employeeCode, //영업사원코드
      };

      final response = await http.post(
        Uri.parse('${BASEURL}auth/partnerjoin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      Map data = await jsonDecode(utf8.decode(response.bodyBytes));

      if (data['result'] == 'SUCCESS') {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          bool res = false;
          if (data['data']['status'] == 'W') {
            res = await showWarningDailogue(context, '판매점가입 접수완료', [
              '가입내용 검토 후 신속하게 승인 처리 진행하도록 하겠습니다.',
              '승인완료시 인증휴대폰번호로 승인완료 문자를 전송합니다.',
              '이용해 주셔서 감사합니다.',
            ]);
          } else {
            res = await showWarningDailogue(context, '등록이 성공적으로 완료되었습니다', ['아이디와 비밀번호로 로그인해주세요.']);
          }

          if (res && mounted) Navigator.pushNamed(context, '/login');
          return;
        }
      }

      throw data['message'] ?? 'Submission error';
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      setState(() {
        _submitting = false;
      });
    }
  }

  bool _businessNumberOK = false;
  String? _businessNumberPrompt;
  Future<void> _checkBusinessNumber() async {
    FocusScope.of(context).unfocus();

    try {
      final response = await http.post(
        Uri.parse('${BASEURL}auth/chkBizNum'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"business_num": _formatter.businessNumber.getUnmaskedText()}),
      );

      Map data = await jsonDecode(utf8.decode(response.bodyBytes));

      _businessNumberPrompt = data['message'];

      if (data['result'] == 'OK') {
        _businessNumberOK = true;
      } else {
        _businessNumberOK = false;
      }

      setState(() {});
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }

  bool _usernameOK = false;
  String? _usernamePrompt;
  Future<void> _checkUsername() async {
    FocusScope.of(context).unfocus();

    try {
      final response = await http.post(
        Uri.parse('${BASEURL}auth/chkUserId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"username": _userNameCntr.text}),
      );

      Map data = await jsonDecode(utf8.decode(response.bodyBytes));

      _usernamePrompt = data['message'];

      if (data['result'] == 'OK') {
        _usernameOK = true;
      } else {
        _usernameOK = false;
      }

      setState(() {});
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
