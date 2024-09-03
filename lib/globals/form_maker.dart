import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile_manager_simpass/globals/validators.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';

class FormDetail {
  TextEditingController controller;
  String type;
  double maxwidth;
  String placeholder;
  String label;
  String errorMessage;
  bool formRequired;
  List<DropdownMenuEntry<String>> options;

  FormDetail({
    required this.controller,
    required this.type,
    this.maxwidth = 300,
    this.placeholder = '',
    this.label = '',
    required this.options,
    this.errorMessage = '입력하세요',
    this.formRequired = true,
  });

  factory FormDetail.fromMap(Map<String, dynamic> map) {
    return FormDetail(
      controller: TextEditingController(text: map['value'] ?? ""),
      type: map['type'] ?? "input",
      maxwidth: (map['maxwidth'] ?? 400).toDouble(),
      placeholder: map['placeholder'] ?? "",
      label: map['label'] ?? "",
      errorMessage: map['errorMessage'] ?? "입력하세요",
      formRequired: map['required'] ?? true,
      options: [],
    );
  }

  final CustomValidators _validator = CustomValidators();

  String? error(String formname, bool longDate) {
    if (!formRequired) {
      return null;
    }

    if (['birthday', 'account_birthday', 'deputy_birthday'].contains(formname)) {
      if (longDate) {
        return _validator.validateBirthday(controller.text);
      } else {
        return _validator.validateShortBirthday(controller.text);
      }
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

  void onChanged({required String formname, bool longDate = false}) {
    final newValue = controller.text;

    if (['contact', 'phone_number', 'deputy_contact'].contains(formname)) {
      controller.text = InputFormatter().formatPhoneNumber(newValue);
    }

    if (['birthday', 'account_birthday', 'deputy_birthday'].contains(formname)) {
      String maskedValue = "";

      if (longDate) {
        maskedValue = MaskTextInputFormatter(
          mask: '####-##-##',
          filter: {"#": RegExp(r'[0-9]')},
          type: MaskAutoCompletionType.lazy,
        ).maskText(newValue);

        maskedValue = InputFormatter().validateAndCorrectDate(maskedValue);
      } else {
        maskedValue = MaskTextInputFormatter(
          mask: '##-##-##',
          filter: {"#": RegExp(r'[0-9]')},
          type: MaskAutoCompletionType.lazy,
        ).maskText(newValue);
        maskedValue = InputFormatter().validateAndCorrectShortDate(maskedValue);
      }

      controller.text = maskedValue;
    }

    if (formname == 'wish_number') {
      String maskedValue = "";
      maskedValue = MaskTextInputFormatter(
        mask: '####/####/####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy,
        initialText: '',
      ).maskText(newValue);

      controller.text = maskedValue;
    }
  }

  bool readOnly(String formname) {
    if (['usim_plan_nm', 'address'].contains(formname)) {
      return true;
    }
    return false;
  }
}
