import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_manager_simpass/components/custom_checkbox.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/image_picker_container.dart';
import 'package:mobile_manager_simpass/components/popup_header.dart';
import 'package:mobile_manager_simpass/components/show_address_popup.dart';
import 'package:mobile_manager_simpass/components/signature_pad.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_manager_simpass/utils/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

showPartnerRequestPopup(BuildContext context, String agentCode) async {
  final res = await showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            PartnerRequestPopupContent(agentCd: agentCode),
            const PopupHeader(title: '요금제선택'),
          ],
        ),
      ),
    ),
  );
}

class PartnerRequestPopupContent extends StatefulWidget {
  final String agentCd;
  const PartnerRequestPopupContent({super.key, required this.agentCd});

  @override
  State<PartnerRequestPopupContent> createState() => _PartnerRequestPopupContentState();
}

class _PartnerRequestPopupContentState extends State<PartnerRequestPopupContent> {
  bool _agreementChecked = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _fieldBuilder({
    String? key,
    required String label,
    bool readOnly = true,
    TextEditingController? controller,
    String? initialValue,
    void Function(String)? onChanged,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
  }) {
    return CustomTextFormField(
      key: key != null ? ValueKey(key) : null,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(label),
      ),
      controller: controller,
      initialValue: initialValue,
      readOnly: readOnly,
      onChanged: onChanged,
      onTap: onTap,
      inputFormatters: inputFormatters,
      errorText: errorText,
    );
  }

  Widget _titleBuilder(text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String? _validateForms(type) {
    if (type == 'email') return _submitted ? InputValidator().validateEmail(_data['email']) : null;
    if (type == 'address') return _submitted ? InputValidator().validateForNoneEmpty(_data['address'], '주소') : null;
    if (type == 'dtl_address') return _submitted ? InputValidator().validateForNoneEmpty(_data['dtl_address'], '상세주소') : null;
    if (type == 'bank_nm') return _submitted ? InputValidator().validateForNoneEmpty(_data['bank_nm'], '은행명') : null;
    if (type == 'bank_num') return _submitted ? InputValidator().validateForNoneEmpty(_data['bank_num'], '계좌번호') : null;

    return null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    Widget partnerN = _fieldBuilder(label: '상호명*', initialValue: _data['partner_nm']);
    Widget busnumW = _fieldBuilder(label: '사업자번호*', initialValue: _data['business_num']);
    Widget direNmW = _fieldBuilder(label: '대표자명*', initialValue: _data['contractor']);
    Widget phoneNumW = _fieldBuilder(
      label: '연락 번호*',
      initialValue: InputFormatter().phoneNumber.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: _data['phone_number'] ?? "")).text,
    );

    Widget emailW = _fieldBuilder(
      label: '이메일주소*',
      initialValue: _data['email'],
      readOnly: false,
      onChanged: (newValue) {
        _data['email'] = newValue;
        setState(() {});
      },
      errorText: _validateForms('email'),
    );
    Widget storeTelW = _fieldBuilder(
      label: '매장 전화',
      initialValue: InputFormatter().officeNumber.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: _data['store_contact'] ?? "")).text,
    );
    Widget storeFaxW = _fieldBuilder(
      label: '매장 팩스',
      initialValue: InputFormatter().officeNumber.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: _data['store_fax'] ?? "")).text,
    );

    Widget addressW = _fieldBuilder(
      key: _data['address'],
      label: '주소*',
      initialValue: _data['address'],
      onTap: () async {
        final model = await showAddressSelect(context);
        _data['address'] = model.address;
        _data['dtl_address'] = model.buildingName;
        setState(() {});
      },
      errorText: _validateForms('address'),
    );

    Widget addressDetW = _fieldBuilder(
      key: _data['dtl_address'],
      label: '상세주소*',
      initialValue: _data['dtl_address'],
      readOnly: false,
      onChanged: (newValue) {
        _data['dtl_address'] = newValue;
        setState(() {});
      },
      errorText: _validateForms('dtl_address'),
    );

    Widget accNmW = _fieldBuilder(label: '예급주 명*', initialValue: _data['contractor']);
    Widget accBirthdayW = _fieldBuilder(label: '생년월일*', initialValue: InputFormatter().formatDate(_data['birthday']));

    Widget accBankNmW = _fieldBuilder(
      label: '은행명 (첨부할 자료와 동일)*',
      readOnly: false,
      initialValue: _data['bank_nm'],
      onChanged: (newValue) {
        _data['bank_nm'] = newValue;
        setState(() {});
      },
      errorText: _validateForms('bank_nm'),
    );
    Widget bankAccNumW = _fieldBuilder(
      label: '계좌번호 (첨부할 자료와 동일)*',
      readOnly: false,
      initialValue: _data['bank_num'],
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (newValue) {
        _data['bank_num'] = newValue;
        setState(() {});
      },
      errorText: _validateForms('bank_num'),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _dataLoading
            ? SizedBox(height: MediaQuery.of(context).size.height, child: const Center(child: CircularProgressIndicator()))
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 45), //header height
                  Text(
                    '본 신청서는 심패스에서 직접 운영하는 판매점 전자계약서이며 고객님에 소중한 개인정보는 암호화되어 안전하게 보호됩니다.',
                    style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.secondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      CustomCheckbox(
                        text: "판매점 계약서 내용 동의 (필수)",
                        onChanged: (e) {
                          _agreementChecked = e ?? false;
                          setState(() {});
                        },
                        value: _agreementChecked,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                        onPressed: () {},
                        child: const Text('계약서 확인'),
                      ),
                    ],
                  ),

                  _titleBuilder("판매점 정보"),

                  if (isTablet)
                    Wrap(
                      runSpacing: 20,
                      children: [
                        partnerN,
                        Row(
                          children: [
                            Expanded(child: busnumW),
                            const SizedBox(width: 20),
                            Expanded(child: direNmW),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: phoneNumW),
                            const SizedBox(width: 20),
                            Expanded(child: emailW),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: storeTelW),
                            const SizedBox(width: 20),
                            Expanded(child: storeFaxW),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: addressW),
                            const SizedBox(width: 20),
                            Expanded(flex: 2, child: addressDetW),
                          ],
                        ),
                      ],
                    ),

                  if (!isTablet)
                    Wrap(
                      runSpacing: 20,
                      children: [partnerN, busnumW, direNmW, phoneNumW, emailW, storeTelW, storeFaxW, addressW, addressDetW],
                    ),

                  _titleBuilder("수수료 입금계좌 정보"),

                  if (isTablet)
                    Wrap(
                      runSpacing: 20,
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 3, child: accNmW),
                            const SizedBox(width: 20),
                            Expanded(flex: 2, child: accBirthdayW),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: accBankNmW),
                            const SizedBox(width: 20),
                            Expanded(child: bankAccNumW),
                          ],
                        ),
                      ],
                    ),
                  if (!isTablet)
                    Wrap(
                      runSpacing: 20,
                      children: [accNmW, accBirthdayW, accBankNmW, bankAccNumW],
                    ),
                  const SizedBox(height: 30),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: SignatureContainer(
                      padTitle: '판매자 서명',
                      signData: _signData,
                      sealData: _sealData,
                      saveSigns: (signData, sealData) {
                        _signData = base64Encode(signData);
                        _sealData = base64Encode(sealData);
                      },
                    ),
                  ),

                  _titleBuilder("판매점 서류 등록"),

                  ..._attachedFiles.entries.map(
                    (e) => Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(4),
                        strokeWidth: 2,
                        dashPattern: const [4],
                        color: e.value['initial'] == null && e.value['new'] == null ? Colors.red : Theme.of(context).colorScheme.primary,
                        child: Container(
                          // alignment: Alignment.centerLeft,
                          width: double.infinity,
                          constraints: const BoxConstraints(minHeight: 50),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 20,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Text(
                                e.value['title'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (e.value['initial'] != null)
                                const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "문서가 제출되었습니다",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.verified,
                                      size: 22,
                                      color: Colors.green,
                                    )
                                  ],
                                ),
                              if (e.value['initial'] == null)
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runSpacing: 10,
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 200),
                                      child: Text(
                                        e.value['filename'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    ImagePickerContainer(
                                      isRow: true,
                                      multipleUploable: false,
                                      buttonText: e.value['new'] == null ? '이미지 업로드' : '재업로드',
                                      getImage: (images, filename) {
                                        e.value['new'] = images;
                                        e.value['filename'] = filename;
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: _submitting
                            ? null
                            : () {
                                _submit();
                              },
                        child: _submitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : const Text("온라인 판매점 계약신청"),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
      ),
    );
  }

  Map _data = {};

  bool _dataLoading = true;

  String? _signData;
  String? _sealData;

  Future<void> _fetchData() async {
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/partnerInfo', method: 'GET');
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      print(decodedRes);

      if (decodedRes['statusCode'] == 200 && decodedRes['data']['result'] == 'SUCCESS') {
        _data = decodedRes['data']['info'];

        _signData = _data['partner_sign'];
        _sealData = _data['partner_seal'];

        _attachedFiles['bs_reg_no']['initial'] = _data['bs_reg_no'];
        _attachedFiles['id_card']['initial'] = _data['id_card'];
        _attachedFiles['bank_book']['initial'] = _data['bank_book'];

        _dataLoading = false;
        setState(() {});
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }

  //docs and images
  final Map _attachedFiles = {
    "bs_reg_no": {"initial": null, "new": null, "filename": "", "required": true, "title": '사업자 등록증 (필수)'},
    "id_card": {"initial": null, "new": null, "filename": "", "required": true, "title": '대표자 신분증 (필수)'},
    "bank_book": {"initial": null, "new": null, "filename": "", "required": true, "title": '통장 사본 (필수)'},
  };

  bool _submitted = false;
  bool _submitting = false;

  Future<void> _submit() async {
    try {
      _submitted = true;
      _submitting = true;
      setState(() {});

      for (String i in ['email', 'address', 'dtl_address', 'bank_nm', 'bank_num']) {
        if (_validateForms(i) != null) {
          showCustomSnackBar('There is an unfilled form');
          return;
        }
      }

      if (!_agreementChecked) {
        showCustomSnackBar('판매점 계약서 내용에 동의해주세요.');
        return;
      }

      for (var i in _attachedFiles.entries) {
        if (i.value['initial'] == null && i.value['new'] == null) {
          showCustomSnackBar(i.value['title']);
          return;
        }
      }

      await Future.delayed(const Duration(seconds: 2));

      final url = Uri.parse('${BASEURL}agent/contract');

      var request = http.MultipartRequest('POST', url);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Adds files to the request
      for (var e in _attachedFiles.entries) {
        if (e.value['initial'] != null && e.value['new'] != null) {
          var stream = http.ByteStream(e.value['new'].openRead());
          var length = await e.value.length();
          //  the key for the files
          var multipartFile = http.MultipartFile(e.key, stream, length, filename: e.value['filename']);
          request.files.add(multipartFile);
        }
      }

      //adding sign images data
      request.fields['partner_sign'] = _signData ?? "";
      request.fields['partner_seal'] = _sealData ?? "";

      request.fields['agent_cd'] = widget.agentCd;
      request.fields['contractor'] = _data['contractor'];
      request.fields['birthday'] = _data['birthday'];
      request.fields['partner_nm'] = _data['partner_nm'];
      request.fields['business_num'] = _data['business_num'];
      request.fields['phone_number'] = _data['phone_number'];
      request.fields['email'] = _data['email'];
      request.fields['store_contact'] = _data['store_contact'];
      request.fields['store_fax'] = _data['store_fax'];
      request.fields['address'] = _data['address'];
      request.fields['dtl_address'] = _data['dtl_address'];
      request.fields['bank_nm'] = _data['bank_nm'];
      request.fields['bank_num'] = _data['bank_num'];
      request.fields['id_cert_type'] = _data['id_cert_type'];
      request.fields['receipt_id'] = _data['receipt_id'];
      request.fields['partner_sign'] = _data['partner_sign'];
      request.fields['partner_seal'] = _data['partner_seal'];

      // Print fields
      request.fields.forEach((key, value) {
        print('Key: $key, Value: $value');
      });

      var response = await request.send();

      final respStr = await response.stream.bytesToString();
      Map decodedRes = await jsonDecode(respStr);

      showCustomSnackBar(decodedRes['message']);

      if (decodedRes['result'] == 'SUCCESS') {
        if (mounted) Navigator.pop(context);
      }

      // print(decodedRes);

      setState(() {});
    } catch (e) {
      print(e);
      showCustomSnackBar(e.toString());
    } finally {
      _submitting = false;
      setState(() {});
    }
  }
}
