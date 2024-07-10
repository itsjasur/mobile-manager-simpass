import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

class FormDetailsPage extends StatefulWidget {
  const FormDetailsPage({super.key});

  @override
  State<FormDetailsPage> createState() => _FormDetailsPageState();
}

class _FormDetailsPageState extends State<FormDetailsPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[2])),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
              children: _availableForms.entries
                  .map((entry) => Container(
                        child: Text(entry.key),
                      ))
                  .toList()),
        ),
      ),
    );
  }

  Map _serverData = {};

  Map _fixedFormsDetails = Map.from(inputFormsList);

  // finding forms
  Map<String, List> _availableForms = {"usim": [], "customer": [], "deputy": [], "payment": []};

  Future<void> _fetchData() async {
    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/applyInit', method: 'POST', body: {
        "usim_plan_id": 12,
      });
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      print(decodedRes);

      if (decodedRes['statusCode'] != 200) throw decodedRes['message'] ?? 'Fetch data error';

      if (decodedRes['statusCode'] == 200) {
        _serverData = decodedRes['data'];
        setState(() {});
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }

  void generateInitialForms() {
    final usimPlanInfo = _serverData['usim_plan_info'];

    for (var type in plansFormsInfo) {
      if (type['code'] == usimPlanInfo['carrier_type']) {
        for (var carrier in type['carriers']) {
          if (carrier['code'] == usimPlanInfo['carrier_cd']) {
            for (var mvno in carrier['mvnos']) {
              if (mvno['code'] == usimPlanInfo['mvno_cd']) {
                _availableForms['usim'] = mvno['usimForms'];
                _availableForms['customer'] = mvno['customerForms'];
              }
            }
          }
        }
      }

      if (usimPlanInfo['carrier_type'] == 'PO') {
        _availableForms['payment'] = ['paid_transfer_cd', 'account_name', 'account_birthday', 'account_agency', 'account_number'];
      }
    }

    // let selectedTypeInfo = PLANSINFO.find((item) => item.code === usimPlanInfo.carrier_type) //selected type
    // let selectedCarrierInfo = selectedTypeInfo.carriers.find((carrier) => carrier.code === usimPlanInfo.carrier_cd) //selected carrier
    // let selectedMvnoInfo = selectedCarrierInfo.mvnos.find((mvno) => mvno.code === usimPlanInfo.mvno_cd) //selected mvno

    Map<String, dynamic> selectedTypeInfo = plansFormsInfo.firstWhere((item) => item['code'] == usimPlanInfo['carrier_type']); //seleceted type

    Map selectedCarrierInfo = selectedTypeInfo['carriers'].firstWhere((carrier) => carrier['code'] == usimPlanInfo['carrier_cd']);

    // var selectedMvnoInfo;
  }
}
