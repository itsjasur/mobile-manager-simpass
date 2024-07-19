import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_checkbox.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/image_picker_container.dart';
import 'package:mobile_manager_simpass/components/show_address_popup.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/components/signature_pad.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/pages/base64_image_view.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../components/custom_text_field.dart';

class RentalFormsPage extends StatefulWidget {
  const RentalFormsPage({super.key});

  @override
  State<RentalFormsPage> createState() => _RentalFormsPageState();
}

class _RentalFormsPageState extends State<RentalFormsPage> {
  final TextEditingController _nameCntrl = TextEditingController();
  final TextEditingController _birthdayCntr = TextEditingController();
  final TextEditingController _phoneNumberCntr = TextEditingController();
  final TextEditingController _addressCntr = TextEditingController();
  final TextEditingController _addressAdditionsCntr = TextEditingController();
  final TextEditingController _usimNumberCntr = TextEditingController();

  bool _submitted = false;
  bool _submitting = false;

  final List<File> _extraAttachFiles = [];

  bool _signAllAfterPrint = false;

  final InputFormatter _formatter = InputFormatter();

  //account sign and seal
  String? _accountSignData;
  String? _accountSealData;

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    bool isTablet = displayWidth > 600;

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[3])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '가입신청/고객정보',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  Container(
                    constraints: isTablet ? const BoxConstraints(maxWidth: 400) : null,
                    child: CustomTextFormField(
                      controller: _nameCntrl,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('가입자명'),
                        hintText: '홍길동',
                      ),
                      errorText: _submitted ? InputValidator().validateForNoneEmpty(_nameCntrl.text, '가입자명') : null,
                      onChanged: (newV) => setState(() {}),
                    ),
                  ),
                  Container(
                    constraints: isTablet ? const BoxConstraints(maxWidth: 100) : null,
                    child: CustomTextFormField(
                      controller: _birthdayCntr,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('생년월일'),
                        hintText: '91-01-31',
                      ),
                      errorText: _submitted ? InputValidator().validateShortDate(_birthdayCntr.text) : null,
                      inputFormatters: [_formatter.birthdayShort],
                      onChanged: (newV) => setState(() {
                        _birthdayCntr.text = _formatter.validateAndCorrectShortDate(newV);
                      }),
                    ),
                  ),
                  Container(
                    constraints: isTablet ? const BoxConstraints(maxWidth: 200) : null,
                    child: CustomTextFormField(
                      controller: _phoneNumberCntr,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('개통번호외 연락번호'),
                        hintText: '010-0000-0000',
                      ),
                      errorText: _submitted ? InputValidator().validatePhoneNumber(_phoneNumberCntr.text) : null,
                      onChanged: (p0) => setState(() {}),
                      inputFormatters: [_formatter.phoneNumber],
                    ),
                  ),
                  Container(
                    constraints: isTablet ? const BoxConstraints(maxWidth: 400) : null,
                    child: CustomTextFormField(
                      controller: _addressCntr,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('주소'),
                        hintText: '서울시 구로구 디지털로33길 28',
                      ),
                      errorText: _submitted ? InputValidator().validateForNoneEmpty(_addressCntr.text, '주소') : null,
                      onChanged: (p0) => setState(() {}),
                      readOnly: true,
                      onTap: () async {
                        final model = await showAddressSelect(context);
                        _addressCntr.text = (model.addressType == 'R' ? model.roadAddress : model.jibunAddress) ?? "";
                        _addressAdditionsCntr.text = model.buildingName ?? "";

                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    constraints: isTablet ? const BoxConstraints(maxWidth: 300) : null,
                    child: CustomTextFormField(
                      controller: _addressAdditionsCntr,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('상세주소'),
                        hintText: '1001호',
                      ),
                    ),
                  ),
                  Container(
                    constraints: isTablet ? const BoxConstraints(maxWidth: 300) : null,
                    child: CustomTextFormField(
                      controller: _usimNumberCntr,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('USIM 일련번호'),
                        hintText: '00000',
                      ),
                      errorText: _submitted ? InputValidator().validateForNoneEmpty(_usimNumberCntr.text, 'USIM 일련번호') : null,
                      onChanged: (p0) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
              child: Text(
                '가입신청/고객정보',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 140,
                      child: ImagePickerContainer(
                        getImages: (imageList) {
                          _extraAttachFiles.addAll(imageList);
                          setState(() {});
                        },
                      ),
                    ),
                    ...List.generate(
                      _extraAttachFiles.length,
                      (index) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              color: Theme.of(context).colorScheme.onPrimary,
                              child: Image.file(
                                _extraAttachFiles[index],
                                fit: BoxFit.cover,
                                height: 100,
                                width: 140,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              onPressed: () {
                                _extraAttachFiles.removeAt(index);
                                setState(() {});
                              },
                              color: Colors.yellow,
                              icon: const Icon(Icons.delete_outlined, size: 23),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: CustomCheckbox(
                onChanged: (newValue) => setState(() {
                  _signAllAfterPrint = newValue ?? false;
                }),
                text: '신청서 프린트 인쇄후 서명/사인 자필',
                value: _signAllAfterPrint,
              ),
            ),
            if (!_signAllAfterPrint)
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 350),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: SignatureContainer(
                    padTitle: '가입자서명',
                    signData: _accountSignData,
                    sealData: _accountSealData,
                    overlayName: _nameCntrl.text,
                    errorText: _submitted && (_accountSealData == null || _accountSignData == null) ? "판매자서명을 하지 않았습니다." : null,
                    updateSignSeal: (signData, sealData) {
                      _accountSignData = signData != null ? base64Encode(signData) : null;
                      _accountSealData = sealData != null ? base64Encode(sealData) : null;
                      setState(() {});
                    },
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: isTablet ? 200 : double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const Text('접수하기'),
                ),
              ),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    try {
      _submitted = true;
      _submitting = true;
      setState(() {});

      List<bool> allFiled = [
        InputValidator().validateForNoneEmpty(_nameCntrl.text, '가입자명') == null,
        InputValidator().validateShortDate(_birthdayCntr.text) == null,
        InputValidator().validatePhoneNumber(_phoneNumberCntr.text) == null,
        InputValidator().validateForNoneEmpty(_addressCntr.text, '주소') == null,
        InputValidator().validateForNoneEmpty(_usimNumberCntr.text, 'USIM 일련번호') == null,
      ];

      if (allFiled.any((element) => !element)) return;
      if (_accountSealData == null || _accountSignData == null) return;

      final url = Uri.parse('${BASEURL}agent/rentalApply');
      var request = http.MultipartRequest('POST', url);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Add files to the request
      for (var file in _extraAttachFiles) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        //  the key for the files
        var multipartFile = http.MultipartFile('attach_files', stream, length, filename: file.path.split('/').last);
        request.files.add(multipartFile);
      }

      //adding sign images data
      request.fields['apply_sign'] = _accountSignData ?? "";
      request.fields['apply_seal'] = _accountSealData ?? "";

      request.fields['name'] = _nameCntrl.text;
      request.fields['birthday'] = _birthdayCntr.text;
      request.fields['contact'] = _phoneNumberCntr.text;
      request.fields['address'] = _addressCntr.text + _addressAdditionsCntr.text;
      request.fields['usim_no'] = _usimNumberCntr.text;

      // // Print fields
      // request.fields.forEach((key, value) {
      //   print('Key: $key, Value: $value');
      // });

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      Map decodedRes = await jsonDecode(respStr);

      if (decodedRes['data'] != null && decodedRes['data']['apply_forms_list'] != null) {
        if (mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => Base64ImageViewPage(base64Images: decodedRes['data']['apply_forms_list'])));
      }

      showCustomSnackBar(decodedRes['message']);

      setState(() {});
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      _submitting = false;
      setState(() {});
    }
  }
}
