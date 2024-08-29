import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/globals/validators.dart';

class FormDetail {
  TextEditingController controller;
  // InputFormatter? formatter;
  String type;
  double maxwidth;
  String placeholder;
  String label;
  String errorMessage;
  bool required;

  FormDetail({
    required this.controller,
    // this.formatter,
    required this.type,
    this.maxwidth = 300,
    this.placeholder = '',
    this.label = '',
    this.errorMessage = '입력하세요',
    this.required = true,
  });

  factory FormDetail.fromMap(Map<String, dynamic> map) {
    return FormDetail(
      controller: TextEditingController(text: map['value'] ?? ""),
      type: map['type'] ?? "input",
      maxwidth: (map['maxwidth'] ?? 400).toDouble(),
      placeholder: map['placeholder'] ?? "",
      label: map['label'] ?? "",
      errorMessage: map['errorMessage'] ?? "입력하세요",
      required: map['required'] ?? true,
    );
  }

  final CustomValidators _validator = CustomValidators();

  String? error(String formname) {
    if (['birthday', 'account_birthday', 'deputy_birthday'].contains(formname)) {
      return _validator.validateShortBirthday(controller.text);
    }
    if (['contact', 'phone_number', 'deputy_contact'].contains(formname)) {
      return _validator.validate010phoneNumber(controller.text, errorMessage);
    }

    return _validator.validateEmpty(controller.text, errorMessage);
  }

  TextCapitalization? capitalizeCharacters(String formname) {
    if (['name', 'account_name', 'deputy_name'].contains(formname)) {
      return TextCapitalization.characters;
    }

    return null;
  }

  OutlineInputBorder? isBordered(String formname, BuildContext context) {
    if (formname == 'usim_plan_nm') {
      return OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      );
    }
    return null;
  }

  //select feilds

  List<DropdownMenuEntry<String>> generateOptions(String formname, List<dynamic> options) {
    List<DropdownMenuEntry<String>>? optionsList = [];

    if (options.isNotEmpty) {
      controller.text = options[0]?['cd'] ?? "";
      for (var item in options) {
        optionsList.add(DropdownMenuEntry(value: item['cd'].toString(), label: item['value'].toString()));
      }
    }

    return optionsList;
  }
}
