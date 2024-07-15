import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final Function(bool? newValue) onChanged;
  final bool value;
  final String text;
  const CustomCheckbox({super.key, required this.onChanged, required this.value, required this.text});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () => widget.onChanged(!widget.value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IgnorePointer(
            child: Transform.scale(
              scale: 1.15,
              child: SizedBox(
                width: 22,
                child: Checkbox(
                  value: widget.value,
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
