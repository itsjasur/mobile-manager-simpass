import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatefulWidget {
  final bool enabled = true;
  final double? width;
  final double? menuHeight;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? label;
  final String? hintText;
  final String? helperText;
  final Widget? selectedTrailingIcon;
  final bool? enableFilter;
  final bool? enableSearch;
  final TextStyle? textStyle;
  final InputDecorationTheme? inputDecorationTheme;
  final MenuStyle? menuStyle;
  final TextEditingController? controller;
  final String? initialSelection;
  final void Function(String?)? onSelected;
  final bool? requestFocusOnTap;
  final EdgeInsets? expandedInsets;
  final int? Function(List<DropdownMenuEntry<String>>, String)? searchCallback;
  final List<DropdownMenuEntry<String>> dropdownMenuEntries;

  final String? errorText;

  const CustomDropdownMenu({
    super.key,
    this.width,
    this.menuHeight,
    this.leadingIcon,
    this.trailingIcon,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.selectedTrailingIcon,
    this.textStyle,
    this.inputDecorationTheme,
    this.menuStyle,
    this.controller,
    this.initialSelection,
    this.onSelected,
    this.requestFocusOnTap,
    this.expandedInsets,
    this.searchCallback,
    required this.dropdownMenuEntries,
    this.enableFilter,
    this.enableSearch,
  });

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          dropdownMenuEntries: widget.dropdownMenuEntries,
          controller: widget.controller,
          // requestFocusOnTap: widget.requestFocusOnTap,
          // enableFilter: widget.enableFilter ?? false,
          // enableSearch: widget.enableSearch ?? false,

          menuHeight: widget.menuHeight,
          onSelected: widget.onSelected,
          expandedInsets: widget.expandedInsets,
          label: widget.label,
          initialSelection: widget.initialSelection,
          textStyle: const TextStyle(fontSize: 15),
        ),
        if (widget.errorText != null)
          Text(
            widget.errorText!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 13,
              // fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
