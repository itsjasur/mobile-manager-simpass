import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

class FormDetailsPage extends StatefulWidget {
  final int planId;
  final String typeCd;
  final String carrierCd;
  final String mvnoCd;
  final String searchText;

  const FormDetailsPage({super.key, required this.typeCd, required this.carrierCd, required this.mvnoCd, required this.searchText, required this.planId});

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
  bool _submitted = true;

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
          ? const CircularProgressIndicator()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
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
                                                    decoration: InputDecoration(
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      label: Text(_fixedFormsDetails[formName]['label']),
                                                      hintText: _fixedFormsDetails[formName]['placeholder'],
                                                    ),
                                                    errorText: _errorShower(formName),
                                                    textCapitalization: _fixedFormsDetails[formName]['capital'] ?? false ? TextCapitalization.characters : null,
                                                    controller: _fixedFormsDetails[formName]['value'],
                                                    inputFormatters: _fixedFormsDetails[formName]['formatter'],
                                                    onChanged: (newValue) {
                                                      if (_theSameAsPayeerCheck && (formName == 'name') || formName == 'birthday') {
                                                        _fixedFormsDetails['account_name']['value'].text = _fixedFormsDetails['name']['value'].text;
                                                        _fixedFormsDetails['account_birthday']['value'].text = _fixedFormsDetails['birthday']['value'].text;
                                                      }
                                                      //birthday date validation
                                                      if (formName == 'birthday' || formName == 'deputy_birthday' || formName == 'account_birthday') {
                                                        _fixedFormsDetails[formName]['value'].text = InputFormatter().validateAndCorrectShortDate(newValue);
                                                      }
                                                      setState(() {});
                                                    },
                                                    readOnly: formName == 'usim_plan_nm' || formName == 'address',
                                                    onTap: () async {
                                                      //selecting plan
                                                      if (formName == 'usim_plan_nm') {
                                                        final selectedItem = await showPlansPopup(context, widget.typeCd, widget.carrierCd, widget.mvnoCd, widget.searchText);
                                                        await _fetchData(selectedItem);
                                                        print(selectedItem);
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

                    const SizedBox(height: 10),

                    ImagePickerContainer(
                      getImages: (imageList) {
                        print(imageList.length);
                      },
                    ),

                    const SizedBox(height: 20),
                    //sign all after print checkbox
                    InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () {
                        _signAllAfterPrint = !_signAllAfterPrint;
                        setState(() {});
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: SizedBox(
                              width: 24,
                              child: Checkbox(
                                value: _signAllAfterPrint,
                                onChanged: (newValue) => setState(() {
                                  _signAllAfterPrint = newValue ?? false;
                                }),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(child: Text('신청서 프린트 인쇄후 서명/사인 자필', style: _checkBoxStyle())),
                        ],
                      ),
                    ),

                    CustomCheckbox(
                      onChanged: (newValue) {
                        _showFileUploadChecked = newValue ?? false;
                        setState(() {});
                      },
                      text: 'New checkbox',
                      value: _showFileUploadChecked,
                    ),

                    const SizedBox(height: 20),

                    if (!_signAllAfterPrint)
                      Column(
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
                              errorText: _submitted && (_accountSealData == null || _accountSignData == null) ? '가입자서명을 하지 않았습니다.' : null,
                              saveSigns: (signData, sealData) {
                                _accountSignData = base64Encode(signData);
                                _accountSealData = base64Encode(sealData);
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
                                errorText: _submitted && (_payeerSignData == null || _payeerSealData == null) ? '자동이체서명을 하지 않았습니다.' : null,
                                overlayName: _fixedFormsDetails['account_name']['value'].text,
                                saveSigns: (signData, sealData) {
                                  _payeerSignData = base64Encode(signData);
                                  _payeerSealData = base64Encode(sealData);
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
                                errorText: _submitted && (_partnerSignData == null || _partnerSealData == null) ? '판매자서명을 하지 않았습니다.' : null,
                                saveSigns: (signData, sealData) {
                                  _partnerSignData = base64Encode(signData);
                                  _partnerSealData = base64Encode(sealData);
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
                                errorText: _submitted && (_deputySignData == null || _deputySealData == null) ? '법정대리인서명을 하지 않았습니다.' : null,
                                saveSigns: (signData, sealData) {
                                  _deputySignData = base64Encode(signData);
                                  _deputySealData = base64Encode(sealData);
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
                                errorText: _submitted && _agreePadData == null ? '가입약관에 동의하지 않았습니다.' : null,
                                sealData: null,
                                type: 'agree',
                                saveAgree: (agreeData) {
                                  _agreePadData = base64Encode(agreeData);
                                  setState(() {});
                                },
                              ),
                            ),
                        ],
                      ),

                    const SizedBox(height: 20),

                    ElevatedButton(onPressed: () async {}, child: const Text('Submit')),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
    );
  }

  bool _signAllAfterPrint = false;
  bool _theSameAsPayeerCheck = false;

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
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              _theSameAsPayeerCheck = !_theSameAsPayeerCheck;
              setState(() {});
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: SizedBox(
                    width: 24,
                    child: Checkbox(
                      value: _signAllAfterPrint,
                      onChanged: (newValue) => setState(() {
                        _theSameAsPayeerCheck = newValue ?? false;
                        //if _theSameAsPayeerCheck is the same
                        if (newValue ?? false) {
                          _fixedFormsDetails['account_name']['value'].text = _fixedFormsDetails['name']['value'].text;
                          _fixedFormsDetails['account_birthday']['value'].text = _fixedFormsDetails['birthday']['value'].text;
                        } else {
                          _fixedFormsDetails['account_name']['value'].text = '';
                          _fixedFormsDetails['account_birthday']['value'].text = '';
                        }
                      }),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('신청서 프린트 인쇄후 서명/사인', style: _checkBoxStyle()),
              ],
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: txtW,
    );
  }

  String? _errorShower(formName) {
    if (_submitted && _fixedFormsDetails[formName]['required'] && _fixedFormsDetails[formName]['value'].text.isEmpty) {
      return _fixedFormsDetails[formName]['error'];
    }
    return null;
  }

  Map _serverData = {};

  // finding forms
  final Map<String, List> _availableForms = {"usim": [], "customer": [], "deputy": [], "payment": []};

  Future<void> _fetchData(planId) async {
    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/applyInit', method: 'POST', body: {
        "usim_plan_id": planId,
      });
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      // print(decodedRes);
      if (decodedRes['statusCode'] != 200) throw decodedRes['message'] ?? 'Fetch data error';
      _serverData = decodedRes['data'];

      _fixedFormsDetails['usim_plan_nm']['value'].text = _serverData['usim_plan_info']['usim_plan_nm'];
      // print(_serverData);

      _generateInitialForms();

      _dataLoading = false;
      setState(() {});
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
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

  void _submit() {
    _submitted = true;

    print('form called');
  }
}
