import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_manager_simpass/components/custom_checkbox.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/popup_header.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

showPartnerSignPopup(BuildContext context, String agentCode) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            PartnerSignPopupContent(agentCd: agentCode),
            const PopupHeader(title: '판매점 계약 서명'),
          ],
        ),
      ),
    ),
  );
}

class PartnerSignPopupContent extends StatefulWidget {
  final String agentCd;
  const PartnerSignPopupContent({super.key, required this.agentCd});

  @override
  State<PartnerSignPopupContent> createState() => _PartnerSignPopupContentState();
}

class _PartnerSignPopupContentState extends State<PartnerSignPopupContent> {
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    Widget partnerN = _fieldBuilder(label: '상호명*', initialValue: _data['partner_nm']);
    Widget busnumW = _fieldBuilder(label: '사업자번호*', initialValue: _data['business_num']);
    Widget direNmW = _fieldBuilder(label: '대표자명*', initialValue: _data['contractor']);

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
                      ],
                    ),

                  if (!isTablet)
                    Wrap(
                      runSpacing: 20,
                      children: [partnerN, busnumW, direNmW],
                    ),

                  const SizedBox(height: 30),
                  // ConstrainedBox(
                  //   constraints: const BoxConstraints(maxWidth: 350),
                  //   child: SignatureContainer(
                  //     padTitle: '판매자 서명',
                  //     signData: _signData,
                  //     sealData: _sealData,
                  //     errorText: _submitted && (_signData == null || _sealData == null) ? '판매자서명을 하지 않았습니다.' : null,
                  //     updateSignSeal: (signData, sealData) {
                  //       _signData = signData != null ? base64Encode(signData) : null;
                  //       _sealData = sealData != null ? base64Encode(sealData) : null;
                  //       setState(() {});
                  //     },
                  //   ),
                  // ),
                  const SizedBox(height: 30),
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

                  const SizedBox(height: 50),
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

      // print(decodedRes);

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

      if (_signData == null || _sealData == null) {
        showCustomSnackBar('판매자서명을 하지 않았습니다.');
        return;
      }

      final response = await Request().requestWithRefreshToken(
        url: 'agent/setContractSign',
        method: 'POST',
        body: {
          "agent_cd": widget.agentCd,
          "partner_sign": _signData,
          "partner_seal": _sealData,
        },
      );
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      if (decodedRes['result'] == 'SUCCESS') {
        if (mounted) Navigator.pop(context);
      } else {
        throw decodedRes['message'] ?? "Submit error";
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      _submitting = false;
      setState(() {});
    }
  }
}
