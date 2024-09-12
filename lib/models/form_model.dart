import 'package:flutter/material.dart';

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
      controller: TextEditingController(text: map['initialValue'] ?? ""),
      type: map['type'] ?? "input",
      maxwidth: (map['maxwidth'] ?? 400).toDouble(),
      placeholder: map['placeholder'] ?? "",
      label: map['label'] ?? "",
      errorMessage: map['errorMessage'] ?? "입력하세요",
      formRequired: map['required'] ?? true,
      options: [],
    );
  }
}
