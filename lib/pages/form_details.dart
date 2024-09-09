import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_manager_simpass/components/custom_checkbox.dart';
import 'package:mobile_manager_simpass/components/custom_drop_down_menu.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/image_picker_container.dart';
import 'package:mobile_manager_simpass/components/show_address_popup.dart';
import 'package:mobile_manager_simpass/components/show_plans_popup.dart';
import 'package:mobile_manager_simpass/components/signature_agree_container.dart';
import 'package:mobile_manager_simpass/components/signature_pads_container.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/models/form_model.dart';
import 'package:mobile_manager_simpass/globals/forms_list.dart';
import 'package:mobile_manager_simpass/globals/plans_forms.dart';
import 'package:mobile_manager_simpass/pages/base64_image_view.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:mobile_manager_simpass/utils/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormDetailsPage extends StatefulWidget {
  final int planId;
  final String searchText;

  const FormDetailsPage({super.key, required this.planId, required this.searchText});

  @override
  State<FormDetailsPage> createState() => _FormDetailsPageState();
}

class _FormDetailsPageState extends State<FormDetailsPage> {
  final Map<String, FormDetail> _classForms = {};

  @override
  void initState() {
    super.initState();
    _fetchData(widget.planId);

    inputFormsList.forEach(
      (key, value) {
        _classForms[key] = FormDetail.fromMap(value);
      },
    );
  }

  final InputFormatter _formatters = InputFormatter();
  final PhoneNumberFormatter _phoneNumberFormatter = PhoneNumberFormatter();
  final InputValidator _validator = InputValidator();

  String? _errorChecker(String formname) {
    bool fullBirhtday = _usimPlanInfo['mvno_cd'] == 'SVM';
    FormDetail formInfo = _classForms[formname]!;

    if (!formInfo.formRequired) {
      return null;
    }
    if (['birthday', 'account_birthday', 'deputy_birthday'].contains(formname)) {
      return fullBirhtday ? _validator.validateBirthday(formInfo.controller.text) : _validator.validateShortBirthday(formInfo.controller.text);
    }
    if (['contact', 'phone_number', 'deputy_contact'].contains(formname)) {
      return _validator.validateAllPhoneNumber(formInfo.controller.text);
    }
    if (formname == 'card_yy_mm') {
      return _validator.expiryDate(formInfo.controller.text);
    }

    return _validator.validateForNoneEmpty(formInfo.controller.text, formInfo.label);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        // appBar: AppBar(title: Text(sideMenuNames[2] + widget.planId.toString())),
        appBar: AppBar(title: Text(sideMenuNames[2])),
        body: _dataLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      if (_serverData['chk_agent_role_info'] != 'Y')
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
                          child: Column(
                            children: [
                              Text(
                                _serverData['agent_role_message_1'] ?? "",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _serverData['agent_role_message_2'] ?? "",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/partner-request');
                                },
                                child: const Text('거래요청 상태으로 가기'),
                              )
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),

                      ...generateDisplayingForms(_availableForms).map(
                        (section) => Container(
                          margin: const EdgeInsets.only(bottom: 25),
                          child: section['forms'].isEmpty
                              ? const SizedBox.shrink()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (section['type'] != 'empty')
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 10, top: 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              section['title'],
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(width: 10),
                                            if (section['type'] == 'payment')
                                              CustomCheckbox(
                                                onChanged: (newValue) => setState(() {
                                                  _theSameAsPayeerCheck = newValue ?? false;

                                                  // resetting same values
                                                  if (_theSameAsPayeerCheck) {
                                                    _classForms['account_name']?.controller.text = _classForms['name']!.controller.text;
                                                    _classForms['account_birthday']?.controller.text = _classForms['birthday']!.controller.text;
                                                  } else {
                                                    _classForms['account_name']?.controller.text = '';
                                                    _classForms['account_birthday']?.controller.text = '';
                                                  }
                                                }),
                                                text: '가입자와 동일',
                                                value: _theSameAsPayeerCheck,
                                              ),
                                          ],
                                        ),
                                      ),
                                    Wrap(
                                      spacing: 20,
                                      runSpacing: 20,
                                      alignment: WrapAlignment.start,
                                      children: [
                                        ...section['forms'].map(
                                          (formname) {
                                            //for seven mobile need to full date
                                            bool fullBirhtday = _usimPlanInfo['mvno_cd'] == 'SVM';
                                            FormDetail formInfo = _classForms[formname]!;
                                            InputBorder? enabledBorder;
                                            Function()? onChangedExtra;
                                            String? hintText = formInfo.placeholder;

                                            bool readOnly(String formname) {
                                              if (['usim_plan_nm', 'address'].contains(formname)) return true;
                                              return false;
                                            }

                                            TextCapitalization? capitalizeCharacters(String formname) {
                                              if (['name', 'account_name', 'deputy_name', 'usim_no'].contains(formname)) return TextCapitalization.characters;
                                              return null;
                                            }

                                            TextInputType? keyboardType(String formname) {
                                              if ([
                                                'birthday',
                                                'account_birthday',
                                                'deputy_birthday',
                                                'contact',
                                                'phone_number',
                                                'deputy_contact',
                                                'wish_number',
                                                'card_yy_mm',
                                                'account_number',
                                              ].contains(formname)) {
                                                return TextInputType.phone;
                                              }

                                              if (['name', 'account_name', 'deputy_name'].contains(formname)) {
                                                return TextInputType.name;
                                              }

                                              return null;
                                            }

                                            List<TextInputFormatter>? formatters;
                                            if (['birthday', 'account_birthday', 'deputy_birthday'].contains(formname)) {
                                              if (fullBirhtday) {
                                                formatters = [_formatters.birthday];
                                                hintText = '1991-01-31';
                                                onChangedExtra = () => formInfo.controller.text = InputFormatter().validateAndCorrectDate(formInfo.controller.text);
                                              } else {
                                                formatters = [_formatters.birthdayShort];
                                                hintText = '91-01-31';
                                                onChangedExtra = () => formInfo.controller.text = InputFormatter().validateAndCorrectShortDate(formInfo.controller.text);
                                              }
                                            }
                                            if (['contact', 'phone_number', 'deputy_contact'].contains(formname)) {
                                              formatters = [_phoneNumberFormatter];
                                            }
                                            if (formname == 'wish_number') {
                                              formatters = [_formatters.wishNumbmer];
                                            }
                                            if (formname == 'card_yy_mm') {
                                              formatters = [_formatters.cardYYMM];
                                            }

                                            if (['name', 'account_name', 'deputy_name'].contains(formname)) {
                                              formatters = [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣ᆞᆢ \-]'))];
                                            }

                                            if (formname == 'account_agency') {
                                              formatters = [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣ᆞᆢ ]'))];
                                            }
                                            if (formname == 'account_number') {
                                              formatters = [FilteringTextInputFormatter.digitsOnly];
                                            }
                                            if (formname == 'usim_no') {
                                              formatters = [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]'))];
                                            }

                                            if (formname == 'usim_plan_nm') {
                                              enabledBorder = OutlineInputBorder(
                                                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                                              );
                                            }

                                            if (_classForms[formname]?.type == 'input') {
                                              return Container(
                                                constraints: BoxConstraints(maxWidth: _classForms[formname]?.maxwidth ?? 300),
                                                child: CustomTextFormField(
                                                  controller: formInfo.controller,
                                                  inputFormatters: formatters,
                                                  keyboardType: keyboardType(formname),
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    label: Text(formInfo.label),
                                                    hintText: hintText,
                                                    enabledBorder: enabledBorder,
                                                  ),
                                                  errorText: _formsSubmitted ? _errorChecker(formname) : null,
                                                  textCapitalization: capitalizeCharacters(formname),
                                                  readOnly: readOnly(formname),
                                                  onChanged: (newValue) {
                                                    onChangedExtra?.call();
                                                    setState(() {});
                                                    //setting payment name and birthday
                                                    if (_theSameAsPayeerCheck) {
                                                      _classForms['account_name']?.controller.text = _classForms['name']!.controller.text;
                                                      _classForms['account_birthday']?.controller.text = _classForms['birthday']!.controller.text;
                                                    }
                                                  },
                                                  onTap: () async {
                                                    //selecting plan
                                                    if (formname == 'usim_plan_nm') {
                                                      int? selId =
                                                          await showPlansPopup(context, _usimPlanInfo['carrier_type'], _usimPlanInfo['carrier_cd'], _usimPlanInfo['mvno_cd'], widget.searchText);
                                                      if (selId != null) await _fetchData(selId);
                                                    }

                                                    //selecting addrss
                                                    if (formname == 'address' && context.mounted) {
                                                      final model = await showAddressSelect(context);
                                                      _classForms['address']?.controller.text = model.addressType == 'R' ? model.roadAddress ?? "" : model.jibunAddress ?? "";
                                                      _classForms['addressdetail']?.controller.text = model.buildingName ?? "";
                                                    }
                                                    setState(() {});
                                                  },
                                                ),
                                              );
                                            }

                                            if (_classForms[formname]?.type == 'select') {
                                              return Container(
                                                constraints: BoxConstraints(maxWidth: _classForms[formname]?.maxwidth ?? 300),
                                                child: CustomDropdownMenu(
                                                  requestFocusOnTap: true,
                                                  expandedInsets: EdgeInsets.zero,
                                                  enableSearch: true,
                                                  label: Text(_classForms[formname]?.label ?? ""),
                                                  dropdownMenuEntries: _classForms[formname]?.options ?? [],
                                                  initialSelection: _classForms[formname]?.controller.text,
                                                  errorText: _formsSubmitted ? _errorChecker(formname) : null,
                                                  onSelected: (newValue) {
                                                    if (_classForms[formname]?.controller.text != newValue) {
                                                      _classForms[formname]?.controller.text = newValue ?? "";
                                                      _addSecondaryFields();
                                                    }
                                                  },
                                                ),
                                              );
                                            }

                                            return const SizedBox.shrink();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      //upload attach images
                      CustomCheckbox(
                        onChanged: (newValue) => setState(() {
                          _showFileUploadChecked = newValue ?? false;
                        }),
                        text: '증빙자료첨부(선택사항)',
                        value: _showFileUploadChecked,
                      ),

                      if (_showFileUploadChecked)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
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

                      const SizedBox(height: 10),
                      //sign all after print checkbox
                      CustomCheckbox(
                        onChanged: (newValue) => setState(() {
                          _signAllAfterPrint = newValue ?? false;
                        }),
                        text: '신청서 프린트 인쇄후 서명/사인 자필',
                        value: _signAllAfterPrint,
                      ),
                      const SizedBox(height: 10),

                      if (!_signAllAfterPrint)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: SignaturePadsContainer(
                                  title: '가입자서명',
                                  signData: _accountSignData,
                                  sealData: _accountSealData,
                                  errorText: _getErrorMessageForPad('account'),
                                  updateDatas: (signData, sealData) {
                                    _accountSignData = signData;
                                    _accountSealData = sealData;
                                    setState(() {});
                                  },
                                ),
                              ),

                              //payeer sign and seal
                              if (!_theSameAsPayeerCheck)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: SignaturePadsContainer(
                                    title: '자동이체 서명',
                                    signData: _payeerSignData,
                                    sealData: _payeerSealData,
                                    errorText: _getErrorMessageForPad('payeer'),
                                    updateDatas: (signData, sealData) {
                                      _payeerSignData = signData;
                                      _payeerSealData = sealData;
                                      setState(() {});
                                    },
                                  ),
                                ),

                              //deputy sign and seal
                              if (_classForms['cust_type_cd']?.controller.text == 'COL')
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: SignaturePadsContainer(
                                    title: '법정대리인 서명',
                                    signData: _deputySignData,
                                    sealData: _deputySealData,
                                    errorText: _getErrorMessageForPad('deputy'),
                                    updateDatas: (signData, sealData) {
                                      _deputySignData = signData;
                                      _deputySealData = sealData;
                                      setState(() {});
                                    },
                                  ),
                                ),

                              //partner sign and seal
                              if (_serverData['chk_partner_sign'] == 'N' && _usimPlanInfo['mvno_cd'] == 'UPM')
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: SignaturePadsContainer(
                                    title: '판매자 서명',
                                    signData: _partnerSignData,
                                    sealData: _partnerSealData,
                                    errorText: _getErrorMessageForPad('partner'),
                                    updateDatas: (signData, sealData) {
                                      _partnerSignData = signData;
                                      _partnerSealData = sealData;
                                      setState(() {});
                                    },
                                  ),
                                ),

                              //agree sign pad
                              if (_usimPlanInfo['mvno_cd'] == 'UPM')
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: SignatureAgreeContainer(
                                    title: '동의합니다',
                                    agreeData: _agreePadData,
                                    errorText: _getErrorMessageForPad('agree'),
                                    updateData: (agreeData) {
                                      _agreePadData = agreeData;
                                      setState(() {});
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 180),
                        child: ElevatedButton(
                          onPressed: _formsSubmitting ? null : _submit,
                          child: _formsSubmitting
                              ? const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('개통 신청/서식출력'),
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  bool _dataLoading = true;
  Map _serverData = {};
  Map _usimPlanInfo = {};

  // checkboxes
  bool _signAllAfterPrint = false;
  bool _theSameAsPayeerCheck = true;
  bool _showFileUploadChecked = false;
  //account sign and seal
  String? _accountSignData;
  String? _accountSealData;

  //payeer sign and seal
  String? _payeerSignData;
  String? _payeerSealData;

  //partmer sign and seal
  String? _partnerSignData;
  String? _partnerSealData;

  //deputy sign and seal
  String? _deputySignData;
  String? _deputySealData;

  //UPM agree sign
  String? _agreePadData;

  //attachment images
  final List<File> _extraAttachFiles = [];

  bool _formsSubmitted = false;
  bool _formsSubmitting = false;

  Future<void> _fetchData(planId) async {
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/applyInit', method: 'POST', body: {
        "usim_plan_id": planId,
      });
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      if (decodedRes['statusCode'] != 200) throw decodedRes['message'] ?? 'Fetch data error';

      _serverData = decodedRes['data'] ?? {};
      _usimPlanInfo = _serverData['usim_plan_info'] ?? {};
      // developer.log(_serverData.toString());

      _classForms['usim_plan_nm']?.controller.text = _usimPlanInfo['usim_plan_nm'];
      // usim list select required
      _classForms['usim_model_list']?.formRequired = _serverData['chk_usim_model'] == 'Y';

      //generating default options for dropdowns
      inputFormsList.forEach(
        (key, value) {
          if (_serverData.containsKey(key) && _serverData[key] is List && _serverData[key].length > 0) {
            if (_classForms[key]!.controller.text.isEmpty && key != 'usim_model_list') {
              _classForms[key]?.controller.text = _serverData[key].first?['cd'];
            }
            List<DropdownMenuEntry<String>> optionsFromServer = [];
            _serverData[key].forEach(
              (item) => optionsFromServer.add(DropdownMenuEntry(value: item['cd'].toString(), label: item['value'].toString())),
            );
            _classForms[key]?.options = optionsFromServer;
          }
        },
      );

      _findMvnoAvailableForms();
      _dataLoading = false;

      setState(() {});
    } catch (e) {
      developer.log(e.toString());
      showCustomSnackBar(e.toString());
    }
  }

  final List _availableForms = [];

  void _findMvnoAvailableForms() {
    _availableForms.clear();

    String carrierType = _usimPlanInfo['carrier_type'];
    String carrierCode = _usimPlanInfo['carrier_cd'];
    String mvnoCode = _usimPlanInfo['mvno_cd'];

    for (var type in plansFormsInfoList) {
      //adding mvno forms
      if (type['code'] == carrierType) {
        for (var carrier in type['carriers'] ?? []) {
          if (carrier['code'] == carrierCode) {
            for (var mvno in carrier['mvnos'] ?? []) {
              if (mvno['code'] == mvnoCode) {
                developer.log(mvno['forms'].toString());
                _availableForms.addAll(mvno['forms'] ?? []);
              }
            }
          }
        }
      }
      // adding payment forms if not null
      _availableForms.addAll(type['paymentForms'] ?? []);
    }

    //adding extra service for 7mobile if combine is not empty
    if (mvnoCode == 'SVM' && _usimPlanInfo['combine'] != null) {
      _availableForms.add('extra_service_cd');
    }

    _addSecondaryFields();
  }

  void _addSecondaryFields() {
    //new number registration adds wishnumber
    _availableForms.remove('wish_number');
    if (_classForms['usim_act_cd']?.controller.text == 'N') _availableForms.add('wish_number');

    //phone number transfer
    List<String> phoneTransferFields = ['mnp_carrier_type', 'phone_number', 'mnp_pre_carrier'];
    _availableForms.removeWhere((formname) => phoneTransferFields.contains(formname));
    _availableForms.remove('mnp_pre_carrier_nm');
    if (_classForms['usim_act_cd']?.controller.text == 'M') _availableForms.addAll(phoneTransferFields);
    if (_classForms['mnp_pre_carrier']?.controller.text == 'MV') _availableForms.add('mnp_pre_carrier_nm');

    //payment card number
    _availableForms.remove('card_yy_mm');
    if (_classForms['paid_transfer_cd']?.controller.text == 'C') _availableForms.add('card_yy_mm');

    //adding deputy forms
    List<String> deputyForms = ['deputy_name', 'deputy_birthday', 'relationship_cd', 'deputy_contact'];
    _availableForms.removeWhere((formname) => deputyForms.contains(formname));
    if (_classForms['cust_type_cd']?.controller.text == 'COL') _availableForms.addAll(deputyForms);

    //settnig country code
    _classForms['country']?.controller.text = '';
    if (_classForms['cust_type_cd']?.controller.text != 'MEA') _classForms['country']?.controller.text = '대한민국';

    //removing gender if not underage for HVS
    if (_usimPlanInfo['mvno_cd'] == 'HVS') {
      _signAllAfterPrint = true;
      _availableForms.remove('gender_cd');
      if (_classForms['cust_type_cd']?.controller.text == 'COL') _availableForms.add('gender_cd');
    }

    setState(() {});
  }

  String? _getErrorMessageForPad(String padName) {
    if (!_signAllAfterPrint && _formsSubmitted) {
      if (padName == 'account') {
        if (_accountSignData == null || _accountSealData == null) return '가입자서명을 하지 않았습니다.';
      }
      if (padName == 'payeer') {
        if (!_theSameAsPayeerCheck && (_payeerSignData == null || _payeerSealData == null)) return '자동이체서명을 하지 않았습니다';
      }
      if (padName == 'deputy') {
        if (_classForms['cust_type_cd']?.controller.text == 'COL' && (_deputySignData == null || _deputySealData == null)) return '법정대리인서명을 하지 않았습니다.';
      }
      if (padName == 'partner') {
        if (_serverData['chk_partner_sign'] == 'N' && _usimPlanInfo['mvno_cd'] == 'UPM' && (_partnerSignData == null || _partnerSealData == null)) return '판매자서명을 하지 않았습니다.';
      }
      if (padName == 'agree') {
        if (_serverData['usim_plan_info']['mvno_cd'] == 'UPM' && _agreePadData == null) return '가입약관에 동의하지 않았습니다.';
      }
    }
    return null;
  }

  Future<void> _submit() async {
    try {
      setState(() {
        _formsSubmitted = true;
        _formsSubmitting = true;
      });

      //here checks if any of the forms are unfilled yet
      for (var formname in _availableForms) {
        if (_classForms[formname]!.formRequired && _errorChecker(formname) != null) {
          showCustomSnackBar('채워지지 않은 필드가 있습니다. (${_classForms[formname]?.label})');
          return;
        }
      }

      //checking if available pads are all filled
      for (var pad in ['account', 'payeer', 'deputy', 'partner', 'agree']) {
        String? error = _getErrorMessageForPad(pad);
        if (error != null) {
          showCustomSnackBar(error);
          return;
        }
      }

      developer.log('reached the end');

      //submission
      final url = Uri.parse('${BASEURL}agent/actApply');
      var request = http.MultipartRequest('POST', url);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      request.headers['Authorization'] = 'Bearer $accessToken';

      // adding other form fields
      request.fields['carrier_type'] = _serverData['usim_plan_info']['carrier_type'];
      request.fields['carrier_cd'] = _serverData['usim_plan_info']['carrier_cd'];
      request.fields['mvno_cd'] = _serverData['usim_plan_info']['mvno_cd'];
      request.fields['usim_plan_id'] = _serverData['usim_plan_info']['id'].toString();

      for (var formName in _availableForms) {
        request.fields[formName] = _classForms[formName]!.controller.text;

        if (['birthday', 'deputy_birthday', 'account_birthday', 'deputy_contact', 'contact', 'phone_number'].contains(formName)) {
          request.fields[formName] = _classForms[formName]!.controller.text.replaceAll('-', '');
        }

        //adding wishlists
        if (formName == 'wish_number') {
          List? wishList = _classForms['wish_number']!.controller.text.split('/');
          if (wishList.isNotEmpty) {
            for (int i = 0; i < wishList.length; i++) {
              request.fields['request_no_${i + 1}'] = wishList[i];
            }
          }
        }
        if (formName == 'country') {
          request.fields['country_cd'] = _classForms[formName]!.controller.text;
        }
        if (formName == 'usim_model_list') {
          request.fields['usim_model_no'] = _classForms[formName]!.controller.text;
        }
        if (formName == 'data_roming_block_cd') {
          request.fields['data_roming_block'] = _classForms[formName]!.controller.text;
        }
        if (formName == 'gender_cd') {
          request.fields['gender'] = _classForms[formName]!.controller.text;
        }
        if (formName == 'data_block_cd') {
          request.fields['data_block'] = _classForms[formName]!.controller.text;
        }
        if (formName == 'phone_bill_block_cd') {
          request.fields['phone_bill_block'] = _classForms[formName]!.controller.text;
        }
        if (formName == 'extra_service_cd') {
          request.fields['extra_service'] = _classForms[formName]!.controller.text;
        }
      }

      // adding files to the request
      for (var file in _extraAttachFiles) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        //  the key for the files
        var multipartFile = http.MultipartFile('attach_files', stream, length, filename: file.path.split('/').last);
        request.files.add(multipartFile);
      }

      //adding signatute pad datas
      request.fields['apply_sign'] = _accountSignData ?? "";
      request.fields['apply_seal'] = _accountSealData ?? "";
      request.fields['bill_sign'] = _payeerSignData ?? "";
      request.fields['bill_seal'] = _payeerSealData ?? "";
      request.fields['deputy_sign'] = _deputySignData ?? "";
      request.fields['deputy_seal'] = _deputySealData ?? "";
      request.fields['agree_sign'] = _agreePadData ?? "";
      // Print fields
      // request.fields.forEach((key, value) {
      //   print('Key: $key, Value: $value');
      // });

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      Map decodedRes = await jsonDecode(respStr);

      if (decodedRes['data'] != null && decodedRes['data']['apply_forms_list'] != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Base64ImageViewPage(base64Images: decodedRes['data']['apply_forms_list']),
          ),
        );
      }

      showCustomSnackBar(decodedRes['message'] ?? 'Could not fetch image data');
    } catch (e) {
      developer.log(e.toString());
      showCustomSnackBar(e.toString());
    } finally {
      _formsSubmitting = false;
      setState(() {});
    }
  }
}
