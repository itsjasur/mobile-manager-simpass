import 'package:flutter/material.dart';

class PopupHeader extends StatelessWidget {
  final String? title;
  const PopupHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 10),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null)
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close_outlined,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
