import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_checkbox.dart';
import 'package:mobile_manager_simpass/components/custom_drop_down_menu.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/image_picker_container.dart';
import 'package:mobile_manager_simpass/components/show_address_popup.dart';
import 'package:mobile_manager_simpass/components/show_plans_popup.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/components/signature_pad.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/pages/base64_image_view.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_manager_simpass/utils/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormDetailsPage extends StatefulWidget {
  final int planId;
  // final String typeCd;
  // final String carrierCd;
  // final String mvnoCd;
  final String searchText;

  // const FormDetailsPage({super.key, required this.typeCd, required this.carrierCd, required this.mvnoCd, required this.searchText, required this.planId});
  const FormDetailsPage({super.key, required this.searchText, required this.planId});

  @override
  State<FormDetailsPage> createState() => _FormDetailsPageState();
}

class _FormDetailsPageState extends State<FormDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final Map _fixedFormsDetails = Map.from(inputFormsList);

  @override
  void initState() {
    super.initState();

    for (var form in _fixedFormsDetails.entries) {
      form.value['value'] = TextEditingController();
      form.value['value'].text = form.value['initial'] ?? "";
    }
    //plan id to fetch data from server
    _fetchData(widget.planId);
  }

  bool _dataLoading = true;
  bool _submitted = false;

  @override
  void dispose() {
    for (var form in _fixedFormsDetails.entries) {
      form.value['value'] = TextEditingController();
      if (form.value['value'] is TextEditingController) {
        form.value['value'].dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    bool isTablet = displayWidth > 600;

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[2])),
      body: _dataLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _availableForms.entries
                          .map(
                            (entry) => entry.value.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      runAlignment: WrapAlignment.start,
                                      alignment: WrapAlignment.start,
                                      spacing: 15,
                                      runSpacing: 15,
                                      children: [
                                        //title
                                        _titleGenerator(entry.key),

                                        //fields
                                        ...entry.value.map(
                                          (formName) {
                                            if (_fixedFormsDetails[formName]['type'] == 'input') {
                                              return Container(
                                                constraints: isTablet ? BoxConstraints(maxWidth: _fixedFormsDetails[formName]['maxwidth'].toDouble()) : null,
                                                child: CustomTextFormField(
                                                  style: formName == 'usim_plan_nm' ? TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary) : null,
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    label: formName != 'usim_plan_nm' ? Text(_fixedFormsDetails[formName]['label']) : null,
                                                    hintText: _fixedFormsDetails[formName]['placeholder'],
                                                    enabledBorder: formName == 'usim_plan_nm'
                                                        ? OutlineInputBorder(
                                                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                                                          )
                                                        : null,
                                                  ),
                                                  errorText: _errorShower(formName),
                                                  textCapitalization: _fixedFormsDetails[formName]['capital'] ?? false ? TextCapitalization.characters : null,
                                                  controller: _fixedFormsDetails[formName]['value'],
                                                  inputFormatters: _fixedFormsDetails[formName]?['formatter'] != null ? [_fixedFormsDetails[formName]['formatter']] : null,
                                                  onChanged: (newValue) {
                                                    if (_theSameAsPayeerCheck && (formName == 'name' || formName == 'birthday' || formName == 'birthday_full')) {
                                                      // if (_theSameAsPayeerCheck) {
                                                      _fixedFormsDetails['account_name']['value'].text = _fixedFormsDetails['name']['value'].text;
                                                      _fixedFormsDetails['account_birthday']['value'].text = _fixedFormsDetails['birthday']['value'].text;
                                                      _fixedFormsDetails['account_birthday_full']['value'].text = _fixedFormsDetails['birthday_full']['value'].text;
                                                    }

                                                    // birthday date validation
                                                    if (formName == 'birthday' || formName == 'deputy_birthday' || formName == 'account_birthday') {
                                                      final formatter = InputFormatter().validateAndCorrectShortDate;
                                                      _fixedFormsDetails['birthday']['value'].text = formatter(_fixedFormsDetails['birthday']['value'].text);
                                                      _fixedFormsDetails['deputy_birthday']['value'].text = formatter(_fixedFormsDetails['deputy_birthday']['value'].text);
                                                      _fixedFormsDetails['account_birthday']['value'].text = formatter(_fixedFormsDetails['account_birthday']['value'].text);
                                                    }

                                                    // full birthday date validation
                                                    if (formName == 'birthday_full' || formName == 'deputy_birthday_full' || formName == 'account_birthday_full') {
                                                      final formatter = InputFormatter().validateAndCorrectDate;
                                                      _fixedFormsDetails['birthday_full']['value'].text = formatter(_fixedFormsDetails['birthday_full']['value'].text);
                                                      _fixedFormsDetails['deputy_birthday_full']['value'].text = formatter(_fixedFormsDetails['deputy_birthday_full']['value'].text);
                                                      _fixedFormsDetails['account_birthday_full']['value'].text = formatter(_fixedFormsDetails['account_birthday_full']['value'].text);
                                                    }

                                                    setState(() {});
                                                  },
                                                  readOnly: redOnlyChecker(formName),
                                                  onTap: () async {
                                                    //selecting plan
                                                    if (formName == 'usim_plan_nm') {
                                                      // final selectedItem = await showPlansPopup(context, widget.typeCd, widget.carrierCd, widget.mvnoCd, widget.searchText);
                                                      final selectedItem = await showPlansPopup(context, _serverData['usim_plan_info']['carrier_type'], _serverData['usim_plan_info']['carrier_cd'],
                                                          _serverData['usim_plan_info']['mvno_cd'], widget.searchText);
                                                      await _fetchData(selectedItem);
                                                    }

                                                    //selecting addrss
                                                    if (formName == 'address' && context.mounted) {
                                                      final model = await showAddressSelect(context);
                                                      _fixedFormsDetails['address']['value'].text = model.addressType == 'R' ? model.roadAddress : model.jibunAddress;
                                                      _fixedFormsDetails['addressdetail']['value'].text = model.buildingName;
                                                    }
                                                    setState(() {});
                                                  },
                                                ),
                                              );
                                            }

                                            if (_fixedFormsDetails[formName]['type'] == 'select') {
                                              return Container(
                                                constraints: isTablet ? BoxConstraints(maxWidth: _fixedFormsDetails[formName]['maxwidth'].toDouble()) : null,
                                                child: CustomDropdownMenu(
                                                  requestFocusOnTap: true,
                                                  enableSearch: true,
                                                  label: Text(_fixedFormsDetails[formName]['label']),
                                                  expandedInsets: EdgeInsets.zero,
                                                  initialSelection: _fixedFormsDetails[formName]['value'].text,
                                                  errorText: _errorShower(formName),
                                                  dropdownMenuEntries: _fixedFormsDetails[formName]['options'] ?? [],
                                                  onSelected: (selectedItem) async {
                                                    _fixedFormsDetails[formName]['value'].text = selectedItem;
                                                    setState(() {});
                                                    _generateInitialForms();
                                                  },
                                                ),
                                              );
                                            }

                                            return const SizedBox.shrink();
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          )
                          .toList(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomCheckbox(
                      onChanged: (newValue) => setState(() {
                        _showFileUploadChecked = newValue ?? false;
                      }),
                      text: '증빙자료첨부(선택사항)',
                      value: _showFileUploadChecked,
                    ),
                  ),
                  if (_showFileUploadChecked)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, left: 20),
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

                  const SizedBox(height: 20),
                  //sign all after print checkbox

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomCheckbox(
                      onChanged: (newValue) => setState(() {
                        _signAllAfterPrint = newValue ?? false;
                      }),
                      text: '신청서 프린트 인쇄후 서명/사인 자필',
                      value: _signAllAfterPrint,
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (!_signAllAfterPrint)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          //account sign and seal
                          Container(
                            constraints: const BoxConstraints(maxWidth: 350),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: SignatureContainer(
                              padTitle: '가입자서명',
                              signData: _accountSignData,
                              sealData: _accountSealData,
                              overlayName: _fixedFormsDetails['name']['value'].text,
                              errorText: _getErrorMessageForPad('account'),
                              updateSignSeal: (signData, sealData) {
                                _accountSignData = signData != null ? base64Encode(signData) : null;
                                _accountSealData = sealData != null ? base64Encode(sealData) : null;
                                setState(() {});
                              },
                            ),
                          ),

                          //payeer sign and seal
                          if (!_theSameAsPayeerCheck)
                            Container(
                              constraints: const BoxConstraints(maxWidth: 350),
                              margin: const EdgeInsets.only(bottom: 20),
                              child: SignatureContainer(
                                padTitle: '자동이체 서명',
                                signData: _payeerSignData,
                                sealData: _payeerSealData,
                                errorText: _getErrorMessageForPad('payeer'),
                                overlayName: _fixedFormsDetails['account_name']['value'].text,
                                updateSignSeal: (signData, sealData) {
                                  _payeerSignData = signData != null ? base64Encode(signData) : null;
                                  _payeerSealData = sealData != null ? base64Encode(sealData) : null;
                                  setState(() {});
                                },
                              ),
                            ),

                          //deputy sign and seal
                          if (_fixedFormsDetails['cust_type_cd']['value'].text == 'COL')
                            Container(
                              constraints: const BoxConstraints(maxWidth: 350),
                              margin: const EdgeInsets.only(bottom: 20),
                              child: SignatureContainer(
                                padTitle: '법정대리인 서명',
                                signData: _deputySignData,
                                sealData: _deputySealData,
                                overlayName: _fixedFormsDetails['deputy_name']['value'].text,
                                errorText: _getErrorMessageForPad('deputy'),
                                updateSignSeal: (signData, sealData) {
                                  _deputySignData = signData != null ? base64Encode(signData) : null;
                                  _deputySealData = sealData != null ? base64Encode(sealData) : null;
                                  setState(() {});
                                },
                              ),
                            ),

                          //partner sign and seal
                          if (_serverData['chk_partner_sign'] == 'N' && _serverData['usim_plan_info']['mvno_cd'] == 'UPM')
                            Container(
                              constraints: const BoxConstraints(maxWidth: 350),
                              margin: const EdgeInsets.only(bottom: 20),
                              child: SignatureContainer(
                                padTitle: '판매자 서명',
                                signData: _partnerSignData,
                                sealData: _partnerSealData,
                                errorText: _getErrorMessageForPad('partner'),
                                updateSignSeal: (signData, sealData) {
                                  _partnerSignData = signData != null ? base64Encode(signData) : null;
                                  _partnerSealData = sealData != null ? base64Encode(sealData) : null;
                                  setState(() {});
                                },
                              ),
                            ),

                          //agree sign pad
                          if (_serverData['usim_plan_info']['mvno_cd'] == 'UPM')
                            Container(
                              constraints: const BoxConstraints(maxWidth: 350),
                              margin: const EdgeInsets.only(bottom: 20),
                              child: SignatureContainer(
                                padTitle: '동의합니다',
                                signData: _agreePadData,
                                errorText: _getErrorMessageForPad('agree'),
                                sealData: null,
                                type: 'agree',
                                updateAgree: (agreeData) {
                                  _agreePadData = agreeData != null ? base64Encode(agreeData) : null;
                                  setState(() {});
                                },
                              ),
                            ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            : const Text('개통 신청/서식출력'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 200),
                ],
              ),
            ),
    );
  }

//this check is used to return readonly for inputField
  bool redOnlyChecker(formName) {
    if (formName == 'usim_plan_nm' || formName == 'address') return true;
    if (_theSameAsPayeerCheck && ['account_name', 'account_birthday', 'account_birthday_full'].contains(formName)) return true;
    return false;
  }

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

  ///checkbox style creator
  TextStyle _checkBoxStyle() => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.secondary,
      );

  Widget _titleGenerator(typeName) {
    String title = '';
    if (typeName == 'usim') title = '요금제 정보';
    if (typeName == 'customer') title = '고객 정보';
    if (typeName == 'deputy') title = '법정대리인';
    if (typeName == 'payment') title = '자동이체';

    Widget txtW = Text(title, style: _checkBoxStyle());

    if (typeName == 'payment') {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          txtW,
          const SizedBox(width: 10),
          CustomCheckbox(
            onChanged: (newValue) => setState(() {
              _theSameAsPayeerCheck = newValue ?? false;
              //if _theSameAsPayeerCheck is the same
              if (newValue ?? false) {
                _fixedFormsDetails['account_name']['value'].text = _fixedFormsDetails['name']['value'].text;
                _fixedFormsDetails['account_birthday']['value'].text = _fixedFormsDetails['birthday']['value'].text;
                _fixedFormsDetails['account_birthday_full']['value'].text = _fixedFormsDetails['birthday_full']['value'].text;
              } else {
                _fixedFormsDetails['account_name']['value'].text = '';
                _fixedFormsDetails['account_birthday']['value'].text = '';
                _fixedFormsDetails['account_birthday_full']['value'].text = '';
              }
            }),
            text: '가입자와 동일',
            value: _theSameAsPayeerCheck,
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: txtW,
    );
  }

  Map _serverData = {};

  // finding forms
  final Map<String, List> _availableForms = {"usim": [], "customer": [], "deputy": [], "payment": []};

  Future<void> _fetchData(planId) async {
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/applyInit', method: 'POST', body: {
        "usim_plan_id": planId,
      });
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      // print(decodedRes);
      if (decodedRes['statusCode'] != 200) throw decodedRes['message'] ?? 'Fetch data error';
      _serverData = decodedRes['data'];

      _fixedFormsDetails['usim_plan_nm']['value'].text = _serverData['usim_plan_info']['usim_plan_nm'];

      // usim list select required
      _fixedFormsDetails['usim_model_list']['required'] = _serverData['chk_usim_model'] == 'Y';

      // print(_serverData);

      _generateInitialForms();

      _dataLoading = false;
      setState(() {});
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }

  //form firlds error checker
  String? _errorShower(formName) {
    String? error;

    if (!_submitted) return null;
    if (!_fixedFormsDetails[formName]['required']) return null;
    if (['phone_number', 'contact', 'deputy_contact'].contains(formName)) {
      error = InputValidator().validatePhoneNumber(_fixedFormsDetails[formName]['value'].text);
    } else if (['birthday', 'account_birthday', 'deputy_birthday'].contains(formName)) {
      error = InputValidator().validateShortDate(_fixedFormsDetails[formName]['value'].text);
    } else if (['birthday_full', 'account_birthday_full', 'deputy_birthday_full'].contains(formName)) {
      error = InputValidator().validateDate(_fixedFormsDetails[formName]['value'].text);
    } else {
      if (_fixedFormsDetails[formName]['required'] && _fixedFormsDetails[formName]['value'].text.isEmpty) {
        error = _fixedFormsDetails[formName]['error'];
      }
    }

    return error;
  }

  //pad data error checker
  bool _hasErrorInPad(String padName) {
    if (!_submitted) return false;

    if (!_signAllAfterPrint) {
      if (padName == 'account') return _accountSignData == null || _accountSealData == null;
      if (padName == 'payeer') return !_theSameAsPayeerCheck && (_payeerSignData == null || _payeerSealData == null);
      if (padName == 'deputy') return _fixedFormsDetails['cust_type_cd']['value'].text == 'COL' && (_deputySignData == null || _deputySealData == null);
      if (padName == 'partner') return _serverData['chk_partner_sign'] == 'N' && _serverData['usim_plan_info']['mvno_cd'] == 'UPM' && (_partnerSignData == null || _partnerSealData == null);
      if (padName == 'agree') return _serverData['usim_plan_info']['mvno_cd'] == 'UPM' && _agreePadData == null;
    }
    return false;
  }

  String? _getErrorMessageForPad(String padName) {
    if (_hasErrorInPad(padName)) {
      switch (padName) {
        case 'account':
          return '가입자서명을 하지 않았습니다.';
        case 'payeer':
          return '자동이체서명을 하지 않았습니다';
        case 'deputy':
          return '법정대리인서명을 하지 않았습니다.';
        case 'partner':
          return '판매자서명을 하지 않았습니다.';
        case 'agree':
          return '가입약관에 동의하지 않았습니다.';
      }
    }
    return null;
  }

  void _generateInitialForms() {
    _dataLoading = true;
    setState(() {});

    // resetting available forms
    _availableForms['usim']!.clear();
    _availableForms['customer']!.clear();
    _availableForms['payment']!.clear();
    _availableForms['deputy']!.clear();

    final usimPlanInfo = _serverData['usim_plan_info'];

    for (var type in plansFormsInfo) {
      if (type['code'] == usimPlanInfo['carrier_type']) {
        for (var carrier in type['carriers']) {
          if (carrier['code'] == usimPlanInfo['carrier_cd']) {
            for (var mvno in carrier['mvnos']) {
              if (mvno['code'] == usimPlanInfo['mvno_cd']) {
                _availableForms['usim']!.addAll(mvno['usimForms']);
                _availableForms['customer']!.addAll(mvno['customerForms']);
              }
            }
          }
        }
      }
    }
    _generateSecondaryValues();

    // adding payment forms depending on type
    if (usimPlanInfo['carrier_type'] == 'PO') {
      _availableForms['payment']!.addAll(['paid_transfer_cd', 'account_name', 'account_birthday', 'account_agency', 'account_number']);
    }

    // //EXTRA FIELDS FOR FORMS
    if (_fixedFormsDetails['usim_act_cd']?['value'].text == 'N') _availableForms['usim']!.add('wish_number');
    if (_fixedFormsDetails['usim_act_cd']?['value'].text == 'M') {
      _availableForms['usim']!.addAll(['mnp_carrier_type', 'phone_number', 'mnp_pre_carrier']);
      if (_fixedFormsDetails['mnp_pre_carrier']?['value'] == 'MV') _availableForms['usim']!.add('mnp_pre_carrier_nm');
    }

    if (_fixedFormsDetails['paid_transfer_cd']['value'].text == 'C') _availableForms['payment']!.add('card_yy_mm');

    //adding deputy forms
    if (_fixedFormsDetails['cust_type_cd']['value'].text == 'COL') {
      _availableForms['deputy']!.addAll(['deputy_name', 'deputy_birthday', 'relationship_cd', 'deputy_contact']);
    }

    _generateSecondaryValues();

    //settnig country code
    _fixedFormsDetails['country']['value'].text = '';
    if (_fixedFormsDetails['cust_type_cd']['value'].text != 'MEA') _fixedFormsDetails['country']['value'].text = '대한민국';

    //removing gender if not underage for HVS
    if (_serverData['usim_plan_info']['mvno_cd'] == 'HVS') {
      if (_fixedFormsDetails['cust_type_cd']['value'].text != 'COL') _availableForms['customer']!.remove('gender_cd');
    }

    if (_serverData['usim_plan_info']['mvno_cd'] == 'SVM') {
      final index = _availableForms['payment']!.indexOf('account_birthday');
      if (index != -1) _availableForms['payment']![index] = 'account_birthday_full';

      final index1 = _availableForms['deputy']!.indexOf('deputy_birthday');
      if (index1 != -1) _availableForms['deputy']![index1] = 'deputy_birthday_full';
    }

    _dataLoading = false;
    setState(() {});
  }

  void _generateSecondaryValues() {
    //setting drop down values

    for (var form in _fixedFormsDetails.entries) {
      if (form.value['type'] == 'select') form.value['options'] = <DropdownMenuEntry<String>>[];

      if (_serverData.containsKey(form.key) && _serverData[form.key] is List && _serverData[form.key].length > 0) {
        _serverData[form.key].forEach(
          (item) => form.value['options'].add(DropdownMenuEntry(value: item['cd'].toString(), label: item['value'].toString())),
        );

        //setting drop down default values
        if (form.value['value'].text.isEmpty && _serverData[form.key][0]['cd'] != null && form.value['hasDefault']) {
          form.value['value'].text = _serverData[form.key][0]['cd'];
        }
      }
    }

    setState(() {});
  }

  final List<File> _extraAttachFiles = [];

  bool _submitting = false;

  Future<void> _submit() async {
    try {
      _submitted = true;
      _submitting = true;

      setState(() {});

      List currentAvailableFormNames = [];

      for (var formsList in _availableForms.entries) {
        currentAvailableFormNames.addAll(formsList.value);
      }

      for (var forms in _fixedFormsDetails.entries) {
        String formName = forms.key;

        if (currentAvailableFormNames.contains(formName) && _errorShower(formName) != null) {
          showCustomSnackBar('There is unfilled forms');
          return;
        }
      }

      for (var i in ['account', 'payeer', 'partner', 'deputy', 'agree']) {
        if (_hasErrorInPad(i)) {
          showCustomSnackBar(_getErrorMessageForPad(i) ?? 'Pad error');
          return;
        }
      }
      // return;

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

      for (var formName in currentAvailableFormNames) {
        request.fields[formName] = _fixedFormsDetails[formName]?['value']?.text;

        if (['birthday', 'deputy_birthday', 'account_birthday', 'deputy_contact', 'contact', 'phone_number'].contains(formName)) {
          request.fields[formName] = _fixedFormsDetails[formName]?['value']?.text?.replaceAll('-', '');
        }

        //adding wishlists
        if (formName == 'wish_number') {
          List? wishList = _fixedFormsDetails['wish_number']['value'].text.split(' / ');
          if (wishList != null && wishList.isNotEmpty) {
            for (int i = 0; i < wishList.length; i++) {
              request.fields['request_no_$i'] = wishList[i];
            }
          }
        }

        if (formName == 'country') {
          request.fields['country_cd'] = _fixedFormsDetails[formName]['value'].text;
        }
        if (formName == 'usim_model_list') {
          request.fields['usim_model_no'] = _fixedFormsDetails[formName]['value'].text;
        }
        if (formName == 'data_roming_block_cd') {
          request.fields['data_roming_block'] = _fixedFormsDetails[formName]['value'].text;
        }
        if (formName == 'gender_cd') {
          request.fields['gender'] = _fixedFormsDetails[formName]['value'].text;
        }
        if (formName == 'data_block_cd') {
          request.fields['data_block'] = _fixedFormsDetails[formName]['value'].text;
        }
        if (formName == 'phone_bill_block_cd') {
          request.fields['phone_bill_block'] = _fixedFormsDetails[formName]['value'].text;
        }
        if (formName == 'extra_service_cd') {
          request.fields['extra_service'] = _fixedFormsDetails[formName]['value'].text;
        }

        if (formName == 'birthday_full') {
          request.fields['birthday'] = _fixedFormsDetails[formName]?['value']?.text?.replaceAll('-', '');
          request.fields.remove('birthday_full');
        }
        if (formName == 'deputy_birthday_full') {
          request.fields['deputy_birthday'] = _fixedFormsDetails[formName]?['value']?.text?.replaceAll('-', '');
          request.fields.remove('deputy_birthday_full');
        }
        if (formName == 'account_birthday_full') {
          request.fields['account_birthday'] = _fixedFormsDetails[formName]?['value']?.text?.replaceAll('-', '');
          request.fields.remove('account_birthday_full');
        }
      }

      // Add files to the request
      for (var file in _extraAttachFiles) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        //  the key for the files
        var multipartFile = http.MultipartFile('attach_files', stream, length, filename: file.path.split('/').last);
        request.files.add(multipartFile);
      }

      //pad datas
      request.fields['bill_sign'] = _payeerSignData ?? "";
      request.fields['bill_seal'] = _payeerSealData ?? "";
      request.fields['apply_sign'] = _accountSignData ?? "";
      request.fields['apply_seal'] = _accountSealData ?? "";
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

      if (decodedRes['data'] != null && decodedRes['data']['apply_forms_list'] != null) {
        if (mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => Base64ImageViewPage(base64Images: decodedRes['data']['apply_forms_list'])));
      }

      showCustomSnackBar(decodedRes['message']);
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      _submitting = false;
      setState(() {});
    }
  }
}
