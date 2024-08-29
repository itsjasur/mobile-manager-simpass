import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_drop_down_menu.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/globals/form_maker.dart';
import 'package:mobile_manager_simpass/globals/forms_list.dart';
import 'package:mobile_manager_simpass/globals/plans_forms.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'dart:developer' as developer;

class FormDetailsPage extends StatefulWidget {
  final int planId;
  final String searchText;

  const FormDetailsPage({super.key, required this.planId, required this.searchText});

  @override
  State<FormDetailsPage> createState() => _FormDetailsPageState();
}

class _FormDetailsPageState extends State<FormDetailsPage> {
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

  final Map<String, FormDetail> _classForms = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sideMenuNames[2])),
      body: _dataLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    ..._availableForms.map(
                      (formname) {
                        if (_classForms[formname]?.type == 'input') {
                          return Container(
                            constraints: BoxConstraints(maxWidth: _classForms[formname]?.maxwidth ?? 300),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: CustomTextFormField(
                              controller: _classForms[formname]?.controller,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                label: Text(_classForms[formname]?.label ?? ""),
                                hintText: _classForms[formname]?.placeholder,
                                enabledBorder: _classForms[formname]?.isBordered(formname, context),
                              ),
                              errorText: _classForms[formname]?.error(formname),
                              textCapitalization: _classForms[formname]?.capitalizeCharacters(formname),
                              onChanged: (newValue) {},
                            ),
                          );
                        }

                        if (_classForms[formname]?.type == 'select') {
                          return Container(
                            constraints: BoxConstraints(maxWidth: _classForms[formname]?.maxwidth ?? 300),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: CustomDropdownMenu(
                              // controller: _classForms[formname]?.controller,
                              requestFocusOnTap: true,
                              enableSearch: true,
                              label: Text(_classForms[formname]?.label ?? ""),
                              initialSelection: _serverData[formname]?[0]?['cd'],
                              dropdownMenuEntries: _classForms[formname]!.generateOptions(formname, _serverData[formname]),
                              errorText: _classForms[formname]?.error(formname),
                              onSelected: (newValue) {
                                _classForms[formname]?.controller.text = newValue ?? "";
                                // print(newValue);
                                // print(_classForms[formname]?.controller.text);
                              },
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  bool _dataLoading = true;
  Map _serverData = {};
  Map _usimPlanInfo = {};

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
  }
}
