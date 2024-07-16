import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign = TextAlign.start;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus = false;
  final bool? readOnly;
  final AutovalidateMode? autovalidateMode;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final String? errorText;
  final TextStyle? errorTextStyle;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlignVertical,
    this.controller,
    this.errorText,
    this.autovalidateMode,
    this.decoration,
    this.onChanged,
    this.onTap,
    this.validator,
    this.obscureText,
    this.enabled,
    this.readOnly,
    this.inputFormatters,
    this.errorTextStyle,
    this.textCapitalization,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? _errorText;

  void _validateField(String? value) {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: widget.key,
          controller: widget.controller,
          initialValue: widget.initialValue,
          decoration: widget.decoration,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
          textInputAction: widget.textInputAction,
          style: widget.style?.copyWith(fontSize: 15) ?? const TextStyle(fontSize: 15),
          strutStyle: widget.strutStyle,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly ?? false,
          autovalidateMode: widget.autovalidateMode,
          obscureText: widget.obscureText ?? false,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            _validateField(value);
          },
          onTap: widget.onTap,
        ),
        if (widget.errorText != null)
          Text(
            widget.errorText!,
            style: widget.errorTextStyle == null
                ? const TextStyle(
                    color: Color.fromARGB(255, 255, 17, 0),
                    fontSize: 13,
                    // fontWeight: FontWeight.w600,
                  )
                : widget.errorTextStyle!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
          ),
        if (_errorText != null)
          Text(
            _errorText!,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 17, 0),
              fontSize: 13,
              // fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
