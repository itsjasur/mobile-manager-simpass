import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile_manager_simpass/components/custom_drop_down_menu.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

class FormDetailsPage extends StatefulWidget {
  const FormDetailsPage({super.key});

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

    _fetchData();
  }

  bool _dataLoading = true;

  bool _formsSubmitted = true;

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
                                          // const SizedBox(height: 20),
                                          _titleGenerator(entry.key),

                                          //fields
                                          ...entry.value.map(
                                            (formName) {
                                              if (_fixedFormsDetails[formName]['type'] == 'input') {
                                                return Container(
                                                  constraints: isTablet ? BoxConstraints(maxWidth: _fixedFormsDetails[formName]['maxwidth'].toDouble()) : null,
                                                  // constraints: BoxConstraints(maxWidth: _fixedFormsDetails[formName]['maxwidth'].toDouble()),
                                                  child: CustomTextFormField(
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    decoration: InputDecoration(
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      label: Text(_fixedFormsDetails[formName]['label']),
                                                      hintText: _fixedFormsDetails[formName]['placeholder'],
                                                    ),
                                                    errorText: _errorShower(formName),
                                                    textCapitalization: _fixedFormsDetails[formName]['capital'] ?? false ? TextCapitalization.characters : null,
                                                    controller: _fixedFormsDetails[formName]['value'],
                                                    // initialValue: _fixedFormsDetails[formName]?['initial'],

                                                    inputFormatters: _fixedFormsDetails[formName]['formatter'],
                                                    onChanged: (newValue) {
                                                      if (formName == 'birthday' || formName == 'deputy_birthday' || formName == 'account_birthday') {
                                                        _fixedFormsDetails[formName]['value'].text = InputFormatter().validateAndCorrectShortDate(newValue);
                                                        setState(() {});
                                                      }
                                                    },
                                                  ),
                                                );
                                              }

                                              if (_fixedFormsDetails[formName]['type'] == 'select') {
                                                return Container(
                                                  constraints: isTablet ? BoxConstraints(maxWidth: _fixedFormsDetails[formName]['maxwidth'].toDouble()) : null,
                                                  // constraints: BoxConstraints(maxWidth: _fixedFormsDetails[formName]['maxwidth'].toDouble()),
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) _submit();
                        },
                        child: const Text('Submit')),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _titleGenerator(typeName) {
    String title = '';
    if (typeName == 'usim') title = '요금제 정보';
    if (typeName == 'customer') title = '고객 정보';
    if (typeName == 'deputy') title = '법정대리인';
    if (typeName == 'payment') title = '자동이체';

    Widget txtW = SizedBox(
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
    return txtW;
  }

  String? _errorShower(formName) {
    if (_formsSubmitted && _fixedFormsDetails[formName]['required'] && _fixedFormsDetails[formName]['value'].text.isEmpty) {
      return _fixedFormsDetails[formName]['error'];
    }
    return null;
  }

  Map _serverData = {};

  // finding forms
  final Map<String, List> _availableForms = {"usim": [], "customer": [], "deputy": [], "payment": []};

  Future<void> _fetchData() async {
    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/applyInit', method: 'POST', body: {
        "usim_plan_id": 4,
      });
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      // print(decodedRes);
      if (decodedRes['statusCode'] != 200) throw decodedRes['message'] ?? 'Fetch data error';
      _serverData = decodedRes['data'];
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
    _formsSubmitted = true;

    print('form called');
  }
}
